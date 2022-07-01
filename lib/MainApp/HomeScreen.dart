// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:hr_app/MainApp/CheckIn/team_check_in.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/main_home_profile/screen_announcement.dart';
import 'package:hr_app/MainApp/screen_notification.dart';
import 'package:hr_app/UserprofileScreen.dart/my_profile_edit.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/MainApp/annoucment_screen.dart';
import 'package:hr_app/MainApp/CheckIn/main_check_in.dart';
import 'package:hr_app/MainApp/LeaveManagement/leave_management.dart';
import 'package:hr_app/MainApp/main_home_profile/leave_approval.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:location/location.dart' as loc;
import 'package:connectivity/connectivity.dart' as conT;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    description:
        'This channel is used for important notifications.', // description,
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HrDashboard extends StatefulWidget {
  const HrDashboard({Key? key}) : super(key: key);

  @override
  _HrDashboardState createState() => _HrDashboardState();
}

class _HrDashboardState extends State<HrDashboard>
    with TickerProviderStateMixin {
  late conT.Connectivity connectivity;
  late StreamSubscription<conT.ConnectivityResult> subscription;
  late bool isNetwork = true;
  int team = 0;
  late AnimationController controller;
  late String buttonText = "CLOCK IN";
  double? currentLat;
  double? currentLng;
  double? officeLat;
  double? officeLng;
  DateTime? time;
  late int hours = 00;
  late int minutes = 00;
  late int seconds = 00;
  Timestamp checkinTime = Timestamp.fromDate(DateTime.now());
  late String docId;
  late String to;
  late String from;
  late String shiftName;
  late String token;
  late Timer timer;
  DateTime dateAuto = DateTime.now();
  int? weekend;
  var utcOffset;
  var weekendDefi;
  String todaysAttendance = "no";
  late Timestamp todayIn = Timestamp.fromDate(DateTime.now());
  late Timestamp todayOut = Timestamp.fromDate(DateTime.now());
  String? todayhrs;
  double _hr = 0;
  double _minute = 0;
  String lateTime = "0 hrs & 0 mins";
  late ScrollController con;
  late Stream? stream;
  String? role;
  File? image;
  DocumentReference? documentReference;
  bool announData = false;

  List timeZones = [
    {"country": "PAKISTAN", "region": "Asia/karachi"},
    {"country": "UNITED ARAB EMIRATES", "region": "Asia/dubai"},
    {"country": "American Samoa", "region": "America/Swift_Current"}
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 950), () {
      setState(() {});
    });

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
        if (mounted) {
          setState(() {
            isNetwork = true;
          });
        }
      }
    });
    load();

    if (shiftId != null) {
      _getShiftSchedule();
    } else {
      weekendDefi = ["Sat0", "Sun0"];
    }
    if (locationId != null) {
      _getOfficeLocation();
    }
    determinePosition();
    loadTeam();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      loadFirebaseUser();
      loadcheckout();
      currentTime = currentTime!.add(const Duration(seconds: 1));
    });
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 32400),
    );
    super.initState();

    con = ScrollController();
    con.addListener(() {
      if (con.offset >= con.position.maxScrollExtent &&
          !con.position.outOfRange) {
        setState(() {});
      } else if (con.offset <= con.position.minScrollExtent &&
          !con.position.outOfRange) {
        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          setState(() {});
        }
      }
    });
    firebaseMessaging.getToken().then((tempToken) {
      FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .update({"deviceToken": "$tempToken"});
      setState(() {
        token = tempToken!;
      });
    });
    notificationsCall();
    firebaseCloudMessagingListeners();
  }

  notificationsCall() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      var androiInit =
          const AndroidInitializationSettings("@mipmap/ic_launcher"); //for logo
      var iosInit = const IOSInitializationSettings();
      var initSetting =
          InitializationSettings(android: androiInit, iOS: iosInit);

      Map<String, dynamic> dataVale = message.data;
      String callBack = dataVale["click"].toString();

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.initialize(initSetting,
            onSelectNotification: (String? payload) {
          if (message.notification!.title == "Leave Request") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LeaveApprovalScreen(
                        docId: message.data['docId'],
                        empId: message.data['employeeId'])));
          }
          // if title is Annoucement type then screen navigate to Leave approval Screen
          else if (message.data["title"] == "Announcement") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ShowAnnouncementScreen(docId: message.data['docId'])));
          }
        });
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: "hello",
              color: Colors.blue,
              playSound: true,
              importance: Importance.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: callBack,
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic> dataVale = message.data;
      String callBack = dataVale["click"].toString();
      var androiInit =
          const AndroidInitializationSettings("@mipmap/ic_launcher"); //for logo
      var iosInit = const IOSInitializationSettings();
      var initSetting =
          InitializationSettings(android: androiInit, iOS: iosInit);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.initialize(initSetting,
            onSelectNotification: (String? payload) {
          if (message.notification!.title == "Leave Request") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LeaveApprovalScreen(
                        docId: message.data['docId'],
                        empId: message.data['employeeId'])));
          }
          // if title is Annoucement type then screen navigate to Leave approval Screen
          else if (message.data["title"] == "Announcement") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ShowAnnouncementScreen(docId: message.data['docId'])));
          }
        });
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: "hello",
              color: Colors.blue,
              playSound: true,
              importance: Importance.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: callBack,
        );
      }
    });
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic> dataVale = message.data;
      String callBack = dataVale["click"].toString();
      var androiInit =
          const AndroidInitializationSettings("@mipmap/ic_launcher");
      var iosInit = const IOSInitializationSettings();
      var initSetting =
          InitializationSettings(android: androiInit, iOS: iosInit);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.initialize(initSetting,
            onSelectNotification: (String? payload) {
          if (message.notification!.title == "Leave Request") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LeaveApprovalScreen(
                        docId: message.data['docId'],
                        empId: message.data['employeeId'])));
          }
          // if title is Annoucement type then screen navigate to Leave approval Screen
          else if (message.data["title"] == "Announcement") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ShowAnnouncementScreen(docId: message.data['docId'])));
          }
        });
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: "hello",
              color: Colors.blue,
              playSound: true,
              importance: Importance.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: callBack,
        );
      }
    });
    firebaseCloudMessagingListeners();
  }

  apiCall(area) async {
    final jsonValue = await http.Client().get(Uri.parse(
        "http://worldtimeapi.org/api/timezone/${timeZones[area]['region']}"));
    var responseBody = (jsonValue.body);
    var parsedJson = json.decode(responseBody);
    utcOffset = parsedJson['utc_offset'];

    if (mounted) {
      setState(() {
        time = DateTime.parse(parsedJson['datetime']);
        currentTime = parsedJson['utc_offset'].contains("+")
            ? DateTime.parse(parsedJson['datetime']).add(Duration(
                hours: int.parse(parsedJson['utc_offset']
                    .split(':')[0]
                    .replaceAll("+", '')
                    .trim()),
                minutes: int.parse(parsedJson['utc_offset'].split(':')[1])))
            : DateTime.parse(parsedJson['datetime']).subtract(Duration(
                hours: int.parse(parsedJson['utc_offset']
                    .split(':')[0]
                    .replaceAll("-", '')
                    .trim()),
                minutes: int.parse(parsedJson['utc_offset'].split(':')[1])));
        if (shiftId != null) {
          notification8_55();
          notification9_05();
          notification5_55();
          notification6_05();
        }
        loadcheckout();
        loadFirebaseUser();
      });
    }
  }

  tz.TZDateTime _nextInstanceOf8_55() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year);
    if (!weekendDefi.contains(
            "${DateFormat('EEE').format(currentTime!)}${(currentTime!.day / 8).toInt() + 1}") &&
        !weekendDefi.contains("${DateFormat('EEE').format(currentTime!)}0")) {
      var fromTime = from.split(":")[1].contains("PM")
          ? int.parse(from.split(":")[0]) + 11
          : int.parse(from.split(":")[0]) - 1;

      if (buttonText == "CLOCK IN") {
        print(
            "before 9: ${fromTime - (int.parse(utcOffset.split(':')[0].replaceAll("+", '').trim()))}");
        scheduledDate = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            fromTime -
                (int.parse(utcOffset.split(':')[0].replaceAll("+", '').trim())),
            55);
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }
      }
    }
    return scheduledDate;
  }

  Future<void> notification8_55() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Check In Reminder!',
        'Don’t Forget to Check In your attendance at $from',
        _nextInstanceOf8_55(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id', 'Checkin Reminder',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  tz.TZDateTime _nextInstanceOf9_05() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year);
    if (!weekendDefi.contains(
            "${DateFormat('EEE').format(currentTime!)}${(currentTime!.day / 8).toInt() + 1}") &&
        !weekendDefi.contains("${DateFormat('EEE').format(currentTime!)}0")) {
      var fromTime = from.split(":")[1].contains("PM")
          ? int.parse(from.split(":")[0]) + 12
          : int.parse(from.split(":")[0]);

      if (buttonText == "CLOCK IN") {
        scheduledDate = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            fromTime -
                (int.parse(utcOffset.split(':')[0].replaceAll("+", '').trim())),
            05);
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }
      }
    }
    return scheduledDate;
  }

  Future<void> notification9_05() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Check In Reminder!',
        'Don’t Forget to Check In your attendance $from',
        _nextInstanceOf9_05(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id', 'Checkin Reminder',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  tz.TZDateTime _nextInstanceOf5_55() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year);
    if (!weekendDefi.contains(
            "${DateFormat('EEE').format(currentTime!)}${(currentTime!.day / 8).toInt() + 1}") &&
        !weekendDefi.contains("${DateFormat('EEE').format(currentTime!)}0")) {
      var toTime = to.split(":")[1].contains("PM")
          ? int.parse(to.split(":")[0]) + 11
          : int.parse(to.split(":")[0]) - 1;
      print(
          "before 6: ${toTime - (int.parse(utcOffset.split(':')[0].replaceAll("+", '').trim()))}");

      if (buttonText == "CLOCK OUT") {
        scheduledDate = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            toTime -
                (int.parse(utcOffset.split(':')[0].replaceAll("+", '').trim())),
            55);
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }
      }
    }
    return scheduledDate;
  }

  Future<void> notification5_55() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        'Check Out Reminder!',
        'Don’t Forget to Check Out at $to',
        _nextInstanceOf5_55(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id', 'Checkin Reminder',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  tz.TZDateTime _nextInstanceOf6_05() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year);
    if (!weekendDefi.contains(
            "${DateFormat('EEE').format(currentTime!)}${(currentTime!.day / 8).toInt() + 1}") &&
        !weekendDefi.contains("${DateFormat('EEE').format(currentTime!)}0")) {
      var toTime = to.split(":")[1].contains("PM")
          ? int.parse(to.split(":")[0]) + 12
          : int.parse(to.split(":")[0]);
      print(
          "after 6: ${toTime - (int.parse(utcOffset.split(':')[0].replaceAll("+", '').trim()))}");

      if (buttonText == "CLOCK OUT") {
        scheduledDate = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            toTime -
                (int.parse(utcOffset.split(':')[0].replaceAll("+", '').trim())),
            05);
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }
      }
    }
    return scheduledDate;
  }

  Future<void> notification6_05() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        3,
        'Check Out Reminder!',
        'Don’t Forget to Check Out $to',
        _nextInstanceOf6_05(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id', 'Checkin Reminder',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  tz.TZDateTime _autoCheckout3am(id) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year);
    DocumentReference reference =
        FirebaseFirestore.instance.collection("attendance").doc(id);
    String date1 = "${DateFormat("yyyy-MM-dd ").format(checkinTime.toDate())}" +
        "${DateFormat("HH:mm").format(DateFormat.jm().parse(to))}";
    var xxx = DateFormat("yyyy-MM-dd HH:mm").parse(date1);

    int a = xxx.difference(checkinTime.toDate()).inSeconds;

    double hoursD = a / 3600;
    double minutesD = (a % 3600) / 60;
    double secondsD = (a % 60);
    if (buttonText == "CLOCK OUT") {
      if (now.hour == 19) {
        reference.update({
          "checkout":
              DateTime(dateAuto.year, dateAuto.month, dateAuto.day, 00, 00),
          "workHours":
              "${hoursD.toInt()} : ${minutesD.toInt()} : ${secondsD.toInt()}"
        });

        scheduledDate =
            tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, 00);
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }
      }
    }
    return scheduledDate;
  }

  Future<void> autoCheckout(id) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        4,
        'Warning',
        'You forgot to Clock Out today',
        _autoCheckout3am(id),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id', 'clock out',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void firebaseCloudMessagingListeners() {
    firebaseMessaging.setAutoInitEnabled(true);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  void fetchLinkData() async {
    // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
    var link = await FirebaseDynamicLinks.instance.getInitialLink();

    // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
    handleLinkData(link!);
  }

  void handleLinkData(PendingDynamicLinkData data) {
    final Uri? uri = data.link;
    if (uri != null) {
      final queryParams = uri.queryParameters;
    }
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  load() {
    firebaseMessaging.getToken().then((tempToken) {
      FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .update({"deviceToken": "$tempToken"});
      setState(() {
        token = tempToken!;
      });
    });
  }

  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

//getting current user data
  loadFirebaseUser() async {
    await FirebaseFirestore.instance
        .collection('attendance')
        .where("empId", isEqualTo: uid)
        .where("date",
            isEqualTo: DateFormat('MMMM dd yyyy').format(currentTime!))
        .get()
        .then((onValue) {
      if (onValue.docs.isEmpty) {
        if (mounted) {
          setState(() {
            todaysAttendance = "no";
          });
        }
      } else if (onValue.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            todayIn = onValue.docs.first.data()["checkin"];
            todayOut = onValue.docs.first.data()["checkout"];
            todayhrs = onValue.docs.first.data()["workHours"];
            todaysAttendance = "yes";
          });
        }
      }
    });
  }

  loadcheckout() async {
    FirebaseFirestore.instance
        .collection('attendance')
        .where("empId", isEqualTo: uid)
        .where("checkout", isNull: true)
        .get()
        .then((onValue) {
      if (onValue.docs.isEmpty) {
        setState(() {
          buttonText = "CLOCK IN";
        });
      } else if (onValue.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            checkinTime = onValue.docs.first.data()["checkin"] as Timestamp;
            docId = onValue.docs.first.data()["docId"];
            lateTime = onValue.docs.first.data()["late"];
            String difference = onValue.docs.first.data()["checkin"] == null
                ? "0"
                : "${DateTime.parse(currentTime!.toString().replaceAll('Z', '')).difference(checkinTime.toDate()).inSeconds}";

            int weekendDef = int.parse(difference);

            double hoursD = weekendDef / 3600;
            double minutesD = (weekendDef % 3600) / 60;
            double secondsD = (weekendDef % 60);
            hours = hoursD.toInt();
            minutes = minutesD.toInt();
            seconds = secondsD.toInt();
            buttonText = "CLOCK OUT";
            if (shiftId != null) {
              if (utcOffset != null) {
                notification5_55();
                notification6_05();
              }
            }
          });
        }
      }
    });
  }

  loadTeam() {
    FirebaseFirestore.instance
        .collection('employees')
        .where("reportingToId", isEqualTo: uid)
        .where("active", isEqualTo: true)
        .snapshots()
        .listen((onValue) async {
      setState(() {
        team = onValue.docs.length;
      });
    });
    FirebaseFirestore.instance
        .collection('employees')
        .doc(uid)
        .snapshots()
        .listen((onValue) async {
      if (mounted) {
        setState(() {
          leaveData = onValue.data()!['leaves'] ?? [];
        });
      }
    });
  }

// getting employee shift so that employee cannot checkin in weekends
  _getShiftSchedule() {
    FirebaseFirestore.instance
        .collection('shiftSchedule')
        .doc(shiftId)
        .snapshots()
        .listen((onValue) {
      setState(() {
        to = onValue.data()!["to"];
        from = onValue.data()!["from"];
        shiftName = onValue.data()!["shiftName"];
        weekendDefi = onValue.data()!["weekendDef"];
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Column(children: [
            const UpperPortion(),
            currentTime == null
                ? Container()
                : Text(
                    DateFormat('hh:mm a').format(currentTime!),
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  ),
            currentTime == null
                ? Container()
                : Center(
                    child: InkWell(
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          DateFormat('EEEE, dd MMMM yyyy').format(currentTime!),
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              color: greyShade,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 18),
            OfflineBuilder(connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity2,
              Widget child,
            ) {
              if (connectivity2 == conT.ConnectivityResult.none) {
                return Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          tileMode: TileMode.clamp,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [purpleLight, purpleDark]),
                      shape: BoxShape.circle),
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.white,
                          content: Text("No Internet Connection")));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Group.png',
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(height: 15),
                        Text(buttonText,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15)),
                      ],
                    ),
                  ),
                );
              } else {
                return child;
              }
            }, builder: (BuildContext context) {
              return Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          tileMode: TileMode.clamp,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [purpleLight, purpleDark]),
                      shape: BoxShape.circle),
                  child: InkWell(
                      onTap: () {
                        if (buttonText == "CLOCK OUT") {
                          if (locationId != null) {
                            _getOfficeLocation();
                            determinePosition();
                            setState(() {
                              Future.delayed(const Duration(milliseconds: 150),
                                  () {
                                location == "ON"
                                    ? _calculations()
                                    : noLocationCheckin();
                              });
                            });
                          } else {
                            noLocationCheckin();
                          }
                        } else if (shiftId != null) {
                          if (weekendDefi.contains(
                                  "${DateFormat('EEE').format(currentTime!)}${(currentTime!.day / 8).toInt() + 1}") ||
                              weekendDefi.contains(
                                  "${DateFormat('EEE').format(currentTime!)}0")) {
                            Fluttertoast.showToast(
                                msg: "Today is not a working day");
                          } else {
                            if (locationId != null) {
                              _getOfficeLocation();
                              determinePosition();
                              setState(() {
                                Future.delayed(
                                    const Duration(milliseconds: 150), () {
                                  location == "ON"
                                      ? _calculations()
                                      : noLocationCheckin();
                                });
                              });
                            } else {
                              noLocationCheckin();
                            }
                          }
                        } else {
                          if (!weekendDefi.contains(
                                  "${DateFormat('EEE').format(currentTime!)}${(currentTime!.day / 8).toInt() + 1}") &&
                              !weekendDefi.contains(
                                  "${DateFormat('EEE').format(currentTime!)}0")) {
                            if (locationId != null) {
                              _getOfficeLocation();
                            } else {
                              noLocationCheckin();
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Today is not a working day");
                          }
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/Group.png',
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(height: 15),
                          Text(buttonText,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15)),
                        ],
                      )));
            }),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 20,
                  color: Colors.grey,
                ),
                Text("Location: $yourAddress",
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: greyShade)),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/checkin.png',
                        height: 25,
                        width: 25,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          buttonText == "CLOCK IN"
                              ? todaysAttendance == "yes"
                                  ? todayIn != null
                                      ? DateFormat('K:mm a')
                                          .format(todayIn.toDate())
                                          .toString()
                                      : DateFormat('K:mm a')
                                          .format(checkinTime.toDate())
                                          .toString()
                                  : " -- : --"
                              : todaysAttendance == "yes"
                                  ? todayIn != null
                                      ? DateFormat('K:mm a')
                                          .format(todayIn.toDate())
                                          .toString()
                                      : DateFormat('K:mm a')
                                          .format(checkinTime.toDate())
                                          .toString()
                                  : checkinTime != null
                                      ? DateFormat('K:mm a')
                                          .format(checkinTime.toDate())
                                          .toString()
                                      : DateFormat('K:mm a')
                                          .format(DateTime.now())
                                          .toString(),
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Text("Clock in",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: lightGrey)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/checkout.png',
                        height: 25,
                        width: 25,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          buttonText == "CLOCK OUT"
                              ? "-- : --"
                              : todaysAttendance == "yes"
                                  ? todayOut == null
                                      ? DateFormat('K:mm a')
                                          .format(currentTime!)
                                          .toString()
                                      : DateFormat('K:mm a')
                                          .format(todayOut.toDate())
                                          .toString()
                                  : "-- : --",
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Text("Clock out",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: lightGrey)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/workingHrs.png',
                        height: 25,
                        width: 25,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          buttonText == "CLOCK OUT"
                              ? "$hours : $minutes : $seconds"
                              : todaysAttendance == "yes"
                                  ? todayhrs == null
                                      ? "$hours : $minutes : $seconds"
                                      : todayhrs!
                                  : "-- : --",
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Text("Working Hrs",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: lightGrey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MainCheckIn()));
                },
                child: const Text('View History',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5B3F6E)))),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
              height: 1,
              color: Colors.grey.shade300,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 3,
                        child: miniCards(
                            'assets/announcement.jpg', "Announcements")),
                    Expanded(
                        flex: 3,
                        child: miniCards('assets/leaves.png', "Leaves")),
                    Expanded(
                        flex: 3,
                        child: miniCards('assets/myTeam.png', "My Team")),
                  ]),
            )
          ]),
        ));
  }

  // office and current location difference calculator
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  determinePosition() async {
    loc.Location location = loc.Location();
    bool serviceEnabled;
    PermissionStatus _permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }

    LocationData position = await location.getLocation();
    currentLat = position.latitude;
    currentLng = position.longitude;
    Map<String, String> markPlace = Map();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude!, position.longitude!);
    yourAddress = placemarks.first.street! +
        ", " +
        placemarks.first.subLocality! +
        ", " +
        placemarks.first.locality!;
    apiCall(timeZones.indexWhere(
        (i) => placemarks.first.country!.toUpperCase() == i['country']));
    if (mounted) {
      setState(() {});
    }
  }

//geting office location
  _getOfficeLocation() {
    if (locationId != null) {
      FirebaseFirestore.instance
          .collection('locations')
          .doc("$locationId")
          .snapshots()
          .listen((onValue) {
        setState(() {});
        officeLat = onValue.data()!["lat"];
        officeLng = onValue.data()!["lng"];
        location = onValue.data()!["location"];
      }).onDone(() {
        determinePosition();
        setState(() {
          Future.delayed(const Duration(milliseconds: 150), () {
            location == "ON" ? _calculations() : noLocationCheckin();
          });
        });
      });
      // } else {
      // return Fluttertoast.showToast(msg: "Kindly set office location first");
    }
  }

//calculate difference between current and office location
  _calculations() {
    if (currentLat == null || currentLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text("Unable to get current location",
              style: TextStyle(color: Colors.black)),
        ),
      );
    } else {
      List<dynamic> data = [
        {"lat": officeLat, "lng": officeLng},
        {"lat": currentLat, "lng": currentLng}
      ];
      double totalDistance = 0;
      totalDistance = calculateDistance(
          data[0]["lat"], data[0]["lng"], data[1]["lat"], data[1]["lng"]);
      double disMeters = totalDistance * 300;

      if (disMeters < 300) {
        if (buttonText == "CLOCK IN") {
          checkin();
        } else if (buttonText == "CLOCK OUT") {
          checkout();
        }
      } else {
        Fluttertoast.showToast(
            msg: "Your location is not matched with office location");
      }
    }
  }

//location based checkin in off
  noLocationCheckin() {
    if (buttonText == "CLOCK IN") {
      checkin();
    } else if (buttonText == "CLOCK OUT") {
      checkout();
    }
  }

//checkin
  checkin() async {
    setState(() {
      buttonText = "CLOCK OUT";
    });
    var a;
    var b;
    if (shiftId == null) {
      a = 9;
      b = 0;
    } else {
      DateTime date = DateFormat.jm().parse(from);
      String ll = DateFormat("HH:mm").format(date);
      List ab = ll.split(":");
      a = int.parse(ab[0]);
      b = int.parse(ab[1]);
    }

    TimeOfDay yourTime = TimeOfDay(hour: a, minute: b);
    TimeOfDay nowTime =
        TimeOfDay(hour: currentTime!.hour, minute: currentTime!.minute);

    double _doubleyourTime =
        yourTime.hour.toDouble() + (yourTime.minute.toDouble() / 60);
    double _doubleNowTime =
        nowTime.hour.toDouble() + (nowTime.minute.toDouble() / 60);

    double _timeDiff = _doubleNowTime - _doubleyourTime;

    _minute = ((_timeDiff - _timeDiff.truncate()) * 60) < 0
        ? 0
        : (_timeDiff - _timeDiff.truncate()) * 60;
    _hr = _timeDiff.truncateToDouble() < 0 || _timeDiff.truncateToDouble() == -0
        ? 0
        : _timeDiff.truncateToDouble();
    await FirebaseFirestore.instance
        .collection('attendance')
        .where("empId", isEqualTo: uid)
        .where("date",
            isEqualTo: DateFormat('MMMM dd yyyy').format(currentTime!))
        .get()
        .then((onValue) async {
      if (onValue.docs.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('attendance')
            .doc(onValue.docs[0].id)
            .snapshots()
            .listen((value) {
          if (mounted) {
            setState(() {});
            hours = int.parse(value.data()!['workHours'].split(":")[0]);
            minutes = int.parse(value.data()!['workHours'].split(":")[1]);
            seconds = int.parse(value.data()!['workHours'].split(":")[2]);
          }
        });
        FirebaseFirestore.instance
            .runTransaction((Transaction transaction) async {
          DocumentReference reference = FirebaseFirestore.instance
              .collection("attendance")
              .doc(onValue.docs[0].id);
          await reference.update({"checkout": null});
        });
      } else {
        FirebaseFirestore.instance
            .runTransaction((Transaction transaction) async {
          DocumentReference reference =
              FirebaseFirestore.instance.collection("attendance").doc();

          await reference.set({
            "date": DateFormat('MMMM dd yyyy').format(currentTime!),
            "reportingToId": reportingTo,
            "checkin": FieldValue.serverTimestamp(),
            "empId": uid,
            "name": empName,
            "late":
                "${_hr.toStringAsFixed(0)} hrs & ${_minute.toStringAsFixed(0)} mins",
            "companyId": "$companyId",
            "docId": reference.id,
            "checkout": null,
            "month": DateFormat('MMMM yyyy').format(currentTime!),
          }).whenComplete(() {
            if (shiftId != null) {
              Future.delayed(const Duration(milliseconds: 950), () {
                autoCheckout(reference.id);
              });
            }
          });
        }).catchError((e) {});
      }
    });
  }

  //checkout
  checkout() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('CLOCK OUT'),
          content: const Text('Are you sure you want to want to Clock Out?'),
          actions: <Widget>[
            FlatButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            OfflineBuilder(connectivityBuilder: (BuildContext context,
                ConnectivityResult connectivity2, Widget child) {
              if (connectivity2 == conT.ConnectivityResult.none) {
                return FlatButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.white,
                        content: Text("No Internet Connection",
                            style: TextStyle(color: Colors.black)),
                      ),
                    );
                  },
                );
              } else {
                return child;
              }
            }, builder: (BuildContext context) {
              return TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  if (shiftId != null) {
                    String date1 =
                        "${DateFormat("yyyy-MM-dd ").format(checkinTime.toDate())}" +
                            "${DateFormat("HH:mm").format(DateFormat.jm().parse(to))}";
                    var xxx = DateFormat("yyyy-MM-dd HH:mm").parse(date1);

                    int a = xxx.difference(checkinTime.toDate()).inSeconds;
                    int b = DateTime.parse(
                            currentTime!.toString().replaceAll('Z', ''))
                        .difference(checkinTime.toDate())
                        .inSeconds;

                    setState(() {
                      buttonText = "CLOCK IN";
                      hours = 0;
                      minutes = 0;
                      seconds = 0;
                    });
                    if (a < b) {
                      double hoursD = a / 3600;
                      double minutesD = (a % 3600) / 60;
                      double secondsD = (a % 60);
                      FirebaseFirestore.instance
                          .runTransaction((Transaction transaction) async {
                        DocumentReference reference = FirebaseFirestore.instance
                            .collection("attendance")
                            .doc(docId);
                        await reference.update({
                          "checkout": FieldValue.serverTimestamp(),
                          "workHours":
                              "${hoursD.toInt()} : ${minutesD.toInt()} : ${secondsD.toInt()}"
                        });
                      }).catchError((e) {});
                      setState(() {});
                      Navigator.pop(context);
                    } else {
                      FirebaseFirestore.instance
                          .runTransaction((Transaction transaction) async {
                        DocumentReference reference = FirebaseFirestore.instance
                            .collection("attendance")
                            .doc(docId);
                        await reference.update({
                          "checkout": FieldValue.serverTimestamp(),
                          "workHours": "$hours : $minutes : $seconds"
                        });
                      }).catchError((e) {});
                      setState(() {});
                      Navigator.pop(context);
                    }
                  } else {
                    FirebaseFirestore.instance
                        .runTransaction((Transaction transaction) async {
                      DocumentReference reference = FirebaseFirestore.instance
                          .collection("attendance")
                          .doc(docId);
                      await reference.update({
                        "checkout": FieldValue.serverTimestamp(),
                        "workHours": "$hours : $minutes : $seconds"
                      }).whenComplete(() {
                        setState(() {
                          buttonText = "CLOCK IN";
                          hours = 0;
                          minutes = 0;
                          seconds = 0;
                          Navigator.pop(context);
                        });
                      });
                    }).catchError((e) {});
                  }
                },
              );
            })
          ],
        );
      },
    );
  }

  Widget miniCards(image, title) {
    return InkWell(
      onTap: () {
        if (title == "My Team") {
          if (team == 0) {
            Fluttertoast.showToast(msg: "You are not the team lead");
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainCheckInTeam()));
          }
          // FirebaseFirestore.instance
          //     .collection("employees")
          //     .where("companyId", isEqualTo: "uDL9lWvnUqVedAegjdpB")
          //     .get()
          //     .then((value) {
          //   for (int i = 0; i < value.docs.length; i++) {
          //     FirebaseFirestore.instance
          //         .collection("employees")
          //         .doc(value.docs[i].id)
          //         .update({"leaves": FieldValue.delete()});
          //   }
          // });
        } else if (title == "Announcements") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Announcements()));
        } else if (title == "Leaves") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LeaveManagement()));
        }
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: purpleLight.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 3))
                ]),
            child: Container(
              padding: const EdgeInsets.all(12),
              height: 10,
              child: Image.asset(image, height: 10),
            ),
          ),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: greyShade))
        ],
      ),
    );
  }
}

class UpperPortion extends StatelessWidget {
  final data;
  const UpperPortion({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 28),
                          Expanded(
                            flex: 8,
                            child: Container(
                              padding: const EdgeInsets.only(top: 70.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const MyProfileEdit(teamId: "")));
                                },
                                child: Text(
                                  "Hello, $empName",
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Notifications()));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 73.0),
                                child: Image.asset(
                                  'assets/notification_Icon.png',
                                  height: 21,
                                  width: 21,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const MyProfileEdit(teamId: "")));
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 65.0, right: 10),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 20,
                                  child: ClipRRect(
                                    clipBehavior: Clip.antiAlias,
                                    borderRadius: BorderRadius.circular(100),
                                    child: imagePath != null || imagePath != ""
                                        ? CachedNetworkImage(
                                            imageUrl: imagePath,
                                            fit: BoxFit.cover,
                                            height: 40,
                                            width: 40,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              color: Colors.white,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )
                                        : Image.asset(
                                            'assets/placeholder.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                  height: 170,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          tileMode: TileMode.clamp,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [purpleLight, purpleDark])))),
          Positioned(
            top: 140,
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
      ),
    );
  }
}
