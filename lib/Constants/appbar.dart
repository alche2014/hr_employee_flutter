import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/screen_notification.dart';
import 'package:hr_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

SliverAppBar buildMyNewAppBar(BuildContext context, String name, bool turn) {
  String userId;
  auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
  userId = firebaseUser!.uid;
  return SliverAppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    leading: name == "Leaves Management " ||
            name == "Notifications" ||
            name == "Announcement" ||
            name == "About" ||
            name == "Privacy & Security"
        ? IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? kContentColorLightTheme
                : Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            })
        : const Text(""),
    title: Text(
      name,
      style: TextStyle(
        fontFamily: 'Sodia',
        color: isdarkmode.value ? Colors.white : Colors.black,
      ),
    ),
    actions: <Widget>[
      if (turn == true)
        IconButton(
          //bell Icon
          icon: Icon(
            Icons.notifications,
            color: isdarkmode.value ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (context) => Notifications(uid: userId)));
          },
        )
    ],
  );
}

//======================================================================//
AppBar buildMyAppBar(BuildContext context, String name, bool turn) {
  //getting current user data
  late String userId;
  auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
  userId = firebaseUser!.uid;

  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      color: isdarkmode.value ? Colors.white : Colors.grey.shade800,
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text(
      name,
      style: TextStyle(
          fontFamily: 'Sodia',
          color: isdarkmode.value ? Colors.white : Colors.grey.shade800),
    ),
    actions: <Widget>[
      if (turn == true)
        IconButton(
          //bell Icon
          icon: Icon(
            Icons.notifications,
            color: isdarkmode.value ? Colors.white : Colors.grey.shade800,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (context) => Notifications(uid: userId)));
          },
        )
    ],
  );
}
