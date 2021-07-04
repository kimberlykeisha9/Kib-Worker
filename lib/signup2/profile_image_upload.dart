import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kibz/Strings.dart';
import 'package:kibz/methods.dart';
import 'package:provider/provider.dart';

class ProfileImageUpload extends StatefulWidget {
  @override
  _ProfileImageUpload createState() => _ProfileImageUpload();
}

class _ProfileImageUpload extends State<ProfileImageUpload> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // ProfilePictureData
    ppImage = Provider.of<ImageSelector>(context).image;
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomPadding: false,
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
                                reg(),
                                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],)
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
                  ]
              ),
              Container(
                  width: width*0.5,
                  margin: EdgeInsets.only(
                    top: 15,
                    left: 32,
                  ),
                  child: Text('Upload an Image',
                      style: TextStyle(color: Color(0xFF00AC7C), fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left)
              ),
              Container(
                  margin: EdgeInsets.only(
                    top: 35,
                    left: 32,
                    right: 35,
                  ),
                  child: Text('This is the image that will be linked to your profile and what '
                      'your clients will see',
                      style: TextStyle(fontSize: 19,))),
              Column(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Provider.of<ImageSelector>(context, listen: false).showPicker(context);
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 160,
                        height: 160,
                        // alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          top: 25,
                          // left: 110,
                        ),
                        decoration: BoxDecoration(
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(),
                        ),
                        child: ClipOval(
                          child: ppImage == null ? Align(alignment: Alignment.center, child: Text('No Image Selected')) : Image.file
                            (ppImage, fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,),
                        )
                      ),
                    ),
                  ),
                ],
              )
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
              if (ppImage == null) {
                showSnackbar(context, 'Please upload an image to continue');
              } else {
                Upload().uploadPP().then((value) => Navigator.pushNamed(context, 'Payment'));
              }
            },
          )
      ),
    );
  }
}
