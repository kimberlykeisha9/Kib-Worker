import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kibz/methods.dart';
import 'package:provider/provider.dart';

import '../employee.dart';
import '../employer.dart';
import '../linking.dart';

class JobPrompt extends StatefulWidget {
  @override
  _JobPrompt createState() => _JobPrompt();
}

class _JobPrompt extends State<JobPrompt> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Phone Size
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // Employer Details
    Provider.of<Employer>(context).getEmployerData();
    employerFirst = employerFirst  != null ? Provider.of<Employer>(context).first : 'None';
    employerLast = employerLast != null ? Provider.of<Employer>(context).last : 'None';
    employerUID = employerUID != null ? Provider.of<Employer>(context).uid : 'None';
    employerRating = employerRating != null ? Provider.of<Employer>(context).rate : 0;
    employerProfilePicture = employerProfilePicture != null ? Provider.of<Employer>(context).profilePicture : 'None';
    employerPhone = employerPhone != null ? Provider.of<Employer>(context).phone : 'None';
    amount = amount != null ? Provider.of<Employer>(context).amountDue : 0;
    amountDue = (80/100) * amount;
    task = task != null ? Provider.of<Employer>(context).task : 'None';
    // Build
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: height * 0.13,
          backgroundColor: Colors.grey[850],
          centerTitle: true,
          title: Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.all(20),
              child: Image.asset('assets/images/greeniconlogo.png', fit: BoxFit.contain))),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ZoomIn(
                duration: Duration(milliseconds: 300),
                child: Container(
                    height: height * 0.175,
                    width: height * 0.175,
                  margin: EdgeInsets.only(bottom: 15),
                    // color: Colors.pink,
                    child: ClipOval(child: Image.network(employerProfilePicture, fit: BoxFit.cover))),
              ),
              ZoomIn(
                duration: Duration(milliseconds: 400),
                child: Container(
                  height: height * 0.07,
                  // color: Colors.green,
                  alignment: Alignment.center,
                  child: Text('$employerFirst $employerLast', style: TextStyle(fontSize: 24)),
                ),
              ),
              ZoomIn(
                duration: Duration(milliseconds: 450),
                child: Container(
                  height: height * 0.04,
                  margin: EdgeInsets.only(bottom: 15),
                  // color: Colors.red,
                  alignment: Alignment.center,
                  child: Text('Rating: $employerRating/5', style: TextStyle(fontSize: 16)),
                ),
              ),
              ZoomIn(
                duration: Duration(milliseconds: 550),
                child: Container(
                  height: height * 0.08,
                  margin: EdgeInsets.only(bottom: 10),
                  // color: Colors.green,
                  alignment: Alignment.bottomCenter,
                  child: Text('Job Requested', style: TextStyle(fontSize: 24)),
                ),
              ),
              ZoomIn(
                duration: Duration(milliseconds: 600),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(task, style: TextStyle(fontSize: 16)),
                ),
              ),
              ZoomIn(
                duration: Duration(milliseconds: 700),
                child: Container(
                  margin: EdgeInsets.only(top: 40),
                  height: height * 0.04,
                  // color: Colors.red,
                  alignment: Alignment.center,
                  child: Text('Total to be paid = ksh. ${amount.toInt()}/-', style: TextStyle(fontSize: 16)),
                ),
              ),
              ZoomIn(
                duration: Duration(milliseconds: 800),
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: height * 0.04,
                  // color: Colors.red,
                  alignment: Alignment.center,
                  child: Text('You will receive = ksh. ${amountDue.toInt()}/-', style: TextStyle(fontSize: 16)),
                ),
              ),
              Expanded(
                child: ZoomIn(
                  duration: Duration(milliseconds: 900),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: width * 0.35,
                        height: height * 0.065,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey[850], side: BorderSide(style: BorderStyle.none)),
                          onPressed: () {
                            Linking().checkEmployerStatus(context, firstName, lastName, pp, rating, task, amount,);
                          },
                          child: Text('Accept Job', style: TextStyle(color: Color(0xFF00AC7C))),
                        ),
                      ),
                      Container(
                        width: width * 0.35,
                        height: height * 0.065,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.grey[850]),
                          onPressed: () => Navigator.pushNamed(context, 'Dashboard'),
                          child: Text('Reject', style: TextStyle(color: Color(0xFF00AC7C))),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
