import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'package:flutter_offline/flutter_offline.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:connectivity/connectivity.dart' as conT;
import 'package:connectivity/connectivity.dart';
import 'package:hr_app/main.dart';

import 'auth.dart';

// google login functionality handles in the screen
class GoogleLogin extends StatefulWidget {
  const GoogleLogin({Key? key}) : super(key: key);
  @override
  _GoogleLoginState createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  // connectivity dependencies handle internet collection
  late conT.Connectivity connectivity;
  late StreamSubscription<conT.ConnectivityResult> subscription;
  bool isNetwork = true;

  @override
  void initState() {
    //check internet connection
    connectivity = conT.Connectivity();
    subscription = connectivity.onConnectivityChanged
        .listen((conT.ConnectivityResult result) {
      if (result == conT.ConnectivityResult.none) {
        setState(() {
          isNetwork = false;
        });
      } else if (result == conT.ConnectivityResult.mobile ||
          result == conT.ConnectivityResult.wifi) {
        setState(() {
          isNetwork = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            const LoadingDialog(value: "Loading")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backimages.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Container(
              //   margin: const EdgeInsets.only(bottom: 60),
              //   child: const Text("",
              //       style: TextStyle(
              //           color: Color(0xFF882020),
              //           fontFamily: "Overlock",
              //           fontStyle: FontStyle.normal,
              //           fontWeight: FontWeight.normal,
              //           fontSize: 30)),
              // ),
              const SizedBox(height: 300),
              _signInButton(),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 70, right: 70),
                  child: const Text(
                      "By clicking Sign in button , you agree to our Terms & Privacy policy.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  /* This button handles and check all existing domain and existing users in of company
 and  route or (Navigate) to screen according to the result */

  Widget _signInButton() {
    return
        //OfflineBuilder(connectivityBuilder: (
        // BuildContext context,
        // ConnectivityResult connectivity2,
        // Widget child,
        // )
        // {
        // if (connectivity2 == conT.ConnectivityResult.none) {
        // return
        //  SignInButton(
        //   Buttons.Google,
        //   onPressed: () {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(content: Text("No Internet Connection")));
        //   },
        // );
        // } else {
        //   return child;
        //  }
        // }, builder: (BuildContext context) {
        //return
        SignInButton(
      Buttons.Google,
      onPressed: () {
        authService.googleSignIn().whenComplete(() async {
          final User? user = FirebaseAuth.instance.currentUser;

          bool _result = await AuthService().userExist(user);

          if (_result) {
            showLoadingDialog(context);

            bool _result2 = await AuthService().guestExist(user);

            if (_result2) {
              bool domainExist = await AuthService().domainExist(user!);
              String? genderEmpstatus;

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
                      break;
                    }
                  }
                });
                bool firstTimeProfile =
                    await AuthService().firstTimeEmpLogin(user);
                if (firstTimeProfile) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/firstTimeForm', (Route<dynamic> route) => false);
                } else {
                  FirebaseFirestore.instance
                      .collection('employees')
                      .doc(user.uid)
                      .snapshots()
                      .listen((onValue) {
                    setState(() {
                      uid = user.uid;
                      designation =
                          onValue.data()!["designation"] ?? "Designation";
                      department =
                          onValue.data()!["department"] ?? "Department";
                      locationId = onValue.data()!["locationId"];
                      shiftId = onValue.data()!["shiftId"];
                      companyId = onValue.data()!["companyId"];
                      reportingTo = onValue.data()!['reportingToId'];
                      imagePath = onValue.data()!['imagePath'];
                      empName = onValue.data()!['displayName'];
                      empEmail = onValue.data()!['email'];
                      leaveData = onValue.data()!['leaves'] ?? [];
                      joiningDate = onValue.data()!['joiningDate'] ?? "";
                    });
                  });
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/app', (Route<dynamic> route) => false);
                }
              } else {
                FirebaseFirestore.instance
                    .collection("guests")
                    .doc(user.uid)
                    .set({
                  'uid': user.uid,
                  'email': "${user.email}",
                  'imagePath': "${user.photoURL}",
                  'displayName': "${user.displayName}",
                  'timeStamp': DateTime.now(),
                  'empId': null,
                  "containsId": false
                });
                bool firstTimeProfile =
                    await AuthService().firstTimeLogin(user);
                if (firstTimeProfile) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/firstTimeForm', (Route<dynamic> route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/invalidUser', (Route<dynamic> route) => false);
                }
              }
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/invalidUser', (Route<dynamic> route) => false);
            }
          } else {
            FirebaseFirestore.instance
                .collection('employees')
                .doc(user!.uid)
                .snapshots()
                .listen((onValue) {
              setState(() {
                print(
                    "logggggggggggggggggggggggggggggggggggggggggggggeeeesinnnn");
                uid = user.uid;
                designation = onValue.data()!["designation"] ?? "Designation";
                department = onValue.data()!["department"] ?? "Department";
                locationId = onValue.data()!["locationId"];
                shiftId = onValue.data()!["shiftId"];
                companyId = onValue.data()!["companyId"];
                reportingTo = onValue.data()!['reportingToId'];
                imagePath = onValue.data()!['imagePath'];
                empName = onValue.data()!['displayName'];
                empEmail = onValue.data()!['email'];
                leaveData = onValue.data()!['leaves'] ?? [];
                joiningDate = onValue.data()!['joiningDate'] ?? "";
              });
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/app', (Route<dynamic> route) => false);
            });
          }
        });
      },
    );
    //  });
  }
}
