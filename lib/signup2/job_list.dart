import 'package:flutter/material.dart';

class JobList {
  final String jobTitle;
  bool isJobSelected;
  final String jobA;
  final String jobB;
  bool jobASelected;
  bool jobBSelected;

  JobList(this.jobTitle, this.isJobSelected,
      {this.jobA, this.jobASelected, this.jobB, this.jobBSelected});
}

List<JobList> jobs = [
  JobList('Cleaning Cars', false),
  JobList('Gardening', false,
  jobA: 'Manual Gardening',
  jobASelected: false,
  jobB: 'Automatic Gardening',
  jobBSelected: false,
  ),
  JobList('Pets', false,
  jobA: 'Dog Walking',
  jobASelected: false,
  jobB: 'Pet Cleaning',
  jobBSelected: false,
  ),
  JobList('BabySitting', false),
  JobList('Pickup and Delivery', false,
  jobA: 'Light Pickups',
  jobASelected: false,
  jobB: 'Heavy Pickups',
  jobBSelected: false,
  ),
  JobList('Laundry', false,
  jobA: 'Light Laundry',
  jobASelected: false,
  jobB: 'Heavy Laundry',
  jobBSelected: false,
  ),
  JobList('Running Errands', false,
  jobA: 'Light Shopping',
  jobASelected: false,
  jobB: 'Heavy Shopping',
  jobBSelected: false,
  ),
  JobList('Cleaning', false,
  jobA: 'Light Cleaning',
  jobASelected: false,
  jobB: 'Heavy Cleaning',
  jobBSelected: false,
  ),
];
