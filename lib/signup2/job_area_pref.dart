import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kibz/Strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkArea extends StatefulWidget {
  @override
  _WorkArea createState() => _WorkArea();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _WorkArea extends State<WorkArea> {
  int selectedRadioTile;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool nearby = false;
  bool notfar = false;
  bool far = false;

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[850],
    ));
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomPadding: false,
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
              child: Text('Work Preferences',
                  style: TextStyle(
                      color: Color(0xFF00AC7C),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left)),
          Container(
              margin: EdgeInsets.only(
                top: 20,
                left: 32,
                right: 35,
              ),
              child: Text('Which areas would you prefer to work in?',
                  style: TextStyle(
                    fontSize: 19,
                  ))),
          Container(
            height: height * 0.6,
            width: width,
            margin: EdgeInsets.only(
              top: 5,
              left: 35,
              right: 35,
              bottom: 5,
            ),
            child: ListView(
              children: [
                RadioListTile(
                  value: 1,
                  groupValue: selectedRadioTile,
                  title: Text('Strictly in areas near me'),
                  onChanged: (val) {
                    setSelectedRadioTile(val);
                    setState(() {
                      nearby = true;
                      notfar = false;
                      far = false;
                    });
                    print('Near areas selected');
                  },
                  activeColor: Color(0xFF00AC7C),
                ),
                RadioListTile(
                  value: 2,
                  groupValue: selectedRadioTile,
                  title: Text('Not too far away from me'),
                  onChanged: (val) {
                    setSelectedRadioTile(val);
                    setState(() {
                      nearby = false;
                      notfar = true;
                      far = false;
                    });
                    print('Not too far away selected');
                  },
                  activeColor: Color(0xFF00AC7C),
                ),
                RadioListTile(
                  value: 3,
                  groupValue: selectedRadioTile,
                  title: Text('I can work far away'),
                  onChanged: (val) {
                    setSelectedRadioTile(val);
                    setState(() {
                      nearby = false;
                      notfar = false;
                      far = true;
                    });
                    print('Far away areas selected');
                  },
                  activeColor: Color(0xFF00AC7C),
                ),
              ],
            ),
          ),
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
              if (selectedRadioTile == 0) {
                showSnackbar('Please select an option');
              } else {
              }
            },
          )),
    );
  }

  void showSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar((SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        content: Text(message))));
  }
}
