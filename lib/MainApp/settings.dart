// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/MainApp/privacy_screen.dart';
import 'package:hr_app/MainApp/screen_about_app.dart';
import 'package:hr_app/MainApp/screen_notification.dart';
import 'package:hr_app/UserprofileScreen.dart/my_profile_edit.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/MainApp/Login/auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          UpperPortion(userId: uid, title: "Settings", showBack: false),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.height - 260,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfilePic(),
                  const SizedBox(height: 20),
                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(width: 0, color: Colors.white),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           const Icon(
                  //             Icons.dark_mode,
                  //             color: kPrimaryColor,
                  //           ),
                  //           const SizedBox(width: 10),
                  //           Text(
                  //             'Dark mode',
                  //             style: TextStyle(
                  //                 color: Colors.grey[600], fontSize: 16),
                  //           ),
                  //         ],
                  //       ),
                  //       Switch(
                  //         value: darkmode,
                  //         onChanged: (value) async {
                  //           // SharedPreferences prefs =
                  //           //     await SharedPreferences.getInstance();
                  //           // Helper.savePreferenceString('darkmode', value);

                  //           setState(() {
                  //             darkmode = value;
                  //             // Helper.getPreferenceBoolean('darkmode');

                  //             isdarkmode.value = value;

                  //             // Helper.savePreferenceString(key, value)
                  //             // prefs.setBool('darkmode',
                  //             //     isdarkmode.value == false ? true : false);
                  //             // prefs.getBool('darkmode');
                  //           });
                  //         },
                  //         activeTrackColor: kPrimaryColor.withOpacity(0.6),
                  //         activeColor: kPrimaryColor,
                  //         inactiveThumbColor: Colors.grey,
                  //         inactiveTrackColor: Colors.grey[200],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => const Notifications()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0, color: Colors.white),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.notifications,
                                  color: kPrimaryColor),
                              const SizedBox(width: 10),
                              Text(
                                'Notifications',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 16),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => const PrivacyApp()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0, color: Colors.white),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.lock,
                                color: kPrimaryColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Privacy & Security',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 16),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => const AboutApp()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0, color: Colors.white),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error,
                            color: kPrimaryColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'About',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // user must tap button for close dialog!
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text('Quit'),
                              content: const Text(
                                  'Are you sure you want to LOGOUT?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    AuthService().signOut(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.logout,
                          color: isdarkmode.value == false
                              ? const Color(0xff34354A)
                              : Colors.grey[500]),
                      label: Text('Log Out',
                          style: TextStyle(
                              color: isdarkmode.value == false
                                  ? const Color(0xff34354A)
                                  : Colors.grey[500])),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        ]));
  }
}
