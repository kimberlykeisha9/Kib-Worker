import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Birthdate extends StatefulWidget {
  @override
  _Birthdate createState() => _Birthdate();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _Birthdate extends State<Birthdate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime _chosenDateTime;
  final dobString = TextEditingController();
  bool dob_val = false;

  void initState() {
    super.initState();
    checkAuthState();
  }

  setSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('DOB', dobString.text);
  }

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
              child: Text('Please enter your date of birth',
                  style: TextStyle(
                    fontSize: 19,
                  ))),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                width: width,
                margin: EdgeInsets.only(
                  top: 20,
                  left: 35,
                  right: 35,
                ),
                child: TextFormField(
                  autofocus: false,
                  controller: dobString,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    errorText: dob_val ? 'Please enter your birthdate' : null,
                    hintText: 'Date of birth',
                    suffixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                )),
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
                dobString.text.isEmpty ? dob_val = true : dob_val = false;
              });
              if (dobString.text.isEmpty) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(10.0),
                  content: Text('Please enter your date of birth'),
                ));
              } else {
                setSharedPreferences();
                Navigator.pushNamed(context, 'Phone');
              }
            },
          )),
    );
  }

  void checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('No user was found so redirected');
        Navigator.pushNamed(context, 'Home');
      } else {
        print('yup they r still in it uWu');
      }
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime(DateTime.now().year - 18),
      initialDatePickerMode: DatePickerMode.year,
    );
    var format = "${picked.day}-${picked.month}-${picked.year}";
    dobString.text = format;
  }
}
