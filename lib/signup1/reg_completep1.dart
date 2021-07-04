import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class P1Complete extends StatefulWidget {
  @override
  _P1Complete createState() => _P1Complete();
}

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFunctions functions = FirebaseFunctions.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

class _P1Complete extends State<P1Complete> {
  String email;
  String fname;
  String lname;
  String dob;
  String phone;
  String id;
  HttpsCallable callable = functions.httpsCallable('addData');
  String fcmToken;

  getFCMToken() {
    messaging.getToken().then((token) {
      setState((){
        fcmToken = token;
      });
    });
  }

  sendData() async {
    try {
      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'fname': fname,
        'lname': lname,
        'phone': phone,
        'email': email,
        'dob': dob,
        'id': id,
        'token' : fcmToken,
      });
      print(result);
    } on FirebaseFunctionsException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('Email');
      fname = prefs.getString('First');
      lname = prefs.getString('Last');
      dob = prefs.getString('DOB');
      phone = prefs.getString('Phone');
    });
    print(email);
    print(fname);
    print(lname);
    print(dob);
    print(phone);
  }

  Reference ref = storage
      .ref()
      .child('users')
      .child(auth.currentUser.uid)
      .child('User Information');

  getIDURL() async {
    var idPhoto = ref.child('Identification Information').child('ID');
    var idURL = await idPhoto.getDownloadURL();
    setState(() {
      id = idURL.toString();
    });
    print(id);
    return id;
  }

  // CollectionReference users = firestore.collection('Users');

  // void uploadData() {
  //   try {
  //     users.doc(auth.currentUser.uid).set({
  //       'First Name' : fname,
  //       'Last Name' : lname,
  //       'Account Verification Status' : false,
  //       'Date Created' : '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
  //     });
  //     Navigator.pushNamed(context, 'Home');
  //   }
  //   on FirebaseException catch (e) {
  //     print(e);
  //   }
  //   catch (e) {
  //     print(e);
  //   }
  // }

  void initState() {
    super.initState();
    getSharedPreferences();
    getIDURL();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(
                      left: 29,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            // margin: EdgeInsets.only(
                            //   top: 20,
                            // )
                            ),
                        Container(
                          width: width * 0.5,
                          height: height * 0.09,
                          margin: EdgeInsets.only(
                            top: 115,
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
                Container(
                  width: 120,
                  height: 140,
                  padding: const EdgeInsets.only(
                    top: 35.0,
                    bottom: 35.0,
                    left: 30.0,
                  ),
                  decoration: new BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: new BorderRadius.only(
                          bottomLeft: const Radius.circular(100.0))),
                  child: Image.asset(
                    'assets/images/greeniconlogo.png',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                ),
              ]),
          Container(
              width: width,
              margin: EdgeInsets.only(
                top: 15,
                left: 32,
              ),
              child: Text('Account set up complete',
                  style: TextStyle(
                      color: Color(0xFF00AC7C),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left)),
          Container(
              margin: EdgeInsets.only(
                top: 25,
                left: 32,
                right: 35,
              ),
              child: Text(
                  'Alright you have succesfully created your worker account. '
                  'Our team will review your details and you should receive an email response '
                  'within 24 hours that will confirm the status of your account and you may continue '
                  'setting it up. If there is any error, the email will guide you on how to fix it. '
                  'We look forward to working with you!',
                  style: TextStyle(
                    fontSize: 19,
                  ))),
        ])),
      ),
      bottomNavigationBar: Container(
          width: width,
          height: height * 0.10,
          margin: EdgeInsets.all(35),
          child: FloatingActionButton.extended(
            label: Text('Ok'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 5.0,
            backgroundColor: Colors.grey[850],
            onPressed: () {
              //uploadData();
              sendData();
            },
          )),
    );
  }
}
