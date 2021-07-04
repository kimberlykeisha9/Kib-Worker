import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class IdDoc extends StatefulWidget {
  @override
  _IdDoc createState() => _IdDoc();
}
FirebaseAuth auth = FirebaseAuth.instance;
firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

class _IdDoc extends State<IdDoc> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  File idImage;

  Future imgFromGallery() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (image != null) {
        this.idImage = File(image.path);
      }
    });
    return CircularProgressIndicator;
  }

  Future imgFromCamera() async {
    final image = await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      if (image != null) {
        this.idImage = File(image.path);
      }
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
                  child: new Wrap(children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                        leading: new Icon(Icons.photo_camera),
                        title: new Text('Camera'),
                        onTap: () {
                          imgFromCamera();
                          Navigator.of(context).pop();
                        }),
                  ])));
        });
  }
  firebase_storage.Reference ref = storage.ref().child('users').child(auth.currentUser.uid).child
    ('User Information');

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
        child:
        SingleChildScrollView(
            child:Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                              width: width*0.5,
                              height: height*0.09,
                              margin: EdgeInsets.only(
                                top:115,
                              ),
                              child:
                              Text(
                                'Register',
                                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],)
                    ),
                    Column(
                      children: [
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
                      ],
                    ),
                  ]
              ),
              Container(
                  width: width*0.5,
                  margin: EdgeInsets.only(
                    top: 15,
                    left: 32,
                  ),
                  child: Text('Identification',
                      style: TextStyle(color: Color(0xFF00AC7C), fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left)
              ),
              Container(
                  margin: EdgeInsets.only(
                    top: 25,
                    left: 32,
                    right: 35,
                  ),
                  child: Text('To verify your information, we require a document showing proof of'
                      ' Identity. This could be your National ID or Passport. Upload it in the '
                      'space below:',
                      style: TextStyle(fontSize: 19,))),
              Column(
                  children:[
                    GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        width: width,
                        height: height * 0.18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: Offset(0,5),
                              spreadRadius: 2,
                              blurRadius: 4,
                            )
                          ]
                        ),
                        margin: EdgeInsets.only(
                          top: 30,
                          left:62,
                          right:65,
                        ),
                        child: idImage == null ? Text('No Image Selected') : Image.file(idImage,
                            fit: BoxFit.cover, filterQuality: FilterQuality.high,),
                      ),
                    ),
                  ]),
            ])),
      ),
      bottomNavigationBar: Container(
          width: width,
          height: height*0.10,
          margin: EdgeInsets.all(35),
          child: FloatingActionButton.extended(
            label: Text('Next'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 5.0,
            backgroundColor: Colors.grey[850],
            onPressed: () {
              if (idImage == null) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin:const EdgeInsets.all(10.0),
                  content: Text('Please select an image in order to proceed'),
                ));
              } else {
                uploadFile(context);
              }
            },
          )
      ),
    );
  }
  Future <void> uploadFile (BuildContext context) async {
    try {
      await ref.child('Identification Information').child('ID').putFile(idImage);
      Navigator.pushNamed(
          context, 'Complete');
    }
    on FirebaseException catch (e) {
      print(e);
    }
  }
}