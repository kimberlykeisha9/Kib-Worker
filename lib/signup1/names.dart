import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Name extends StatefulWidget {
  @override
  _Name createState() => _Name();
}

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFunctions functions = FirebaseFunctions.instance;

class _Name extends State<Name> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final fnameString = TextEditingController();
  final lnameString = TextEditingController();
  bool fname_val = false;
  bool lname_val = false;

  void initState() {
    super.initState();
    checkAuthState();
  }

  setSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('First', fnameString.text);
    prefs.setString('Last', lnameString.text);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
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
              width: width * 0.5,
              margin: EdgeInsets.only(
                top: 15,
                left: 32,
              ),
              child: Text('Basic Information',
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
              child: Text('What is your name?',
                  style: TextStyle(
                    fontSize: 19,
                  ))),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                width: width,
                height: height * 0.08,
                margin: EdgeInsets.only(
                  top: 30,
                  left: 35,
                  right: 35,
                ),
                // decoration: new BoxDecoration(
                //   border: Border.all(
                //     color: Colors.grey[850],
                //     width: 1,
                //   ),
                //   borderRadius: BorderRadius.circular(12),
                // ),
                child: TextField(
                  controller: fnameString,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    errorText:
                        fname_val ? 'Please enter your first name' : null,
                    hintText: 'First Name',
                    // suffixIcon: Icon(Icons.account_circle_outlined, size: 20),
                  ),
                )),
            Container(
                width: width,
                height: height * 0.08,
                margin: EdgeInsets.only(
                  top: 30,
                  left: 35,
                  right: 35,
                ),
                // decoration: new BoxDecoration(
                //   border: Border.all(
                //     color: Colors.grey[850],
                //     width: 1,
                //   ),
                //   borderRadius: BorderRadius.circular(12),
                // ),
                child: TextField(
                  controller: lnameString,
                  decoration: InputDecoration(
                    errorText: lname_val ? 'Please enter your last name' : null,
                    hintText: 'Last Name',
                    // suffixIcon: Icon(Icons.https_outlined, size: 20),
                  ),
                )),
          ]),
        ])),
      ),
      bottomNavigationBar: Container(
          width: width,
          height: height * 0.10,
          margin: EdgeInsets.all(35),
          child: FloatingActionButton.extended(
            label: Text('Next'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 5.0,
            backgroundColor: Colors.grey[850],
            onPressed: () {
              setState(() {
                fnameString.text.isEmpty ? fname_val = true : fname_val = false;
                lnameString.text.isEmpty ? lname_val = true : lname_val = false;
              });
              if (fnameString.text.isEmpty & lnameString.text.isEmpty) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(10.0),
                  content: Text('Please fill in all the fields'),
                ));
              } else {
                setSharedPreferences();
                Navigator.pushNamed(context, 'DOB');
              }
            },
          )),
    );
  }

  void checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('No user was found so redirected');
        Navigator.pushNamed(context, 'Home');
      } else {
        print('user still signed in thaank god');
      }
    });
  }
}
