import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'methods.dart';

String firstName;
String lastName;
String pp;
String accStat;
double rating = 4.5;

var user = auth.currentUser.uid;
String phone = auth.currentUser.phoneNumber;
String email = auth.currentUser.email;


class Employee extends ChangeNotifier {
  String firstName;
  String lastName;
  String pp;
  double rating;
  int sumRating = 0;

  String get getFirst {
    return firstName;
  }
  String get getLast {
    return lastName;
  }
  String get getPP {
    return pp;
  }
  double get rate {
    return rating;
  }

  void getEmployeeData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    firstName = pref.getString('fname');
    lastName = pref.getString('lname');
    pp = pref.getString('pp');
//    records.get().then((QuerySnapshot querySnapshot) {
//      querySnapshot.docs.forEach((doc) {
//        sumRating += doc["Rating Received"];
//      });
//      print(sumRating);
//      print(querySnapshot.size);
//      rating = (sumRating/querySnapshot.size);
//    });
    notifyListeners();
  }
}
