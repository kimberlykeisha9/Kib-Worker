import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Job {
  // This is the employee's information that will be sent to the database
  final String employeeFirst;
  final String employeeLast;
  final String employeePhone;
  final String employeeUID;
  final double employeeRating;
  final int employeePaymentNumber;
  // This is the employer's information that will be sent to the database
  final String employerFirst;
  final String employerLast;
  final String employerPhone;
  final String employerUID;
  final double employerRating;
  final int employerPaymentNumber;
  // Other information
  final String timeStarted;
  final String timeEnded;
  final String task;
  final int amount;
  final int employeeGivenRating;
  final int employerGivenRating;

  Job({this.employeeFirst, this.employeeLast, this.employeePhone, this.employeeUID,
  this.employeePaymentNumber, this.employeeRating, this.employerFirst, this.employerLast,
  this.employerPhone, this.employerUID, this.employerRating, this.employerPaymentNumber,
  this.timeStarted, this.timeEnded, this.task, this.amount, this.employeeGivenRating,
  this.employerGivenRating});

  // Document ID which is employeeUID First then employerUID Second

  Map<String, dynamic> toMap() {
    return {
    'id' : employeeUID + employerUID,
    'employeeFirst' : employeeFirst,
    'employeeLast': employeeLast,
    'employeePhone' : employeePhone,
    'employeeUID' : employeeUID,
    'employeeRating' : employeeRating,
    'employeePaymentNumber' : employeePaymentNumber,
    'employerFirst' : employerFirst,
    'employerLast': employerLast,
    'employerPhone' : employerPhone,
    'employerUID' : employerUID,
    'employerRating' : employerRating,
    'employerPaymentNumber' : employerPaymentNumber,
    'timeStarted' : timeStarted,
    'timeEnded' : timeEnded,
    'task' : task,
    'amount' : amount,
    'employeeGivenRating' : employeeGivenRating,
    'employerGivenRating' : employerGivenRating,
  };
  }
}

createJobDocument() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'job_documents.db');

  Database jobs = await openDatabase(path, version: 1,
  onCreate: (Database db, int version) async {
    await db.execute(
      'CREATE TABLE Jobs (id TEXT PRIMARY KEY, employeeFirst TEXT, employeeLast TEXT, '
        'employeePhone TEXT, employeeUID TEXT, employeeRating TEXT, '
        'employeePaymentNumber INTEGER, employerFirst TEXT, employerLast TEXT, '
        'employerPhone TEXT, employeerUID TEXT, employerRating TEXT, '
        'employerPaymentNumber INTEGER, timeStarted TEXT, timeEnded TEXT, task TEXT, '
        'amount INTEGER, employeeGivenRating INTEGER, employerGivenRating INTEGER)'
    );
  });
}

sendJobToDatabase(Job jobInfo) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'job_documents.db');

  Database job = await openDatabase(path, version: 1);
  await job.insert('Jobs', jobInfo.toMap(),
  conflictAlgorithm: ConflictAlgorithm.replace);
}

