import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as mainDatabase;
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'employee.dart';
import 'linking.dart';
import 'methods.dart';

String employerFirst;
String employerLast;
String employerUID;
String employerProfilePicture;
String employerPhone;
double employerRating;

// Main application
FirebaseApp main = Firebase.app('Main');
mainDatabase.FirebaseFirestore mainDB = mainDatabase.FirebaseFirestore.instanceFor(app: main);
mainDatabase.CollectionReference employerDB = mainDB.collection('users');

class Employer extends ChangeNotifier {
  // Employer Info
  String employerFirst;
  String employerLast;
  String employerUID;
  String employerProfilePicture;
  double employerRating;
  double amount;
  String employerPhone;
  String _task;

  String get first {
    return employerFirst;
  }

  String get last {
    return employerLast;
  }

  double get rate {
    return employerRating;
  }

  String get uid {
    return employerUID;
  }

  String get profilePicture {
    return employerProfilePicture;
  }

  String get phone {
    return employerPhone;
  }

  String get task {
    return _task;
  }

  double get amountDue {
    return amount;
  }

  void getEmployerData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    employerFirst = pref.getString('employerFirst');
    employerLast = pref.getString('employerLast');
    employerUID = pref.getString('employerUID');
    employerProfilePicture = pref.getString('employerPP');
    employerRating = double.parse(pref.getString('employerRating'));
    employerPhone = pref.getString('employerPhone');
    amount = double.parse(pref.getString('amount'));
    _task = pref.getString('job');
    notifyListeners();
  }
}
