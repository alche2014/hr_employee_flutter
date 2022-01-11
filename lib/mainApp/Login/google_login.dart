import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';

import 'auth.dart';

// google login functionality handles in the screen
class GoogleLogin extends StatefulWidget {
  const GoogleLogin({Key? key}) : super(key: key);
  @override
  _GoogleLoginState createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  // connectivity dependencies handle internet collection
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;

  @override
  void initState() {
    //check internet connection
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isNetwork = false;
        });
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
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
        pageBuilder: (BuildContext context, _, __) => LoadingDialog()));
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
                  margin: const EdgeInsets.only(top: 10, left: 80, right: 80),
                  child: const Text(
                      "By clicking Sign in button , you agree to our Terms & Privacy policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 13)),
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
    return OfflineBuilder(connectivityBuilder: (
      BuildContext context,
      ConnectivityResult connectivity2,
      Widget child,
    ) {
      if (connectivity2 == ConnectivityResult.none) {
        return SignInButton(
          Buttons.Google,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No Internet Connection")));
          },
        );
      } else {
        return child;
      }
    }, builder: (BuildContext context) {
      return SignInButton(
        Buttons.Google,
        onPressed: () {
          showLoadingDialog(context);

          authService.googleSignIn().whenComplete(() async {
            final user = FirebaseAuth.instance.currentUser;

            bool _result = await AuthService().userExist(user);

            if (_result) {
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
                      print(documents[i].id);
                      FirebaseFirestore.instance
                          .collection("employees")
                          .doc("${user.uid}")
                          .set({
                        'uid': "${user.uid}",
                        'email': "${user.email}",
                        'imagePath': "${user.photoURL}",
                        'displayName': "${user.displayName}",
                        "companyId": documents[i].id,
                        "gender": genderEmpstatus ?? null,
                        'timeStamp': DateTime.now(),
                        'empId': null,
                        "active": true,
                        "containsId": false
                      });
                      break;
                    }
                  }
                });
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/app', (Route<dynamic> route) => false);
              } else {
                // String? genderstatus;
                // await FirebaseFirestore.instance
                //     .collection("guests")
                //     .doc(user.uid)
                //     .get()
                //     .then((onValue) {
                //   final Map<String, dynamic>? documents = onValue.data();
                //   genderstatus = documents!["gender"];
                //   print("genderstatus::::::::::::::::$genderstatus");
                // });
                FirebaseFirestore.instance
                    .collection("guests")
                    .doc(user.uid)
                    .update({
                  'guestUid': user.uid,
                  'email': "${user.email}",
                  'imagePath': "${user.photoURL}",
                  'displayName': "${user.displayName}",
                  'timeStamp': DateTime.now(),
                  'empId': null,
                  // "gender": genderstatus ?? null,
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
                  '/app', (Route<dynamic> route) => false);
            }
          });
        },
      );
    });
  }
}
