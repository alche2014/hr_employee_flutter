// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/MainApp/privacy_screen.dart';
import 'package:hr_app/MainApp/screen_about_app.dart';
import 'package:hr_app/MainApp/screen_notification.dart';
import 'package:hr_app/UserprofileScreen.dart/my_profile_edit.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/Login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;
  String userId = "";
  String compId = '';
  String name = '';
  String imagePath = '';
  String designation = '';

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
    load();
    super.initState();
  }

  load() {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    userId = firebaseUser!.uid;

    FirebaseFirestore.instance
        .collection('employees')
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((onValue) {
      setState(() {});
      compId = onValue.data()!["companyId"];
      imagePath = onValue.data()!['imagePath'];
      name = onValue.data()!['displayName'];
      designation = onValue.data()!['designation'] ?? "";
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(),
          toolbarTextStyle: TextStyle(
            color: isdarkmode.value == false ? Colors.black : Colors.white,
          ),
          title: Text(
            'Settings',
            style: TextStyle(
                color: isdarkmode.value == false ? Colors.black : Colors.white),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            Notifications(uid: userId, key: null)));
              },
              icon: const Icon(Icons.notifications),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 40,
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: imagePath == null || imagePath == ''
                                ? const NetworkImage(
                                    'https://via.placeholder.com/150')
                                : NetworkImage(imagePath),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        )),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            designation,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.dark_mode,
                            color: kPrimaryColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Dark mode',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                      Switch(
                        value: darkmode,
                        onChanged: (value) async {
                          // SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // Helper.savePreferenceString('darkmode', value);

                          setState(() {
                            darkmode = value;
                            // Helper.getPreferenceBoolean('darkmode');

                            isdarkmode.value = value;

                            // Helper.savePreferenceString(key, value)
                            // prefs.setBool('darkmode',
                            //     isdarkmode.value == false ? true : false);
                            // prefs.getBool('darkmode');
                          });
                        },
                        activeTrackColor: kPrimaryColor.withOpacity(0.6),
                        activeColor: kPrimaryColor,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[200],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                Notifications(uid: userId, key: null)));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey.shade300),
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
                            builder: (context) => const MyProfileEdit()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey.shade300),
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
                              'Privacy',
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
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey.shade300),
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
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // user must tap button for close dialog!
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text('Quit'),
                          content:
                              const Text('Are you sure you want to LOGOUT?'),
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
              ],
            ),
          ),
        ));
  }
}
