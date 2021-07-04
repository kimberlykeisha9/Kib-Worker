import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kibz/signup2/complete_reg.dart';
import 'package:kibz/welcomescreen.dart';
import 'package:kibz/signin.dart';
import 'package:kibz/signup1/email_pass.dart';
import 'package:kibz/dashboard/dashboard.dart';
import 'package:kibz/dashboard/unverifieddashboard.dart';
import 'package:kibz/dashboard/settings/profile.dart';
import 'package:kibz/dashboard/settings/account_settings.dart';
import 'package:kibz/dashboard/settings/general_settings.dart';
import 'package:kibz/signup1/phone.dart';
import 'package:kibz/signup1/birthdate.dart';
import 'package:kibz/signup1/id_doc.dart';
import 'package:kibz/signup1/names.dart';
import 'package:kibz/signup1/reg_completep1.dart';
import 'package:kibz/signup2/acc_verified.dart';
import 'package:kibz/signup2/job_pref.dart';
import 'package:kibz/dashboard/jobprompt.dart';
import 'package:kibz/signup2/payment_info.dart';
import 'package:kibz/signup2/profile_image_upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'employee.dart';
import 'employer.dart';
import 'methods.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    print('initialized');
    await Firebase.initializeApp(
        name: 'Main',
        options: const FirebaseOptions(
            appId: '1:291977155891:android:617af6b34c3e227d4d1a46',
            apiKey: 'AIzaSyCoz0Sy7OomgKNOb6rBEFK7ZQTMZWKCIQI',
            messagingSenderId: '291977155891',
            projectId: 'kibarua-ed33b'));
  } catch (e) {
    print('failed to initialize');
    Firebase.app('Main');
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey[850],
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  checkAuthorizationState();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(Homepage());
}

void checkAuthorizationState() {
  FirebaseAuth.instance.authStateChanges().listen(
    (User user) async {
      if (user == null) {
        isLoggedIn = false;
        print('User is not logged in');
      } else if (user != null) {
        isLoggedIn = true;
        print('User is logged in');
      }
    },
  );
}

bool isLoggedIn;
Color kibGreen = Color(0xFF00AC7C);

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Employee(),
        ),
        ChangeNotifierProvider.value(
          value: Employer(),
        ),
        ChangeNotifierProvider.value(
          value: ImageSelector(),
        ),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          title: 'Kibarua Workers',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            snackBarTheme: SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
            ),
            primaryColor: kibGreen,
            buttonColor: kibGreen,
            buttonTheme: ButtonThemeData(
              buttonColor: kibGreen,
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            colorScheme: ColorScheme.light(
              primary: kibGreen,
              onSecondary: Colors.white,
              secondary: Colors.grey[850],
            ),
            accentColor: kibGreen,
            appBarTheme: AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: kibGreen,
            ),
            fontFamily: 'Quicksand',
          ),
          initialRoute: isLoggedIn ? 'Dashboard' : 'Home',
//            initialRoute: 'Job Prompt',
          routes: {
            'Home': (context) => Welcome(),
            'Sign In': (context) => SignIn(),
            'Email': (context) => EmailPass(),
            'Dashboard': (context) => Dashboard(),
            'Profile': (context) => Profile(),
            'Account Settings': (context) => AccountSettings(),
            'General Settings': (context) => GeneralSettings(),
            'Names': (context) => Name(),
            'Complete': (context) => P1Complete(),
            'Phone': (context) => Phone(),
            'ID': (context) => IdDoc(),
            'DOB': (context) => Birthdate(),
            'Verified Page': (context) => VerifiedAccount(),
            'Profile Picture Upload': (context) => ProfileImageUpload(),
            'Payment': (context) => PaymentInfo(),
            'Job Preference': (context) => JobPref(),
            'Reg Complete': (context) => RegComplete(),
            'Job Prompt': (context) => JobPrompt(),
          },
        ),
      ),
    );
  }
}

pushMessagingService(BuildContext context) {
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true);
  FirebaseMessaging.instance.getInitialMessage();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.data}");
  if (message?.data['type'] == 'Job') {
    print('job was type from handler');
  }
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if(message.data['type'] == 'Job') {
      print('job was type from message opened');
    }
  });
  RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage?.data['type'] == 'Job') {
    print('gotten initial message');
  }
}
