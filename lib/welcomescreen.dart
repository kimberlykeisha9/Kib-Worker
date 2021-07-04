import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Strings.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Welcome extends StatefulWidget {
  @override
  _Welcome createState() => _Welcome();
}

class _Welcome extends State<Welcome> with TickerProviderStateMixin {

  void initState() {
    super.initState();
    // checkAuthState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
//          padding: EdgeInsets.only(bottom: height * 0.08),
          height: height,
          width: width,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElasticInDown(
                duration: Duration(milliseconds: 500),
                child: Container(
                  width: 120,
                  height: 140,
                  padding: const EdgeInsets.only(
                    top: 35.0,
                    bottom: 35.0,
                    left: 30.0,
                  ),
                  decoration: new BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: new BorderRadius.only(bottomLeft: const Radius.circular(100.0))),
                  child: ZoomIn(
                    duration: Duration(milliseconds: 500),
                    child: Image.asset(
                      'assets/images/greeniconlogo.png',
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SlideInUp(
                duration: Duration(milliseconds: 500),
                child: Container(
                  width: width * 0.8,
                  height: height * 0.29,
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    right: 20.0,
                  ),
                  child: Text(greeting(),
                      textAlign: TextAlign.right, style: TextStyle(color: Colors.grey[850], fontSize: 57)),
                ),
              ),
              SlideInUp(
                duration: Duration(milliseconds: 500),
                child: Container(
                  width: width * 0.8,
                  height: height * 0.05,
                  padding: const EdgeInsets.only(right: 25.0),
                  child: Text(
                    appname(),
                    textAlign: TextAlign.right,
                    textScaleFactor: 1.5,
                    style: TextStyle(color: const Color(0xFF00AC7C)),
                  ),
                ),
              ),
              Expanded(
                child: SlideInUp(
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    height: height * 0.2,
                    width: width,
                    child: Image.asset(
                      'assets/images/Group 31.png',
//                    alignment: Alignment.bottomCenter,
                      fit: BoxFit.fitWidth,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.grey[850],
          width: width,
          height: height * 0.08,
          padding: const EdgeInsets.only(
            right: 20.0,
            left: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                child: Text(
                  signin(),
                  style: TextStyle(
                    color: const Color(0xFF00AC7C),
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'Sign In');
                },
              ),
              TextButton(
                child: Text(
                  reg(),
                  style: TextStyle(
                    color: const Color(0xFF00AC7C),
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'Email');
                },
              )
            ],
          ),
        ));
  }
}
