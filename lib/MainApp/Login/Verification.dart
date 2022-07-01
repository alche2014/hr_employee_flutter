// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/MainApp/Login/auth.dart';
import 'package:hr_app/MainApp/Login/google_login.dart';
import 'package:hr_app/main.dart';

// ignore: must_be_immutable
class EmailVerification extends StatefulWidget {
  bool? link;
  EmailVerification({this.link, Key? key}) : super(key: key);

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  Timer? timer;
  bool value = false;
  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      authService.signOut(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const GoogleLogin()),
          (Route<dynamic> route) => false);
    }
    if (widget.link != true) {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        widget.link = true;
      }
    }
    // checkEmailVerified(widget.isOwner, widget.link);
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified(widget.link);
    });
    // Future.delayed(const Duration(seconds: 2), () {
    //   // setState(() {
    //     value = true;
    //   // });
    // });

    super.initState();
  }

  @override
  void dispose() {
    // Future.delayed(const Duration(seconds: 5), () {
    timer!.cancel();
    // });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
          child: Column(children: [
        upperPortion(),
        Container(
            // height: MediaQuery.of(context).size.height / 2.2,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "  Verify Your Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 15),
                Text(
                    'A verification link has been sent to your Email, Kindly verify to continue',
                    textAlign: TextAlign.center,
                    style: TextFieldHeadingStyle()),
                const SizedBox(height: 25),
                ElevatedButton(
                    onPressed: () {
                      print(
                          "email verifieeeeeedddddddd: ${FirebaseAuth.instance.currentUser!.emailVerified}");
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification()
                          .then((value) => Fluttertoast.showToast(
                              msg:
                                  "Verification Link has been sent to your Email"));
                    },
                    child: const Text('Send Verification Email again'),
                    style: ElevatedButton.styleFrom(primary: purpleDark)),
                const SizedBox(height: 10),
                Text('OR',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      authService.signOut(context);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => GoogleLogin()),
                          (Route<dynamic> route) => false);
                    },
                    child: const Text('Login with Another Account'),
                    style: ElevatedButton.styleFrom(primary: purpleDark)),
              ],
            ))
      ])),
    );
  }

  Widget upperPortion() {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height / 1.8,
            width: MediaQuery.of(context).size.width,
            color: purpleDark,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logos.png',
                  height: 70,
                  width: 70,
                ),
                const SizedBox(height: 20),
                const Text(
                  "SMART HR",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            )),
        Positioned(
          top: MediaQuery.of(context).size.height / 1.7 - 60,
          left: 0,
          right: 0,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                color: Colors.grey.shade100),
          ),
        ),
      ],
    );
  }

  checkEmailVerified(link) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload();

    if (user.emailVerified) {
      timer!.cancel();
      bool _result = await AuthService().userExist(user);
      if (_result) {
        // showLoadingDialog(context);S
        bool _result2 = await AuthService().guestExist(user);
        if (_result2) {
          bool domainExist = await AuthService().domainExist(user);
          if (domainExist) {
            List domainList = [];
            String? userEmail = user.email;
            var domainPart = userEmail!.split('@');
            await FirebaseFirestore.instance
                .collection("company")
                .get()
                .then((onValue) {
              final List<DocumentSnapshot> documents = onValue.docs;

              for (int i = 0; i < documents.length; i++) {
                domainList = documents[i]["domain"];
                if (domainList.contains(domainPart[1])) {
                  FirebaseFirestore.instance
                      .collection("employees")
                      .doc(user.uid)
                      .set({
                    'uid': user.uid,
                    'email': "${user.email}",
                    'imagePath': "${user.photoURL}",
                    'displayName': "${user.displayName}",
                    "companyId": documents[i].id,
                    'timeStamp': DateTime.now(),
                    'empId': null,
                    "active": true,
                    "containsId": false
                  });
                  setState(() {
                    guest = 1;
                    uid = user.uid;
                    designation = "Designation";
                    department = "Department";
                    locationId = null;
                    shiftId = null;
                    companyId = documents[i].id;
                    reportingTo = "";
                    leaveData = [];
                    joiningDate = "";
                    empEmail = user.email!;
                  });
                  break;
                }
              }
            });
            bool firstTimeProfile = await AuthService().firstTimeEmpLogin(user);
            if (firstTimeProfile) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/firstTimeForm', (Route<dynamic> route) => false);
            }
          } else {
            FirebaseFirestore.instance.collection("guests").doc(user.uid).set({
              'uid': user.uid,
              'email': "${user.email}",
              'imagePath': null,
              'displayName': null,
              'timeStamp': DateTime.now(),
              'empId': null,
              "containsId": false
            });
            setState(() {
              guest = 0;
              uid = user.uid;
              designation = "Designation";
              department = "Department";
              locationId = null;
              shiftId = null;
              companyId = null;
              reportingTo = "";
              leaveData = [];
              joiningDate = "";
              empEmail = user.email!;
            });
            bool firstTimeProfile = await AuthService().firstTimeLogin(user);
            if (firstTimeProfile) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/firstTimeForm', (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/invalidUser', (Route<dynamic> route) => false);
            }
          }
        }
      }
    } else {
      setState(() {
        value = true;
      });
    }
  }
}
