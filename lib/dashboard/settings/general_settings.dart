import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettings createState() => _GeneralSettings();
}

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class _GeneralSettings extends State<GeneralSettings> {
  String loadedname;
  File ppImage;

  void initState() {
    super.initState();
    checkAuthState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('General Settings',
                style: TextStyle(color: Color(0xFF00AC7C))),
            backgroundColor: Colors.grey[850],
            toolbarHeight: height * 0.13,
            leading: Container(
              margin: EdgeInsets.only(
                left: 25,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:
                    Icon(Icons.arrow_back, color: Color(0xFF00AC7C), size: 30),
              ),
            ),
          ),
          body: Container(
              margin: EdgeInsets.all(25),
              width: width,
              height: height,
              child: ListView(children: [
                ListTile(
                    title: Container(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            child: Text('Notification Settings',
                                style: TextStyle(
                                  color: Color(0xFF00AC7C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )))),
                    subtitle: Container(
                        child: Text(
                            'Change the notifications and frequency of notifications received '
                            'from Kibarua',
                            style: TextStyle(fontSize: 16)))),
                ListTile(
                    title: Container(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            child: Text('Theme',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00AC7C),
                                  fontSize: 20,
                                )))),
                    subtitle: Container(
                        child: Text('Change how Kibarua looks',
                            style: TextStyle(fontSize: 16)))),
              ]))),
    );
  }

  void checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user == null) {
        Navigator.pushNamed(context, 'Welcome');
      } else {
        print('User is logged in');
      }
    });
  }
}
