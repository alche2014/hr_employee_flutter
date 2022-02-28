import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

//Global Initialization
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  showNotification() async {
    var time = Time(10, 51, 0); //at 3.30
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        //  channel.description
      ),
    );
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Teer Result Time',
        'Open The App and check for the Result',
        time,
        platformChannelSpecifics);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //-------------------- Initialization Code---------------------
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings();
    //--------------------------------------
    showNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
