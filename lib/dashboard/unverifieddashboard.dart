import 'package:flutter/material.dart';
import 'package:kibz/Strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../methods.dart';
import '../employee.dart';

class Unverified extends StatefulWidget {
  @override
  _Unverified createState() => _Unverified();
}

class _Unverified extends State<Unverified> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
            body: Column(
              children: [
                Container(
                    margin: EdgeInsets.all(25),
                    height: height * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                // color: Colors.grey,
                                // border: Border.all(),
                                borderRadius: BorderRadius.circular(40)),
                            //padding: EdgeInsets.all(25),
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 110,
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: height * 0.1,
                              child: Text(
                                greeting(),
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                            Container(
                              //  alignment: Alignment.center,
                              height: height * 0.1,
                              child: Text(
                                firstName,
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                Expanded(
                  child: Container(
                    width: width,
                    height: height,
                    child: Column(children: [
                      Container(
                        width: width,
                        height: height * 0.1,
                        color: Colors.grey[850],
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Center(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: firestore.collection('user-info').doc(auth.currentUser.uid).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }
                              if (snapshot.connectionState == ConnectionState.done) {
                                // Map<String, dynamic> data =
                                //     snapshot.data.data();
                                var data = snapshot.data;
                                if (data['accountStatus'] == "pending") {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Account is under review',
                                          style: TextStyle(
                                              fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00AC7C))),
                                      Text(
                                        'We will send you an email notification once we are done reviewing your details',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  );
                                }
                                if (data['accountStatus'] == "rejected") {
                                  return Text(
                                    'You\'re account had an error. Please check your email for further details on how to fix the issue',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                }
                                if (data['accountStatus'] == "approved but incomplete") {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'You\'re account has been verified. You can continue setting up your account',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      ElevatedButton(
                                          onPressed: () => Navigator.pushNamed(context, 'Verified Page'),
                                          child: Text('Continue', style: Theme.of(context).textTheme.bodyText1)),
                                    ],
                                  );
                                }
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                      ))
                    ]),
                  ),
                ),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.grey[850],
              toolbarHeight: height * 0.13,
              leading: Container(
                margin: EdgeInsets.only(
                  left: 25,
                ),
                child: Icon(
                  Icons.menu_outlined,
                  color: Color(0xFF00AC7C),
                  size: 30,
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/greeniconlogo.png',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
            bottomNavigationBar: Container(
              height: height * 0.1,
              color: Colors.grey[850],
            ),
            drawer: SafeArea(
                child: Container(
              color: Colors.grey[850],
              width: width,
              height: height,
              child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: BoxDecoration(color: Colors.grey[850], boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 3),
                            blurRadius: 4,
                            spreadRadius: 4,
                          )
                        ]),
                        height: height * 0.35,
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              size: 110,
                              color: Colors.white,
                            ),
                            Text('$firstName $lastName', style: TextStyle(color: Colors.white, fontSize: 22))
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 25),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(),
                      height: height * 0.09,
                      width: width,
                      child: TextButton(
                        onPressed: () {},
                        child: Text('Home', style: TextStyle(color: Color(0xFF00AC7C), fontSize: 22)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(),
                      height: height * 0.09,
                      width: width,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'Profile');
                        },
                        child: Text('Profile', style: TextStyle(color: Color(0xFF00AC7C), fontSize: 22)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(),
                      height: height * 0.09,
                      width: width,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'General Settings');
                        },
                        child: Text('General Settings', style: TextStyle(color: Color(0xFF00AC7C), fontSize: 22)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(),
                      height: height * 0.09,
                      width: width,
                      child: TextButton(
                        child: Text('Kibarua Website', style: TextStyle(color: Color(0xFF00AC7C), fontSize: 22)),
                      ),
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 20, left: 25, right: 25),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(),
                                height: height * 0.09,
                                width: width,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Authorization()
                                              .signOut(context)
                                              .then((value) => Navigator.pushNamed(context, 'Welcome'));
                                        },
                                        child: Text('Logout', style: TextStyle(color: Color(0xFF00AC7C), fontSize: 22)),
                                      ),
                                      Icon(
                                        Icons.power_settings_new_outlined,
                                        color: Color(0xFF00AC7C),
                                      )
                                    ])))),
                  ]),
            ))),
      ),
    );
  }
}
