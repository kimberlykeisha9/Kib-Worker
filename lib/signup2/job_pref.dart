import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kibz/Strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'job_list.dart';

class JobPref extends StatefulWidget {
  @override
  _JobPref createState() => _JobPref();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _JobPref extends State<JobPref> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomPadding: true,
      body: Container(
        height: height,
        width: width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                top: 30,
                left: 32,
                right: 35,
              ),
              child: Text('What are your job preferences?',
                  style: TextStyle(
                    fontSize: 19,
                  ))),
          Expanded(
            child: Container(
              height: height * 0.45,
              width: width,
              margin: EdgeInsets.only(
                top: 5,
                left: 35,
                right: 35,
                bottom: height * 0.2,
              ),
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  var job = jobs[index];
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(job.jobTitle),
                    subtitle: job.jobA == null
                        ? null
                        : Text('${job.jobA} and ${job.jobB}'),
                    value: job.isJobSelected,
                    onChanged: (value) {
                      setState(() {
                        job.isJobSelected = value;
                      });
                      // job.jobA != null
                      //     ? jobChoices(
                      //         context,
                      //         job.jobA,
                      //         job.jobB,
                      //         job.jobASelected,
                      //         job.jobBSelected,
                      //         job.isJobSelected,
                      //         job.jobTitle)
                      //     : null;
                    },
                  );
                },
              ),
            ),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          color: Colors.transparent,
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
              if (selectedJobs.isEmpty) {
                showSnackbar('Please choose at least 1 job from the list');
              } else {
                selectedJobs.toList().forEach((job) => print(job.jobTitle));
                Navigator.pushNamed(context, 'Reg Complete');
              }
            },
          )),
    );
  }

  var selectedJobs = jobs.where((job) => job.isJobSelected == true);

  void showSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar((SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        content: Text(message))));
  }

  void jobChoices(BuildContext context, String jobA, String jobB,
      bool jobASelected, bool jobBSelected, bool jobSelected, String job) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return new AlertDialog(
              title: Text('You selected $job'),
              content: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text('Please specify what you would '
                              'prefer')),
                      new CheckboxListTile(
                        value: jobASelected,
                        activeColor: Color(0xFF00AC7C),
                        title: Text(jobA),
                        subtitle: Text('Job A Description'),
                        onChanged: (value) {
                          setState(() {
                            jobASelected = value;
                          });
                        },
                        tristate: false,
                      ),
                      new CheckboxListTile(
                          value: jobBSelected,
                          activeColor: Color(0xFF00AC7C),
                          title: Text(jobB),
                          subtitle: Text('Job B Description'),
                          onChanged: (value) {
                            setState(() {
                              jobBSelected = value;
                            });
                          }),
                    ]),
              ),
              actions: <Widget>[
                new FlatButton(
                  child:
                      Text('Done', style: TextStyle(color: Color(0xFF00AC7C))),
                  onPressed: () {
                    if (jobASelected == false && jobBSelected == false) {
                      setState(() {
                        jobSelected = false;
                      });
                    }
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                )
              ],
            );
          });
        });
  }
}
