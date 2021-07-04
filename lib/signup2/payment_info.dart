import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kibz/Strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentInfo extends StatefulWidget {
  @override
  _PaymentInfo createState() => _PaymentInfo();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
FirebaseAuth auth = FirebaseAuth.instance;

class _PaymentInfo extends State<PaymentInfo> {
  int selectedRadioTile;
  String cc = '+254';
  bool phoneVal = false;
  String phone = auth.currentUser.phoneNumber;
  final mpesaNumber = TextEditingController();

  setSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String parsed = phone.replaceAll(new RegExp(r"[^\w\s]+"), '');
    prefs.setString('mpesaNum', parsed);
    print(prefs.getString('mpesaNum'));
  }

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
      //resizeToAvoidBottomPadding: true,
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
              width: width * 0.6,
              margin: EdgeInsets.only(
                top: 15,
                left: 32,
              ),
              child: Text('Payment Information',
                  style: TextStyle(
                      color: Color(0xFF00AC7C),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: width,
                  height: height * 0.5,
                  margin: EdgeInsets.only(
                    top: 0,
                    left: 32,
                    right: 35,
                  ),
                  child: ListView(
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                            top: 0,
                            left: 0,
                            right: 0,
                          ),
                          child: Text(
                              'Kibarua currently accepts M-Pesa as the sole method of payment so in order'
                                      ' to receive your pay, we need a Safaricom number which you can accept '
                                      'M-Pesa. When you signed up you used the number ' +
                                  auth.currentUser.phoneNumber +
                                  '. Is this the same number you will receive money with?',
                              style: TextStyle(
                                fontSize: 19,
                              ))),
                      RadioListTile(
                        value: 1,
                        groupValue: selectedRadioTile,
                        title: Text('Yes'),
                        onChanged: (val) {
                          setSelectedRadioTile(val);
                          this.phone = auth.currentUser.phoneNumber;
                        },
                        activeColor: Color(0xFF00AC7C),
                      ),
                      RadioListTile(
                        value: 2,
                        groupValue: selectedRadioTile,
                        title: Text('No'),
                        onChanged: (val) {
                          setPaymentOptionFromDialog(context);
                          setSelectedRadioTile(val);
                        },
                        activeColor: Color(0xFF00AC7C),
                      ),
                    ],
                  )),
            ],
          )
        ])),
      ),
      floatingActionButton: Container(
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
                setSP();
                Navigator.pushNamed(context, 'Job Preference');
              }
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void showSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar((SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        content: Text(message))));
  }

  Future<void> setPaymentOptionFromDialog(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter M-Pesa number'),
            content: SingleChildScrollView(
              child: Row(children: [
                Container(
                    width: width * 0.18,
                    height: height * 0.15,
                    margin: EdgeInsets.only(
                      bottom: 30,
                      left: 0,
                      top: 10,
                    ),
                    child: CountryCodePicker(
                      initialSelection: 'KE',
                      favorite: ['KE', 'TZ', 'UG'],
                      onChanged: _onCountryChange,
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: height * 0.15,
                    width: width * 0.40,
                    margin: EdgeInsets.only(
                      top: 30,
                      left: 15,
                      right: 5,
                    ),
                    child: TextFormField(
                      controller: mpesaNumber,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          errorText: phoneVal ? 'Enter your number' : null,
                          hintText: 'Phone number',
                          suffixIcon: Icon(Icons.phone_outlined)),
                      maxLength: 9,
                    ),
                  ),
                )
              ]),
            ),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  setState(() {
                    mpesaNumber.text.isEmpty
                        ? phoneVal = true
                        : phoneVal = false;
                  });
                  if (mpesaNumber.text.isEmpty) {
                    showSnackbar('Please enter your number');
                  } else if (mpesaNumber.text.length < 9) {
                    showSnackbar('Please enter a valid number');
                  } else {
                    setSP();
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.pushNamed(context, 'Job Preference');
                    this.phone = cc + mpesaNumber.text;
                  }
                },
              )
            ],
          );
        });
  }

  void _onCountryChange(CountryCode value) {
    this.cc = value.toString();
  }
}
