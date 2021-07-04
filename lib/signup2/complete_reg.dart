import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kibz/Strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'job_list.dart';
import 'package:provider/provider.dart';
import 'package:kibz/methods.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFunctions functions = FirebaseFunctions.instance;
FirebaseStorage storage = FirebaseStorage.instance;

class RegComplete extends StatefulWidget {
  @override
  _RegComplete createState() => _RegComplete();
}

class _RegComplete extends State<RegComplete> {
  var selectedJobs = jobs.where((job) => job.isJobSelected == true);
  Reference ref = storage
      .ref()
      .child('users')
      .child(auth.currentUser.uid)
      .child('User Information');
  String _profilePic;
  String _mpesaNumber;
  HttpsCallable callable = functions.httpsCallable('setUserInfo');
  List<String> jobStrings = <String>[];


  void getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('mpesaNum');
    prefs.setString('pp', _profilePic);
    setState(() {
      _mpesaNumber = prefs.getString('mpesaNum');
      _profilePic = prefs.getString('pp');
    });
    print(_mpesaNumber);
  }

  void sendData() async {
    try {
      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'profile': _profilePic,
        'selectedjobs': jobStrings,
        'mpesanumber': _mpesaNumber,
      });
      print(result.data);
      Navigator.pushNamed(context, 'Dashboard');
    } on FirebaseFunctionsException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    selectedJobs.toList().forEach((job) => print(job.jobTitle));
    selectedJobs.toList().forEach((job) => jobStrings.add(job.jobTitle));
    print('The selected jobs are: $jobStrings');
  }

  @override
  Widget build(BuildContext context) {
    //Get Data
    Upload().getPPLink();
    getSharedPreferences();
    _profilePic = Upload().link;
    // Phone Data
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
              child: Text('Account Verified',
                  style: TextStyle(
                      color: Color(0xFF00AC7C),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left)),
          Container(
              margin: EdgeInsets.only(
                top: 15,
                left: 32,
                right: 35,
              ),
              child: Text(
                  '''You can now start receiving job offers now that your account is complete.

You can change your Work Preferences in the menu if you change your mind later on.

Please do go over the Code of Conduct to understand the requirements of Kibarua.''',
                  style: TextStyle(
                    fontSize: 19,
                  ))),
        ])),
      ),
      bottomNavigationBar: Container(
          width: width,
          height: height * 0.10,
          margin: EdgeInsets.all(35),
          child: FloatingActionButton.extended(
            label: Text('Ok'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 5.0,
            backgroundColor: Colors.grey[850],
            onPressed: () {
              // verifyAccount();
              sendData();
            },
          )),
    );
  }
}
