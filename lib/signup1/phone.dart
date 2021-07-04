import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phone extends StatefulWidget {
  @override
  _Phone createState() => _Phone();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _Phone extends State<Phone> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final phoneString = TextEditingController();
  final smsController = TextEditingController();
  bool phone_val = false;
  String cc = '+254';

  setSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Phone', cc + phoneString.text);
  }

  @override
  Widget build(BuildContext context) {
    checkAuthState();
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
              child: Text('Please enter your phone number',
                  style: TextStyle(
                    fontSize: 19,
                  ))),
          Row(children: [
            Container(
                width: width * 0.2,
                height: height * 0.15,
                margin: EdgeInsets.only(
                  bottom: 30,
                  left: 35,
                  top: 10,
                ),
                child: CountryCodePicker(
                  initialSelection: 'KE',
                  favorite: ['KE', 'TZ', 'UG'],
                  onChanged: _onCountryChange,
                )),
            Container(
              width: width * 0.55,
              height: height * 0.15,
              margin: EdgeInsets.only(
                top: 30,
                left: 15,
                right: 35,
              ),
              child: TextFormField(
                controller: phoneString,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    errorText: phone_val ? 'Please enter your number' : null,
                    hintText: 'Phone number',
                    suffixIcon: Icon(Icons.phone_outlined)),
                maxLength: 9,
              ),
            ),
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
                phoneString.text.isEmpty ? phone_val = true : phone_val = false;
              });
              if (phoneString.text.isEmpty) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(10.0),
                  content: Text('Please enter your phone number'),
                ));
              } else if (phoneString.text.length < 9) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(10.0),
                  content: Text('Please enter a valid phone number'),
                ));
              } else {
                confirmNumber();
                // Navigator.push(context, CupertinoPageRoute(builder: (context) => IdDoc()));
              }
            },
          )),
    );
  }

  void _onCountryChange(CountryCode value) {
    this.cc = value.toString();
  }

  String phoneNo;
  String smsCode;
  String verificationId;

  void confirmNumber() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: Text('Verify the number'),
              content: SingleChildScrollView(
                  child: Column(children: [
                Container(
                    child: Text(cc + ' ' + phoneString.text,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      verifyPhoneNumber();
                    },
                    child: Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('No')),
              ])));
        });
  }

  void verifyPhoneNumber() async {
    User user = auth.currentUser;
    print('main');

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      print('timed out');
      this.verificationId = verId;
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10.0),
          content: Text('Code has timed out. Please try again'),
          action: SnackBarAction(
              label: 'Retry',
              onPressed: verifyPhoneNumber,
              textColor: Color(0xFF00AC7C)),
        ),
      );
    };

    PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) async {
      print('sent code');
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('phone number code matches');
      });
    };

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) {
      auth.currentUser.linkWithCredential(phoneAuthCredential);
      print(
          "Phone number automatically verified and linked: ${auth.currentUser.uid}");
      Navigator.pushNamed(context, 'ID');
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: cc + phoneString.text,
          codeAutoRetrievalTimeout: autoRetrieve,
          timeout: const Duration(seconds: 30),
          codeSent: smsCodeSent,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed);
    } catch (e) {
      print(e);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        content: Text(e),
      ));
    }
  }

  void checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('No user was found so redirected');
        Navigator.pushNamed(context, 'Home');
      } else {
        print('still signed in so I can verify number');
      }
    });
  }

  smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: smsController,
              maxLength: 6,
              onChanged: (value) {
                smsCode = value;
              },
            ),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  linkWithCredential();
                },
              )
            ],
          );
        });
  }

  void linkWithCredential() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsController.text,
      );

      final User user =
          (await auth.currentUser.linkWithCredential(credential)).user;

      print("Successfully linked UID: ${user.uid}");
      Navigator.pushNamed(context, 'ID');
      setSharedPreferences();
    }
    catch (e) {
      print(e.toString());
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        content: Text('Failed to link phone' + e.toString()),
        action: SnackBarAction(
            label: 'Retry',
            onPressed: verifyPhoneNumber,
            textColor: Color(0xFF00AC7C)),
      ));
    }
  }
}
