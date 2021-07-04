String greeting () {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  }
  if (hour < 17) {
    return 'Good Afternoon';
  }
  return 'Good Evening';
}
String p2id () {
  return
  'Thank you for creating your worker account. '
      'In order to verify your date of birth and identity, '
      'we require a document showing proof of identity. '
      'This could be your National ID or passport. '
      'You can upload it in the space below: ';
}
String appname () {
  return 'Kibarua for Workers';
}
String  successReg () {
  return 'Alright you have succesfully created your Worker Account. '
      'Our team will review your details and you should receive an email response '
      'within 24 hours that will confirm the status of your account and you may continue '
      'setting it up. If there is any error, the email will guide you on how to fix it. '
      'We look forward to working with you!';
}
String  reg() {
  return 'Register';
}
String signin () {
  return 'Sign In';
}
String  p1() {
  return 'Part 1 - Basic Information';
}
String p2 () {
  return 'Part 2 - Identification';
}
String next () {
  return 'Next';
}
String ok () {
  return 'Okay';
}
String fname () {
  return 'First Name';
}
String lname () {
  return 'Last Name';
}
String email () {
  return 'Email';
}
String phone () {
  return 'Phone';
}
String dob () {
  return 'Date of Birth';
}
String pass () {
  return 'Password';
}
String forgot () {
  return 'Forgot Password?';
}