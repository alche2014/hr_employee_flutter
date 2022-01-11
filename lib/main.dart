import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:hr_app/mainApp/Login/auth_provider.dart';
import 'package:hr_app/mainApp/bottom_navigation/bottom_nav_bar.dart';
import 'package:hr_app/mainApp/forms/form_1.dart';
import 'package:hr_app/mainApp/mainProfile/emp_profile_without_comp.dart';
import 'package:hr_app/profile/my_profile_edit.dart';
import 'package:hr_app/theme.dart';
import 'mainApp/Login/auth.dart';
import 'mainApp/Login/google_login.dart';
import 'mainApp/mainProfile/Announcemets/constants.dart';
import 'mainApp/main_home_profile/main_home_profile.dart';

ValueNotifier<bool> isdarkmode = ValueNotifier(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
              home: Splash(),
              title: 'HR EMP',

              //routes of different screens
              routes: {
                "/login": (BuildContext context) => GoogleLogin(),
                "/app": (BuildContext context) => NavBar(0),
                "/firstTimeForm": (BuildContext context) =>
                    const FirstTimeForm(),
                // "/signininvite": (BuildContext context) => DynamicLinkScreen(),
                "/invalidUser": (BuildContext context) =>
                    const EmpProfileWithoutComp(),
              },
            );
          }),
    ));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const EmpProfileWithoutComp()));
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
      backgroundColor: const Color(0XFFC53B4B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Image.asset(
              'assets/mainIcon.png',
              height: 140,
            ),
            const Spacer(flex: 4),
            TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: _progress),
              builder: (context, double? value, _) => Container(
                height: 15,
                width: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.transparent,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              ' 2021. All rights reserved',
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
