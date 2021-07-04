import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kibz/methods.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../employee.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  bool verificationStatus = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // Set Profile Image
    ppImage = Provider.of<ImageSelector>(context).image;
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Profile', style: TextStyle(color: Color(0xFF00AC7C))),
            backgroundColor: Colors.grey[850],
            toolbarHeight: height * 0.13,
            leading: Container(
              margin: EdgeInsets.only(
                left: 25,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:
                    Icon(Icons.arrow_back, color: Color(0xFF00AC7C), size: 30),
              ),
            ),
          ),
          body: SlideInDown(
            child: Container(
                margin: EdgeInsets.all(25),
                width: width,
                height: height,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                              //  color: Colors.grey,
                              width: 120,
                              height: 120,
                              child: pp == null ? Icon(
                                Icons.account_circle_outlined,
                                size: 110,
                              ) : ClipOval(
                                            child: Container(
                                              width: 110,
                                              height: 110,
                                              child: Image.network(
                                                pp,
                                                fit: BoxFit.cover,
                                                filterQuality: FilterQuality.high,
                                              ),
                                            ),
                                          ),) ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            child: TextButton(
                                onPressed: () {
                                  Provider.of<ImageSelector>(context, listen: false).showPicker(context);
                                },
                                child: Text(
                                  'Change profile picture',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF00AC7C)),
                                ))),
                      ),
                      Container(
                          child: Text(
                        '$firstName $lastName',
                        style: TextStyle(fontSize: 30),
                      )),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            'Email: $email',
                            style: TextStyle(fontSize: 18),
                          )),
                      Container(
                          child: TextButton(
                              child: Text(
                        'Change email address',
                        style: TextStyle(fontSize: 15, color: Color(0xFF00AC7C)),
                      ))),
                      Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Text(
                            'Phone: $phone',
                            style: TextStyle(fontSize: 18),
                          )),
                      Container(
                          child: TextButton(
                              child: Text(
                        'Change phone number',
                        style: TextStyle(fontSize: 15, color: Color(0xFF00AC7C)),
                      ))),
                      Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Text(
                            'Password: (unchanged)',
                            style: TextStyle(fontSize: 18),
                          )),
                      Container(
                          child: TextButton(
                              child: Text(
                        'Change password',
                        style: TextStyle(fontSize: 15, color: Color(0xFF00AC7C)),
                      ))),
                      Expanded(
                          child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Text(
                              'Rating: 5/5',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      ))
                    ])),
          )),
    );
  }

  void _checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user == null) {
        Navigator.pushNamed(
            context, 'Welcome');
      } else {
        print('User is logged in');
      }
    });
  }

}
