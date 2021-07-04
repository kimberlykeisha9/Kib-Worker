import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kibz/methods.dart';
import 'Strings.dart';

class SignIn extends StatefulWidget {
  @override
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  final emailString = TextEditingController();
  final passString = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool email_validate = false;
  bool pass_validate = false;

  @override
  void dispose() {
    emailString.dispose();
    passString.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    // ignore: unnecessary_statements
    Authorization().checkAuthState() ? Navigator.pushNamed(context, 'Dashboard') : null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 140,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: width,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                ),
                child: TextButton(
                  child: Text(reg(),
                      style: TextStyle(
                        color: const Color(0xFF00AC7C),
                        fontSize: 18,
                      )),
                  onPressed: () {
                    Navigator.pushNamed(context, 'Email');
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
                    borderRadius: new BorderRadius.only(bottomLeft: const Radius.circular(100.0))),
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
      body: Container(
          height: height,
          width: width,
          child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              width: width,
              height: height * 0.2,
              padding: EdgeInsets.only(left: 30, top: 40),
              child: Text(
                signin(),
                style: TextStyle(fontSize: 40),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
                width: width,
                height: height * 0.08,
                margin: EdgeInsets.only(
                  left: 30,
                  right: 30,
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
                    errorText: email_validate ? 'Please enter your email address' : null,
                    hintText: 'Email Address',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 15,
                    ),
                  ),
                )),
            Container(
              alignment: Alignment.centerLeft,
                width: width,
                height: height * 0.08,
                margin: EdgeInsets.only(
                  top: 20,
                  left: 30,
                  right: 30,
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
                    errorText: pass_validate ? 'Please enter your password' : null,
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
                left: 30,
                right: 30,
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
                width: width * 0.4,
                height: height * 0.08,
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
                    style: TextStyle(
                      color: const Color(0xFF00AC7C),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0.0,
                  onPressed: () {
                    setState(() {
                      emailString.text.isEmpty ? email_validate = true : email_validate = false;
                      passString.text.isEmpty ? pass_validate = true : pass_validate = false;
                    });
                    Authorization().signInWithEmailAndPassword(context, emailString.text, passString.text).then((val) {
                      uploadFCMToken();
                    });
                  },
                )),
          ]))),
    );
  }
}
