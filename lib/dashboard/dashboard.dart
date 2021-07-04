import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kibz/Strings.dart';
import 'package:kibz/dashboard/unverifieddashboard.dart';
import 'package:kibz/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import '../employee.dart';
import '../employer.dart';
import '../linking.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

DocumentSnapshot cache;

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // User Details
    firstName = Provider.of<Employee>(context).getFirst;
    pp = Provider.of<Employee>(context).getPP;
    lastName = Provider.of<Employee>(context).getLast;
    Provider.of<Employee>(context, listen: false).getEmployeeData();
    // Check Verification Status
    return StreamBuilder<DocumentSnapshot>(
        initialData: cache,
        stream: userInfo.snapshots(),
        builder: (context, snapshot) {
          String _status = snapshot.data.get('accountStatus');
          cache = snapshot.data;
          if (_status == 'approved') {
            return Verified();
          } else {
            return Unverified();
          }
        });
  }
}

class Verified extends StatefulWidget {
  @override
  _Verified createState() => _Verified();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class _Verified extends State<Verified> {
  Future<void> _notificationHandler() async {
    // Notification Checker
    RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage?.data['type'] == 'Job') {
      Navigator.pushNamed(context, 'Job Prompt');
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'Job') {
        Navigator.pushNamed(context, 'Job Prompt');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == 'Job') {
        showOverlayNotification((context) {
          String profilePic = message.data['pp'];
          return Card(
              child: SafeArea(
                  child: Container(
            height: 100,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      padding: EdgeInsets.all(10),
                      child: ClipOval(child: Image.network(profilePic))),
                  Expanded(
                    child: Container(
                      height: 100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 50, alignment: Alignment.center, child: Text('${message.notification.title}')),
                          Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextButton(
                                        onPressed: () {
                                          OverlaySupportEntry.of(context).dismiss();
                                          Navigator.pushNamed(context, 'Job Prompt');
                                        },
                                        child: Text('View',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00AC7C)))),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextButton(
                                        onPressed: () => OverlaySupportEntry.of(context).dismiss(),
                                        child: Text('Cancel',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00AC7C)))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
          )));
        }, duration: Duration(seconds: 60));
        print('Received a message: ${message.data}');
        storeData('employerFirst', message.data['first']);
        storeData('employerLast', message.data['last']);
        storeData('employerRating', message.data['rate']);
        storeData('employerUID', message.data['id']);
        storeData('employerPP', message.data['pp']);
        storeData('employerPhone', message.data['phone']);
        storeData('amount', message.data['amount']);
        storeData('job', message.data['jobs']);
      }
    });

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  void initState() {
    // Upload user's current location to database
    Linking().uploadLocation(context);
    super.initState();
    // Check Authorization State
    Future.delayed(
        Duration.zero, () => Authorization().checkAuthState() ? null : Navigator.pushNamed(context, 'Welcome'));
    // Check Notifications
    _notificationHandler();
  }

  @override
  Widget build(BuildContext context) {
    // Phone Size
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // Get user information
    Provider.of<Employee>(context).getEmployeeData();
    firstName = Provider.of<Employee>(context).getFirst;
    lastName = Provider.of<Employee>(context).getLast;
    // Widget UI
    return WillPopScope(
      onWillPop: () async => true,
      child: DefaultTabController(
          length: 2,
          child: SafeArea(
            child: Scaffold(
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
                    child: TabBar(tabs: <Widget>[
                      Tab(text: 'Home'),
                      Tab(text: 'Chats'),
                    ])),
                body: TabBarView(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.all(25),
                              height: height * 0.2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SlideInLeft(
                                    duration: Duration(milliseconds: 500),
                                    child: Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          // color: Colors.grey,
                                          // border: Border.all(),
                                          borderRadius: BorderRadius.circular(40)),
                                      //padding: EdgeInsets.all(25),
                                      child: pp == null
                                          ? Icon(
                                              Icons.account_circle_outlined,
                                              size: 110,
                                              color: Colors.grey[850],
                                            )
                                          : ClipOval(
                                              child: Container(
                                                width: 110,
                                                height: 110,
                                                child: Image.network(
                                                  pp,
                                                  fit: BoxFit.cover,
                                                  filterQuality: FilterQuality.high,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SlideInDown(
                                        duration: Duration(milliseconds: 600),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: height * 0.1,
                                          child: Text(
                                            greeting(),
                                            style: TextStyle(fontSize: 22),
                                          ),
                                        ),
                                      ),
                                      SlideInDown(
                                        duration: Duration(milliseconds: 500),
                                        child: Container(
                                          //  alignment: Alignment.center,
                                          height: height * 0.1,
                                          child: Text(
                                            firstName == null ? 'User' : firstName,
                                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                          ),
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
                              child: DefaultTabController(
                                length: 2,
                                child: Scaffold(
                                  appBar: AppBar(
                                      toolbarHeight: height * 0.08,
                                      backgroundColor: Colors.grey[850],
                                      bottom: TabBar(
                                          indicatorWeight: 4,
                                          labelColor: Color(0xFF00AC7C),
                                          indicatorColor: Color(0xFF00AC7C),
                                          tabs: <Widget>[
                                            Tab(text: 'Pending Jobs'),
                                            Tab(text: 'Past Jobs'),
                                          ])),
                                  body: TabBarView(
                                    children: <Widget>[
                                      StreamBuilder(
                                          initialData: cache,
                                          stream: userInfo.snapshots(),
                                          builder: (context, snapshot) {
                                            var info = snapshot.data.data();
                                            bool isEngaged = info['isEngaged'];
                                            if (snapshot.hasData) {
                                              if (isEngaged == false) {
                                                return Center(
                                                  child: ZoomIn(
                                                      duration: Duration(milliseconds: 500),
                                                      child: Text('You have no pending jobs')),
                                                );
                                              } else {
                                                DocumentReference _activeJob = info['currentJob'];
                                                return StreamBuilder(
                                                    stream: _activeJob.snapshots(),
                                                    builder: (context, snapshot) {
                                                      Linking().checkPaymentDetails();
                                                      employerFirst = snapshot.data.get('employerFirst');
                                                      employerLast = snapshot.data.get('employerLast');
                                                      employerRating = snapshot.data.get('employerRating');
                                                      employerProfilePicture = snapshot.data.get('employerPP');
                                                      employerPhone = snapshot.data.get('employerPhone');
                                                      return Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    height: 55,
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Text('$employerFirst $employerLast',
                                                                            style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.bold)),
                                                                        Text('Rating: $employerRating',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuButton(
                                                                      icon: ClipOval(
                                                                          child: Image.network(employerProfilePicture,
                                                                              width: 55,
                                                                              height: 55,
                                                                              fit: BoxFit.cover)),
                                                                      itemBuilder: (context) => [
                                                                            PopupMenuItem(
                                                                                height: 30, child: Text('Call')),
                                                                            PopupMenuItem(
                                                                                height: 30, child: Text('Text')),
                                                                            PopupMenuItem(
                                                                                height: 30, child: Text('Chat in-app')),
                                                                          ])
                                                                ],
                                                              ),
                                                              Container(
                                                                  margin: EdgeInsets.only(top: 20),
                                                                  alignment: Alignment.bottomLeft,
                                                                  height: height * 0.027,
                                                                  decoration: BoxDecoration(
                                                                    // color: Colors.pink,
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                  child: Text('Task to be done',
                                                                      style: TextStyle(fontWeight: FontWeight.bold))),
                                                              Expanded(
                                                                child: Container(
                                                                    margin: EdgeInsets.only(top: 5),
                                                                    child: Container(
                                                                        alignment: Alignment.topLeft,
                                                                        child: Text(task))),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(bottom: 10),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text('Total',
                                                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                                                    Text('ksh. ${amount.toInt()}',
                                                                        style: TextStyle(fontWeight: FontWeight.bold))
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        primary: Colors.grey[850]),
                                                                    onPressed: () => showSnackbar(
                                                                        context,
                                                                        'Feature not '
                                                                        'available yet'),
                                                                    child: Text('Chat $employerFirst',
                                                                        style: TextStyle(color: Color(0xFF00AC7C))),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed: () => Linking().cancelJobDialog(context),
                                                                    style: ElevatedButton.styleFrom(
                                                                        primary: Colors.grey[850]),
                                                                    child: Text('Cancel',
                                                                        style: TextStyle(color: Color(0xFF00AC7C))),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ));
                                                    });
                                              }
                                            } else {
                                              return Center(child: CircularProgressIndicator());
                                            }
                                          }),
                                      FutureBuilder(
                                        initialData: records
                                            .orderBy('Date', descending: true)
                                            .get(GetOptions(source: Source.cache)),
                                        future: records.orderBy('Date', descending: true).get(),
                                        builder: (context, snapshot) {
                                          dynamic _records = snapshot.data.docs;
                                          if (!snapshot.hasData) {
                                            return Center(child: Text('You have no history'));
                                          } else {
                                            return PageView.builder(
                                              itemCount: _records.length,
                                              itemBuilder: (context, index) {
                                                DocumentSnapshot record = _records[index];
                                                if (_records.length == 0) {
                                                  return Center(
                                                      child: ZoomIn(
                                                          duration: Duration(milliseconds: 500),
                                                          child: Text('You have no history')));
                                                } else {
                                                  return ZoomIn(
                                                    duration: Duration(milliseconds: 300),
                                                    child: Container(
                                                      padding: EdgeInsets.all(15),
                                                      child: ListTile(
                                                        title: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            Text('Date: ${record['Date']}',
                                                                style: TextStyle(
                                                                    fontSize: 18, fontWeight: FontWeight.bold)),
                                                            Text(
                                                              'Worked for: ' + record['Worked for'],
                                                              style: TextStyle(fontSize: 16),
                                                            ),
                                                            Text(
                                                              'Started at: ' + record['Started at'],
                                                              style: TextStyle(fontSize: 16),
                                                            ),
                                                            Text(
                                                              'Ended at: ' + record['Ended at'],
                                                              style: TextStyle(fontSize: 16),
                                                            ),
                                                            Text(
                                                              'Total Amount: ${record['Total Amount'].toInt()}',
                                                              style: TextStyle(fontSize: 16),
                                                            ),
                                                            Text(
                                                              'Amount you receive: ${record['Amount You Received'].toInt()}',
                                                              style: TextStyle(fontSize: 16),
                                                            ),
                                                            Text(
                                                              'Rating given: 4/5',
                                                              style: TextStyle(fontSize: 16),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(top: 9),
                                                              child: Divider(color: Colors.grey[850]),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: ZoomIn(duration: Duration(milliseconds: 500), child: Text('You have no messages')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                drawer: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: SafeArea(
                      child: Container(
                    color: Colors.white,
                    width: width * 0.75,
                    height: height,
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 3),
                              blurRadius: 4,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        height: height * 0.35,
                        width: width,
                        child: ZoomIn(
                          duration: Duration(milliseconds: 300),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (pp == null)
                                Icon(
                                  Icons.account_circle_outlined,
                                  size: 110,
                                  color: Colors.white,
                                )
                              else
                                ClipOval(
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    child: Image.network(
                                      pp,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                ),
                              Text('$firstName $lastName', style: TextStyle(fontSize: 22))
                            ],
                          ),
                        ),
                      ),
                      ZoomIn(
                        duration: Duration(milliseconds: 400),
                        child: Container(
                          margin: EdgeInsets.only(top: 15, left: 25),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(),
                          height: height * 0.09,
                          width: width,
                          child: TextButton(
                            onPressed: () {
//                            Future.delayed(Duration(seconds: 5), () => searchForWorker());
                            },
                            child: Text('Home', style: TextStyle(color: Color(0xFF00AC7C), fontSize: 22)),
                          ),
                        ),
                      ),
                      ZoomIn(
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          margin: EdgeInsets.only(left: 25),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(),
                          height: height * 0.09,
                          width: width,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'Profile');
                            },
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                color: Color(0xFF00AC7C),
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ZoomIn(
                        duration: Duration(milliseconds: 600),
                        child: Container(
                          margin: EdgeInsets.only(left: 25),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(),
                          height: height * 0.09,
                          width: width,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'Account Settings');
                            },
                            child: Text(
                              'Account Settings',
                              style: TextStyle(color: Color(0xFF00AC7C), fontSize: 22),
                            ),
                          ),
                        ),
                      ),
                      ZoomIn(
                        duration: Duration(milliseconds: 700),
                        child: Container(
                          margin: EdgeInsets.only(left: 25),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(),
                          height: height * 0.09,
                          width: width,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'General Settings');
                            },
                            child: Text(
                              'General Settings',
                              style: TextStyle(color: Color(0xFF00AC7C), fontSize: 22),
                            ),
                          ),
                        ),
                      ),
                      ZoomIn(
                        duration: Duration(milliseconds: 800),
                        child: Container(
                          margin: EdgeInsets.only(left: 25),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(),
                          height: height * 0.09,
                          width: width,
                          child: TextButton(
                            onPressed: () {
                              messaging.getToken().then((token) {
                                searchForWorker(token, pp);
                              });
                            },
                            child: Text(
                              'Kibarua Website',
                              style: TextStyle(
                                color: Color(0xFF00AC7C),
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ZoomIn(
                        duration: Duration(milliseconds: 900),
                        child: Container(
                            margin: EdgeInsets.only(
                              top: 20,
                              left: 25,
                              right: 25,
                            ),
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
                                      Authorization().signOut(context).then((value) {
                                        Authorization().checkAuthState() ? null : Navigator.pushNamed(context, 'Home');
                                      });
                                    },
                                    child: Text('Logout', style: TextStyle(color: Color(0xFF00AC7C), fontSize: 22)),
                                  ),
                                  Icon(
                                    Icons.power_settings_new_outlined,
                                    color: Color(0xFF00AC7C),
                                  )
                                ])),
                      ),
                    ]),
                  )),
                )),
          )),
    );
  }
}
