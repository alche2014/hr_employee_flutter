import 'package:flutter/material.dart';
import 'package:hr_app/mainApp/notifications/main_notification.dart';

import '../colors.dart';

AppBar buildMyAppBar(BuildContext context, String name, bool turn ) {
  
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      color: MediaQuery.of(context).platformBrightness == Brightness.light
          ? kContentColorLightTheme
          : Colors.grey,
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text(
      name,
      style: TextStyle(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? kContentColorLightTheme
              : Colors.grey),
    ),
    actions: <Widget>[
      if(turn==true)
        IconButton(
          //bell Icon
          icon: Icon(
            Icons.notifications,
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? kContentColorLightTheme
                : Colors.grey,
          ),
          onPressed: () {
            Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainNotification()));
          },
        )
    ],
  );
}
