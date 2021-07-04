import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kibz/Strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class VerifiedAccount extends StatefulWidget {
  @override
  _VerifiedAccount createState() => _VerifiedAccount();
}

class _VerifiedAccount extends State<VerifiedAccount> {
  final passString = TextEditingController();
  final emailString = TextEditingController();
  bool emailValidate;
  bool passValidate;

  @override
  void initState() {
    super.initState();
    _retrieveDynamicLink();
  }

  Future<void> _retrieveDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
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
                            reg(),
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
              child: Text('Account Verified',
                  style: TextStyle(
                      color: Color(0xFF00AC7C),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left)),
          Container(
              margin: EdgeInsets.only(
                top: 35,
                left: 32,
                right: 35,
              ),
              child: Text(
                  '''Your account has been verified.

''' +
                      'Now all that is left to do is add a profile picture, add payment details and tell us your '
                          'Work Preferences',
                  style: TextStyle(
                    fontSize: 19,
                  ))),
          Container(
              width: width * 0.75,
              margin: EdgeInsets.only(
                top: 35,
                left: 32,
              ),
              child: Text(
                  '*  Please ensure you have read the Code of Conduct attached to '
                  'your verification email',
                  style: TextStyle(
                      color: Color(0xFF00AC7C),
                      fontSize: 16,
                      fontWeight: FontWeight.w100),
                  textAlign: TextAlign.left)),
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
              checkAuthState();
            },
          )),
    );
  }

  void checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('No user was found');
        signInDialog(context);
      } else {
        Navigator.pushNamed(context, 'Profile Picture Upload');
        print('User is in');
      }
    });
  }

  signInDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return new AlertDialog(
              content: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width,
                    height: height * 0.2,
                    padding: EdgeInsets.only(left: 3, top: 40),
                    child: Text(
                      signin(),
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  Container(
                      width: width,
                      height: height * 0.08,
                      margin: EdgeInsets.only(
                        left: 3,
                        right: 3,
                      ),
                      decoration: new BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[850],
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: emailString,
                        autofillHints: [AutofillHints.email],
                        decoration: InputDecoration(
                          errorText: emailValidate
                              ? 'Please enter your email address'
                              : null,
                          hintText: email(),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            left: 15,
                          ),
                        ),
                      )),
                  Container(
                      width: width,
                      height: height * 0.08,
                      margin: EdgeInsets.only(
                        top: 20,
                        left: 3,
                        right: 3,
                      ),
                      decoration: new BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[850],
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: passString,
                        obscureText: true,
                        autofillHints: [AutofillHints.password],
                        decoration: InputDecoration(
                          errorText: passValidate
                              ? 'Please enter your password'
                              : null,
                          hintText: pass(),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            left: 15,
                          ),
                        ),
                      )),
                  Container(
                    alignment: Alignment.centerRight,
                    width: width,
                    height: height * 0.06,
                    margin: EdgeInsets.only(
                      top: 20,
                      left: 3,
                      right: 3,
                    ),
                    child: TextButton(
                      child: Text(
                        forgot(),
                        style: TextStyle(
                          color: const Color(0xFF00AC7C),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      width: width * 0.6,
                      height: height * 0.09,
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FloatingActionButton.extended(
                        backgroundColor: Colors.grey[850],
                        label: Text(
                          signin(),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 0.0,
                        onPressed: () {
                          setState(() {
                            emailString.text.isEmpty
                                ? emailValidate = true
                                : emailValidate = false;
                            passString.text.isEmpty
                                ? passValidate = true
                                : passValidate = false;
                          });
                          signInWithEmailAndPassword();
                        },
                      )),
                ]),
          ));
        });
  }

  void signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailString.text, password: passString.text);
      Navigator.pushNamed(context, 'Profile Picture Upload');
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
