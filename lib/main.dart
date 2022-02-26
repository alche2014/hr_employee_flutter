import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/UserprofileScreen.dart/first_time_form.dart';
import 'package:hr_app/UserprofileScreen.dart/my_profile_edit.dart';
import 'package:hr_app/mainApp/Login/auth_provider.dart';
import 'package:hr_app/Constants/theme.dart';
import 'Constants/constants.dart';
import 'MainApp/bottom_nav_bar.dart';
import 'mainApp/Login/auth.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'mainApp/Login/google_login.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
const _kShouldTestAsyncErrorOnInit = false;
auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;

var totalemployee = 13;
String joiningDate = '';
var ontime = 10;
var lates = 3;
var absent = 0;
late Connectivity connectivity;
late StreamSubscription<ConnectivityResult> subscription;
late bool isNetwork = true;

late AnimationController controller;
late String buttonText = "CHECK IN";
late Position _currentPosition;
double? currentLat;
String yourAddress = "Location";
double? currentLng;
String? userId;
String? locationId;
String? shiftId;
double? officeLat;
double? officeLng;
String? companyId;
String? location;
late int hours = 00;
late int minutes = 00;
late int seconds = 00;
late Timestamp checkinTime;

late String docId;
late Timer timer;
// ScheduleController controllers;
late String to;
late String from;
late String shiftName;
late String token;
String empName = '';
String empEmail = '';
String uid = '';
int? weekend;
var weekendDefi;
double _hr = 0;
double _minute = 0;
String lateTime = "0 hrs & 0 mins";
late ScrollController con;
late Stream? stream;
String? name = '';
String? role;
List leaveData = [];
List<dynamic> leaveType = [];
late String reportingTo;
String imagePath = '';
File? image;
DocumentReference? documentReference;
bool announData = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

ValueNotifier<bool> isdarkmode = ValueNotifier(false);

void main() async {
  tz.initializeTimeZones();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await runZonedGuarded(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    Future.delayed(const Duration(seconds: 0), () {
      runApp(AuthProvider(
        auth: AuthService(),
        child: ValueListenableBuilder(
            valueListenable: isdarkmode,
            builder: (context, value, _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: darkmode == false
                    ? lightThemeData(context)
                    : darkThemeData(context),
                home: const Splash(),
                title: 'Smart HR',

                //routes of different screens
                routes: {
                  "/login": (BuildContext context) => GoogleLogin(),
                  "/app": (BuildContext context) => NavBar(0),
                  "/firstTimeForm": (BuildContext context) =>
                      const FirstTimeForm(),
                  // "/signininvite": (BuildContext context) => DynamicLinkScreen(),
                  "/invalidUser": (BuildContext context) =>
                      const MyProfileEdit(),
                  "/guestProfile": (BuildContext context) =>
                      const MyProfileEdit()
                },
              );
            }),
      ));
    });
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

// Define an async function to initialize FlutterFire

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hr"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  int _myValue = 3000;
  int _progress = 1500;

  @override
  void initState() {
    super.initState();

    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: _myValue), () {});
    //  Widget _defaultHome = GoogleLogin();

    // final FirebaseAuth _auth = FirebaseAuth.instance;

    //  auth service returns boolean
    bool _result = await AuthService().isLogin();
    // final User? user = await _auth.currentUser;

    if (_result) {
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(firebaseUser!.uid)
          .snapshots()
          .listen((onValue) {
        locationId = onValue.data()!["locationId"];
        shiftId = onValue.data()!["shiftId"];
        companyId = onValue.data()!["companyId"];
        reportingTo = onValue.data()!['reportingToId'];
        imagePath = onValue.data()!['imagePath'];
        empName = onValue.data()!['displayName'];
        empEmail = onValue.data()!['email'];
        leaveData = onValue.data()!['leaves'] ?? [];
        joiningDate = onValue.data()!['joiningDate'] ?? "";

        Future.delayed(const Duration(milliseconds: 150), () {
          if (shiftId != null) {
            // _getShiftSchedule();
          }
        });
      });
      //  checking user exists or not
      final user = FirebaseAuth.instance.currentUser!;
      bool _com = await AuthService().userExist(user);
      if (_com) {
        // returns bool checking the domain exist or not
        bool domainExist = await AuthService().domainExist(user);
        if (domainExist) {
          //domain exists
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => NavBar(0)));
        } else {
          bool _firstTime = await AuthService().firstTimeLogin(user);
          if (_firstTime) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const FirstTimeForm()));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MyProfileEdit()));
          }
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NavBar(0)));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => GoogleLogin()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/backimages.png'),
        fit: BoxFit.fill,
      ),
    )));
  }
}
