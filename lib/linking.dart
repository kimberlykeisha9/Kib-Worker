import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as mainDatabase;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'employee.dart';
import 'employer.dart';
import 'methods.dart';

// Main application
FirebaseApp main = Firebase.app('Main');
mainDatabase.FirebaseFirestore mainDB = mainDatabase.FirebaseFirestore.instanceFor(app: main);
mainDatabase.CollectionReference employerDB = mainDB.collection('users');
mainDatabase.CollectionReference employerRecords = mainDB.collection('user-records');

final geo = Geoflutterfire();

String transactionCode;
String paymentNumber;

String task;
double amount;
double amountDue = (80 / 100) * amount;

int ratingGiven;
int ratingReceived;

class Linking {
  // TODO Handle payment via MPESA
  Future _makePayment() {}

  // TODO Listen for changes in payment
  checkPaymentDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    DocumentReference currentJob = records.doc(pref.getString('docID'));

    currentJob.snapshots().listen((doc) {
      var paymentState = doc.get('paymentCompleted');

      if (paymentState == 'pending') {
        print('Job has been finished so payment is yet to happen');
        try {
          _makePayment().then((value) {
            currentJob.update({
              'paymentCompleted': 'success',
              'paymentTo': null,
              'transactionCode': null,
            });
          }, onError: (e) {
            print(e);
            currentJob.update({'paymentCompleted': 'failed'});
          });
        } catch (e) {
          currentJob.update({'paymentCompleted': 'failed'});
        }
      }
    });
  }

  // TODO Upload user's location
  Future<void> uploadLocation(BuildContext context) async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print('Service not enabled');
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('The user has refused to grant service');
        showSnackbar(
            context,
            'Please grant us permission to your location so that we can send you '
            'job offers');
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print('User has not granted permission');
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('User has refused to grant permission');
        showSnackbar(
            context,
            'Please allow us access to your location '
            'in order to receive jobs');
        return;
      }
    } else {
      await location.getLocation().then((location) {
        GeoFirePoint userLocation = geo.point(
          latitude: location.latitude,
          longitude: location.longitude,
        );
        userInfo.update({
          'location': userLocation.data,
        });
      });
    }
  }

  // Handle what to do if employer is engaged
  checkEmployerStatus(BuildContext context, String fname, String lname, String profile, double empRating, String currentTask, double currentAmount) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //Employer Data
    mainDatabase.DocumentReference employerDoc = employerDB.doc(pref.getString('employerUID'));
    mainDatabase.CollectionReference employerJobRecord =
        employerRecords.doc(pref.getString('employerUID')).collection('records');
    // Check if user is already engaged
    bool _employerEngaged;
    bool _employeeEngaged;

    userInfo.get().then((doc) {
      _employeeEngaged = doc.get('isEngaged');
      if (_employeeEngaged == true) {
        Navigator.pushNamed(context, 'Dashboard').then((value) => showSnackbar(context, 'You are already engaged'));
      } else {
        employerDoc.get().then((doc) {
          _employerEngaged = doc.get('isEngaged');
        }).then((value) {
          if (_employerEngaged == true) {
            print('user is engaged'); // Don't connect if user is engaged
            Navigator.pushNamed(context, 'Dashboard').then((value) => showDialog(
                context: context,
                builder: (_) {
                  return SimpleDialog(
                    children: [Center(child: Text('This user has already been linked', textAlign: TextAlign.center))],
                  );
                }));
          } else if (_employerEngaged == false) {
            print('user isnt engaged');
            employerJobRecord.add({
              'employeeFirst': fname,
              'employeeLast': lname,
              'employeeUID': user,
              'employeePP': profile,
              'employeeRating': empRating,
              'employeePhone': auth.currentUser.phoneNumber,
              'task' : currentTask,
              'amount' : currentAmount,
            }).then((value) {
              employerDoc.update({
                'isEngaged': true,
                'currentJob': value,
              }).then((val) {
                _engageUser().then((value) {
                  _createRecordOfJob();
                  Navigator.pushNamed(context, 'Dashboard');
                });
              });
            });
          }
        });
      }
    });
  }

  Future _engageUser() {
    return userInfo.update({'isEngaged': true});
  }

// Creates a document on database about current job
  _createRecordOfJob() {
    userHistory.collection('records').add({
      'Worked for': '$employerFirst $employerLast',
      'Employer UID': employerUID,
      'Date': '$currentDay/$currentMonth/$currentYear',
      'Total Amount': amount,
      'Amount You Received': amountDue,
      'Started at': '${currentHour.toString()}:${currentMinute.toString()}',
      'Started': Timestamp.now(),
      'Ended at': 'Ongoing',
      'paymentCompleted': 'incomplete'
    }).then((value) {
      storeData('docID', value.id);
      userInfo.update({'currentJob': value});
    });
  }

// Sends information to firebase when a job is completed
  _finishJob() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String doc = pref.getString('docID');

    userHistory.collection('records').doc(doc).update({
      'Ended at': '$currentHour:$currentMinute',
      'Transaction Code': transactionCode,
      'Paid To': paymentNumber,
      'Job Done': jobsDone,
      'Rating Given': ratingGiven,
      'Rating Received': ratingReceived,
    });
    _removeEngagedStatus();
  }

// Sets isEngaged Status to false on database
  _removeEngagedStatus() {
    userInfo.update({'isEngaged': false});
  }

// Dialog that prompts user if they want to cancel the job
  cancelJobDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Are you sure you want to cancel?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'You will not receive any payment if you cancel',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _cancelJob().then((val) => Navigator.pop(context));
                  },
                  child: Text('Cancel Job', style: TextStyle(color: Color(0xFF00AC7C), fontWeight: FontWeight.bold))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Continue Job', style: TextStyle(color: Color(0xFF00AC7C), fontWeight: FontWeight.bold))),
            ],
          );
        });
  }

  // Cancels Job
  Future _cancelJob() async {
    // Get current job's documentID
    SharedPreferences pref = await SharedPreferences.getInstance();
    String doc = pref.getString('docID');
    //Employer Data
    mainDatabase.DocumentReference employerDoc = employerDB.doc(pref.getString('employerUID'));

    return employerDoc.update({
      'isEngaged': false, // Disengages employer
    }).then((value) {
      DocumentReference activeJob;
// Updates employer record
      employerDoc.get().then((doc) {
        activeJob = doc.get('currentJob');
        activeJob.update({
          'Ended at': '${currentHour.toString()}:${currentMinute.toString()}',
          'Ended': Timestamp.now(),
          'paymentCompleted': 'cancelledByWorker',
        });
      });
    }).then((value) {
      userInfo.update({
        'cancelledJobs': FieldValue.increment(1), // Adds to amount of cancelled jobs
        'isEngaged': false, // Disengage user
      }).then((value) {
        records.doc(doc).update({
          'Ended at': '${currentHour.toString()}:${currentMinute.toString()}',
          'Ended': Timestamp.now(),
          'paymentCompleted': 'cancelledByWorker', // Job was cancelled so no payment due
        });
      });
    });
  }

  Future<int> _checkCancelledJobs() async {
    int cancelledJobs;
    await userInfo.get().then((doc) {
      cancelledJobs = doc.get('cancelledJobs');
    });
    print('This user has cancelled $cancelledJobs jobs');
    return cancelledJobs;
  }

// Dialog that prompts use if the job is complete
  finishJobDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Are you sure you\'ve finished your taks for $employerFirst?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            actions: [
              Center(
                child: TextButton(
                    onPressed: () {
                      _finishJob();
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackDialog()));
                    },
                    child: Text('Finish Job', style: TextStyle(color: Color(0xFF00AC7C), fontWeight: FontWeight.bold))),
              ),
              Center(
                child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(color: Color(0xFF00AC7C), fontWeight: FontWeight.bold))),
              ),
            ],
          );
        });
  }
}

// Class that shows Feedback Dialog
class FeedbackDialog extends StatefulWidget {
  @override
  _Feedback createState() => _Feedback();
}

class _Feedback extends State<FeedbackDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Text(
          'You\'ve completed your job with $employerFirst $employerLast',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Wrap(
            children: [
              Text(
                'How was your experience working with $employerFirst?',
                textAlign: TextAlign.center,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    height: 80,
                    width: 60,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('${rating.toInt()}',
                            style: TextStyle(color: Color(0xFF00AC7C), fontSize: 25, fontWeight: FontWeight.bold)),
                        Icon(Icons.star, size: 25, color: Color(0xFF00AC7C)),
                      ],
                    )),
              ),
              Slider(
                  min: 1,
                  max: 5,
                  divisions: 4,
                  value: rating,
                  onChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                  }),
              Center(child: Text(ratingAid(), style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00AC7C)))),
              Container(
                alignment: Alignment.bottomCenter,
                height: 80,
                child: TextField(
                    controller: ratingNotes,
                    maxLines: 2,
                    decoration: InputDecoration(hintText: 'Any additional comment?')),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              child: Text('Continue', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                sendRating();
                Navigator.pushNamed(context, 'Dashboard');
              }),
        ],
      ),
    );
  }

  double rating = 5;
  String ratingAid() {
    if (rating == 1) {
      return 'Terrible';
    }
    if (rating == 2) {
      return 'Bad';
    }
    if (rating == 3) {
      return 'Okay';
    }
    if (rating == 4) {
      return 'Good';
    }
    if (rating == 5) {
      return 'Excellent';
    }
    return 'Excellent';
  }

  sendRating() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String docID = pref.getString('docID');
    records.doc(docID).update({
      'Rating Given': rating,
      'Rating Notes': ratingNotes.text,
    });
  }

  final ratingNotes = new TextEditingController();
}
