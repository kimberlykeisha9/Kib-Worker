import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailPass extends StatefulWidget {
  @override
  _EmailPass createState() => _EmailPass();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _EmailPass extends State<EmailPass> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final emailString = TextEditingController();
  final passString = TextEditingController();
  final confirmString = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    checkAuthState();
  }

  setSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Email', emailString.text);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 140,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: TextButton(
                      child: Text('Sign In',
                          style: TextStyle(
                            color: const Color(0xFF00AC7C),
                            fontSize: 18,
                          )),
                      onPressed: () {
                        Navigator.pushNamed(context, 'Sign In');
                      },
                    ),
                  ),
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(
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
                      width: width * 0.5,
                      height: height * 0.09,
                      margin: EdgeInsets.only(
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )),
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
          child: Text('Set up an email and password',
              style: TextStyle(
                fontSize: 19,
              ))),
            Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: width,
                  height: height * 0.08,
                  margin: EdgeInsets.only(
                    top: 30,
                    left: 35,
                    right: 35,
                  ),
                  child: TextFormField(
                    controller: emailString,
                    validator: (val) {
                      Pattern pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(pattern);
                      if (val.isEmpty) {
                        return 'Please enter your email address';
                      } else if (!regex.hasMatch(val)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      suffixIcon: Icon(Icons.email_outlined, size: 20),
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
                  child: TextFormField(
                    controller: passString,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter a password';
                      } else if (val.length < 6) {
                        return 'Please enter a stronger password';
                      } else if (val != confirmString.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: Icon(Icons.https_outlined, size: 20),
                    ),
                    obscureText: true,
                  )),
              Container(
                  width: width,
                  height: height * 0.08,
                  margin: EdgeInsets.only(
                    top: 30,
                    left: 35,
                    right: 35,
                  ),
                  child: TextFormField(
                    controller: confirmString,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter your confirmed password';
                      } else if (val != passString.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                    obscureText: true,
                  )),
            ]),
            ),
          ]),
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
              if (_formKey.currentState.validate()) {
                createUserWithEmailAndPassword();
                setSharedPreferences();
              }
            },
          )),
    );
  }

  void checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('Nothing to see here');
      } else if (user != null) {
        print('Registered User Successfully');
        if (!user.emailVerified) {
          user.sendEmailVerification();
          print('Sent Email Verification');
        }
      }
    });
  }

  void createUserWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailString.text, password: passString.text);
      checkAuthState();
      Navigator.pushNamed(context, 'Names');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Password too weak man');
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10.0),
          content: Text('Password is too weak. Please set a stronger password'),
        ));
      } else if (e.code == 'email-already-in-use') {
        print('Email in Use');
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10.0),
          content: Text(
              'This email address is already in use. Please use another one or sign in '
              'instead'),
          action: SnackBarAction(
            label: 'Sign In',
            textColor: Color(0xFF00AC7C),
            onPressed: () {
              Navigator.pushNamed(context, 'Sign In');
            },
          ),
        ));
      }
    } catch (e) {
      print(e);
    }
  }
}
