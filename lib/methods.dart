import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'employee.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'linking.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFunctions functions = FirebaseFunctions.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

Reference ref = storage.ref().child('users').child(auth.currentUser.uid).child('User Information');
DocumentReference userInfo = firestore.collection('user-info').doc(auth.currentUser.uid);
DocumentReference userHistory = firestore.collection('user-history').doc(auth.currentUser.uid);

HttpsCallable callable = functions.httpsCallable('addMessage');
HttpsCallable search = functions.httpsCallable('searchForWorkers');

final picker = ImagePicker();
File ppImage;

CollectionReference records = userHistory.collection('records');
dynamic jobsDone;
//Current Time
int currentHour = DateTime.now().hour;
int currentMinute = DateTime.now().minute;
int currentDay = DateTime.now().day;
int currentMonth = DateTime.now().month;
int currentYear = DateTime.now().year;

// To show snackbar
showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

// Saves user information to Shared Preferences
storeData(String title, String saved) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(title, saved);
}

// Gets user information from firestore and saves them to shared preferences
Future<void> getUserData() {
  String firstName;
  String lastName;
  String pp;
  String accStat;

  Map<String, dynamic> info;

  return userInfo.get().then((value) {
    print('gottee');
    info = value.get(FieldPath(['basicInformation']));
    firstName = info['firstName'];
    lastName = info['lastName'];
    pp = info['profilePicture'];
    accStat = value.get(FieldPath(['accountStatus']));
    phone = info['phone'];
    paymentNumber = value.get(FieldPath(['paymentNumber']));
    print('$info');
  }).then((value) {
    storeData('fname', firstName);
    storeData('lname', lastName);
    storeData('pp', pp);
    storeData('accStat', accStat);
    storeData('paymentNumber', paymentNumber);
  });
}

// Cloud Function that searches for workers in the database
searchForWorker(String token, String profile) async {
  String selected = 'Laundry';
  try {
    final HttpsCallableResult result = await search.call(<String, dynamic>{
      'fname': 'Kimberly',
      'lastname': 'Kuya',
      'selected': selected,
      'uid': auth.currentUser.uid,
      'profile': profile,
      'rating': '4.8',
      'amount': '300',
      'phone': '+254795577084',
      'token' : token
    });
    print(result.data);
  } on FirebaseFunctionsException catch (e) {
    print(e.code);
  }
}

// Checks if location is enabled then gets user current location
getLocation() async {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    print('Location service is not enabled');
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  _locationData = await location.getLocation();
  var latitude = _locationData.latitude;
  var longitude = _locationData.longitude;
  print(_locationData);
  firestore.collection('user-info').doc(user).update({
    'currentLocation': GeoPoint(latitude, longitude),
  });
}

// Get user's current Location
promptLocation() async {
  Location location = new Location();
  var currentLocation = await location.getLocation();
  var currentLatitude = currentLocation.latitude;
  var currentLongitude = currentLocation.longitude;
  double northBoundary = currentLocation.latitude + 0.002444;
  double southBoundary = currentLocation.latitude - 0.002444;
  double eastBoundary = currentLocation.longitude + 0.004557;
  double westBoundary = currentLocation.longitude - 0.004557;
  print(currentLongitude);
  print(currentLatitude);
  double testLongitude = 36.65600;
  double testLatitude = -1.36009;
  if (testLongitude <= eastBoundary &&
      testLatitude <= northBoundary &&
      testLatitude >= southBoundary &&
      testLongitude >= westBoundary) {
    print('User is within boundary');
  } else {
    print('User is out of the boundary');
  }
}

// Gets user's device token in order to send notifications
void uploadFCMToken() {
  messaging.getToken().then((token) {
    print(token);
    firestore.collection('user-info').doc(auth.currentUser.uid).update({'token': token});
  });
}


// Gets Profile Picture Data
class ImageSelector extends ChangeNotifier {
  File _image;
  String imageLink;

  File get image {
    return _image;
  }

  String get link {
    return imageLink;
  }

  Future imgFromCamera(BuildContext context) async {
    final image = await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      _image = File(image.path);
      notifyListeners();
    }
  }

  Future imgFromGallery(BuildContext context) async {
    final image = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      _image = File(image.path);
      notifyListeners();
    }
  }
  // To show the Image Picker
  void showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(builder: (context, setState) {
          return SlideInUp(
            child: SafeArea(
              child: Container(
                child: new Wrap(children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                     imgFromGallery(context);
                      Navigator.of(context).pop();
                    }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera(context);
                      Navigator.of(context).pop();
                    }),
                ])),
            ),
          );
        });
      });
  }
}

class Upload extends ImageSelector {
  String _ppLink;
  // TODO Get profile picture link
  getPPLink() async {
    var pp = ref.child('Basic Information').child('ProfileImage');
    var ppURL = await pp.getDownloadURL();
    try {
      _ppLink = ppURL.toString();
      print('Gotten user profile picture link');
      print(_ppLink);
      storeData('pp', _ppLink);
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
    }
  }
  // Upload Profile Picture
  Future<void> uploadPP() async {
    try {
      await ref.child('Basic Information').child('ProfileImage').putFile(image);
      print('uploaded pp');
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}

class Authorization {
  // Current user from firebase
  var _user = auth.currentUser;

// TODO: Checks if user has a verified email address
// If the user is not verified, a snackbar prompts them to verify it or resend the email
// The user is then signed out after ten seconds
  bool checkEmailVerification(BuildContext context) {
    if (!_user.emailVerified) {
      Future.delayed(Duration(seconds: 10), () => signOut(context));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Your email has not been verified. Please check your email in order to '
            'proceed.'),
        action: SnackBarAction(
          label: 'Resend Email',
          onPressed: () => _user.sendEmailVerification(),
        ),
        duration: Duration(seconds: 10),
      ));
    }
    return _user.emailVerified;
  }

// TODO: Signs in user using Firebase Authentication
  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
        if (checkAuthState() == true) {
          checkEmailVerification(context);
          if (checkEmailVerification(context) == true) {
            getUserData().then((value) => Navigator.pushNamed(context, 'Dashboard'));
          } else if (checkEmailVerification(context) == false) {
            print('User email was not verified');
          }
        } else {
          showSnackbar(context, 'An error has occured');
        }
        return null;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar(context, 'No account found under this email');
      } else if (e.code == 'wrong-password') {
        showSnackbar(context, 'Please enter the correct password');
      }
    }
  }

  // TODO: Signs user out
  Future<void> signOut(BuildContext context) async {
    userInfo.update({'token': null}).then((value) => print('Token cleared'));
    print('signed out user: ' + user);
    return auth.signOut();
  }

  // TODO: Checks user's authentication state
  bool checkAuthState() {
    if (_user != null) {
      print('There is a user');
    } else {
      print('There is no user');
    }
    return _user != null;
  }
}
