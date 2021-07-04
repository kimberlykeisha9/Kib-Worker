import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AccountSettings extends StatefulWidget {
  @override
  _AccountSettings createState() => _AccountSettings();
}

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class _AccountSettings extends State<AccountSettings> {
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
            title: Text('Account Settings',
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
                            child: Text('Change payment information',
                                style: TextStyle(
                                  color: Color(0xFF00AC7C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )))),
                    subtitle: Container(
                        child: Text('Edit how we will send you your payment',
                            style: TextStyle(fontSize: 16)))),
                ListTile(
                    title: Container(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            child: Text('Change your work preferences',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00AC7C),
                                  fontSize: 20,
                                )))),
                    subtitle: Container(
                        child: Text(
                            'Update the areas and choices of job offers you would like to receive',
                            style: TextStyle(fontSize: 16)))),
                ListTile(
                    title: Container(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            child: Text('Request my statements',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00AC7C),
                                  fontSize: 20,
                                )))),
                    subtitle: Container(
                        child: Text(
                            'Receive an email with all your payment statements',
                            style: TextStyle(fontSize: 16)))),
                ListTile(
                    title: Container(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            child: Text('Disable my account',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00AC7C),
                                  fontSize: 20,
                                )))),
                    subtitle: Container(
                        child: Text(
                            'Temporarily disable your account. This will not delete your '
                            'information but you will not be active',
                            style: TextStyle(fontSize: 16)))),
                ListTile(
                    title: Container(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            child: Text('Delete my account',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00AC7C),
                                  fontSize: 20,
                                )))),
                    subtitle: Container(
                        child: Text(
                            'Delete your account and all information associated with it. This '
                            'can not be reversed and you will lose all your information.',
                            style: TextStyle(fontSize: 16)))),
              ]))),
    );
  }

  void checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user == null) {
        Navigator.pushNamed(
            context, 'Welcome');
      } else {
        print('User is logged in');
      }
    });
  }
// void getImage () async {
//   try {
//     await ref.child('Basic Information').child('ProfileImage').getData();
//     setState(() {
//       ppImage = ref.child('Basic Information').child('ProfileImage').writeToFile(ppImage) as File;
//     });
//   } on FirebaseException catch (e) {
//     print (e);
//   }
// }
}
