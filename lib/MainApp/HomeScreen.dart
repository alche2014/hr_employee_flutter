// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/main_home_profile/screen_announcement.dart';
import 'package:hr_app/MainApp/screen_notification.dart';
import 'package:hr_app/UserprofileScreen.dart/my_profile_edit.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/annoucment_screen.dart';
import 'package:hr_app/mainApp/CheckIn/team_check_in.dart';
import 'package:hr_app/mainApp/CheckIn/main_check_in.dart';
import 'package:hr_app/mainApp/LeaveManagement/leave_management.dart';
import 'package:hr_app/mainApp/main_home_profile/leave_approval.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:location/location.dart' as loc;
import 'package:connectivity/connectivity.dart' as conT;
import 'package:connectivity_platform_interface/src/enums.dart' as enm;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.description,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? description;
  final String? payload;
}

String? selectedNotificationPayload;

//Global Initialization
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          //  channel.description
        ),
      ));
}

class HrDashboard extends StatefulWidget {
  const HrDashboard({Key? key}) : super(key: key);

  @override
  _HrDashboardState createState() => _HrDashboardState();
}

class _HrDashboardState extends State<HrDashboard>
    with TickerProviderStateMixin {
  ///----------------Notfications End---------------//
  var totalemployee = 13;
  // String joiningDate = '';
  var ontime = 10;
  var lates = 3;
  var absent = 0;
  late conT.Connectivity connectivity;
  late StreamSubscription<conT.ConnectivityResult> subscription;
  late bool isNetwork = true;

  late AnimationController controller;
  late String buttonText = "CLOCK IN";
  late Position _currentPosition;
  double? currentLat;
  // String yourAddress = "Location";
  double? currentLng;
  String? locationId;
  String? shiftId;
  double? officeLat;
  double? officeLng;
  String? location;
  late int hours = 00;
  late int minutes = 00;
  late int seconds = 00;
  late Timestamp checkinTime = Timestamp.fromDate(DateTime.now());
  late String docId;
  // late Timer timer;
  // ScheduleController controllers;
  late String to;
  late String from;
  late String shiftName;
  late String token;
  // String empName = '';
  // String empEmail = '';
  int? weekend;
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
  String? name = '';
  String? role;
  // List leaveData = [];
  List<dynamic> leaveType = [];
  late String reportingTo;
  // String imagePath = '';
  File? image;
  DocumentReference? documentReference;
  bool announData = false;

  firebase() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// Firebase local notification plugin
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future setupmessaging() async {
    final fbm = FirebaseMessaging.instance;
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectedNotificationPayload = payload;
    });
    await fbm.requestPermission();

    fbm.subscribeToTopic('all');
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
// if title is leave request type then screen navigate to Leave approval Screen
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
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(message.notification!.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(message.notification!.body!)],
                  ),
                ),
              );
            });
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {},
    );
    // FirebaseMessaging.onBackgroundMessage((message) => "");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    // foreground message
    // om message app open
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.red,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('from ${message.notification!.title}'),
        //   ),
        // );
        // showDialog(
        //     context: context,
        //     builder: (_) {
        //       return AlertDialog(
        //         title: Text(message.notification!.title!),
        //         content: SingleChildScrollView(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [Text(message.notification!.body!)],
        //           ),
        //         ),
        //       );
        //     });

        // if title is leave request type then screen navigate to Leave approval Screen
        if (message.data["title"] == "Leave Request") {
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
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(message.notification!.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(message.notification!.body!)],
                  ),
                ),
              );
            });
      }
    });
    //Message for Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // to Leave approval Screen
      if (message.data["title"] == "Leave Request") {
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
        if (notification != null && android != null) {
          if (message.notification!.title == "Leave Request") {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text(notification.title!),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(notification.body!)],
                      ),
                    ),
                  );
                });
          }
        }
      }
    });

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
        setState(() {
          isNetwork = true;
        });
      }
    });
    load();
    loadFirebaseUser();
    determinePosition();

    notification8_50();
    notification9_10();
    notification5_50();
    notification6_10();

    // timer = Timer.periodic(
    //     const Duration(seconds: 1), (Timer t) => loadFirebaseUser());
    // controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 32400),
    // );

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

    void _configureDidReceiveLocalNotificationSubject() {
      didReceiveLocalNotificationSubject.stream
          .listen((ReceivedNotification receivedNotification) async {
        await showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: receivedNotification.title != null
                ? Text(receivedNotification.title!)
                : null,
          ),
        );
      });
    }

    void _requestPermissions() {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    super.initState();
    setupmessaging();
    _requestPermissions();

    con = ScrollController();
    con.addListener(() {
      if (con.offset >= con.position.maxScrollExtent &&
          !con.position.outOfRange) {
        setState(() {});
      } else if (con.offset <= con.position.minScrollExtent &&
          !con.position.outOfRange) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    stream = null;
    _configureDidReceiveLocalNotificationSubject();
    firebaseMessaging.getToken().then((tempToken) {
      // loadData(tempToken);

      FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .update({"deviceToken": "$tempToken"});
      setState(() {
        token = tempToken!;
      });
    });

    firebaseCloudMessagingListeners();
  }

  tz.TZDateTime _nextInstanceOf8_50() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year);

    if (now.weekday != 3) {
      scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, 03, 50);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }
    return scheduledDate;
  }

  Future<void> notification8_50() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Check In Reminder!',
        'Don’t Forget to Check In your attendance 9:00 AM',
        _nextInstanceOf8_50(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id', 'Checkin Reminder',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOf9_10() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year);

    if (now.weekday == 3) {
      scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, 04, 10);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }
    return scheduledDate;
  }

  Future<void> notification9_10() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Check In Reminder!',
        'Don’t Forget to Check In your attendance 9:00 AM',
        _nextInstanceOf9_10(),
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

  tz.TZDateTime _nextInstanceOf5_50() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year);

    if (now.weekday == 2 || now.weekday != 3) {
      scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, 12, 50);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }
    return scheduledDate;
  }

  Future<void> notification5_50() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        'Check Out Reminder!',
        'Don’t Forget to Check Out at 6:00 PM',
        _nextInstanceOf5_50(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id', 'Checkin Reminder',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOf6_10() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year);

    if (now.weekday != 2 || now.weekday == 3) {
      scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, 13, 10);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }
    return scheduledDate;
  }

  Future<void> notification6_10() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        3,
        'Check Out Reminder!',
        'Don’t Forget to Check Out 6:00 PM',
        _nextInstanceOf6_10(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id', 'Checkin Reminder',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //-----Firebase Cloud listner start function----------//

  void firebaseCloudMessagingListeners() {
    firebaseMessaging.setAutoInitEnabled(true);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  // Show a notification every minute with the first appearance happening a minute after invoking the method
  // notfication details function
  Future onSelectNotification(payload) async {
    List payLoadNew = payload.split(",");
    String title = payLoadNew[0];
    String empId = payLoadNew[1];
    String docId = payLoadNew[2];
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

  Future<Stream> load() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    DocumentReference collectionReference = FirebaseFirestore.instance
        .collection('employees')
        .doc(firebaseUser!.uid);
    firebaseMessaging.getToken().then((tempToken) {
      // loadData(tempToken);

      FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .update({"deviceToken": "$tempToken"});
      setState(() {
        token = tempToken!;
      });
    });
    Stream<DocumentSnapshot> query = collectionReference.snapshots();
    documentReference!.update({"deviceToken": token});
    return query;
  }

  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

//getting current user data
  loadFirebaseUser() async {
    await FirebaseFirestore.instance
        .collection('attendance')
        .where("empId", isEqualTo: uid)
        .where("date",
            isEqualTo: DateFormat('MMMM dd yyyy').format(DateTime.now()))
        .get()
        .then((onValue) {
      if (onValue.docs.isEmpty) {
        setState(() {
          todaysAttendance = "no";
        });
      } else if (onValue.docs.isNotEmpty) {
        setState(() {
          todayIn = onValue.docs.first.data()["checkin"];
          todayOut = onValue.docs.first.data()["checkout"];
          todayhrs = onValue.docs.first.data()["workHours"];
          todaysAttendance = "yes";
        });
      }
    });
    await FirebaseFirestore.instance
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
        checkinTime = onValue.docs.first.data()["checkin"];
        docId = onValue.docs.first.data()["docId"];
        lateTime = onValue.docs.first.data()["late"];
        DateTime lastTime = DateTime.now();
        String difference =
            "${lastTime.difference(checkinTime.toDate()).inSeconds}";

        int weekendDef = int.parse(difference);

        double hoursD = weekendDef / 3600;
        double minutesD = (weekendDef % 3600) / 60;
        double secondsD = (weekendDef % 60) / 1;
        hours = hoursD.toInt();
        minutes = minutesD.toInt();
        seconds = secondsD.toInt();
        setState(() {
          buttonText = "CLOCK OUT";
        });
      }
    });
    await FirebaseFirestore.instance
        .collection('employees')
        .doc(uid)
        .snapshots()
        .listen((onValue) {
      locationId = onValue.data()!["locationId"];
      shiftId = onValue.data()!["shiftId"];
      reportingTo = onValue.data()!['reportingToId'];

      Future.delayed(const Duration(milliseconds: 150), () {
        if (shiftId != null) {
          _getShiftSchedule();
        }
      });
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
    // timer.cancel();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Column(children: [
            const UpperPortion(),
            Text(
              DateFormat('hh:mm a').format(DateTime.now()),
              style: const TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(
                      fontFamily: "Poppins",
                      color: greyShade,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
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
                          // if (weekend == 1) {
                          if (weekendDefi.contains(
                                  "${DateFormat('EEE').format(DateTime.now())}${DateFormat("M").format(DateTime.now())}") ||
                              weekendDefi.contains(
                                  "${DateFormat('EEE').format(DateTime.now())}0")) {
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
                          if (DateFormat('EEEE').format(DateTime.now()) !=
                                  "Saturday" ||
                              DateFormat('EEEE').format(DateTime.now()) !=
                                  "Sunday") {
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
                          buttonText == "CLOCK OUT"
                              ? DateFormat('K:mm a')
                                  .format(checkinTime.toDate())
                                  .toString()
                              : buttonText == "CLOCK IN"
                                  ? todaysAttendance == "yes"
                                      ? todayIn == null
                                          ? DateFormat('K:mm a')
                                              .format(checkinTime.toDate())
                                              .toString()
                                          : DateFormat('K:mm a')
                                              .format(todayIn.toDate())
                                              .toString()
                                      : "-- : --"
                                  : "-- : --",
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
                                          .format(DateTime.now())
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
                              ? "-- : --"
                              : todaysAttendance == "yes"
                                  ? todayhrs == null
                                      ? "$hours : $minutes"
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
    yourAddress = placemarks.first.street!;

    setState(() {});
  }

// //getting current location
//   _getCurrentLocation() async {
//     // for getting the position
//     final Geolocator geolocator = Geolocator();
//     Position position = await Geolocator.getCurrentPosition(
//             // desiredAccuracy: LocationAccuracy.high
//             )
//         .then((position) {
//       setState(() {});
//       _currentPosition = position;
//       currentLat = position.latitude;
//       currentLng = position.longitude;
//       return position;
//     });
//   }

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
          content: Text("Unable to get current location"),
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
      double disMeters = totalDistance * 1000;

      if (disMeters < 1000) {
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
  checkin() {
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

    DateTime abc = DateTime.now();
    TimeOfDay yourTime = TimeOfDay(hour: a, minute: b);
    TimeOfDay nowTime = TimeOfDay(hour: abc.hour, minute: abc.minute);

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
    FirebaseFirestore.instance
        .collection('attendance')
        .where("empId", isEqualTo: "$uid")
        .where("date",
            isEqualTo: DateFormat('MMMM dd yyyy').format(DateTime.now()))
        .get()
        .then((onValue) {
      if (onValue.docs.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('attendance')
            .doc(onValue.docs[0].id)
            .snapshots()
            .listen((value) {
          setState(() {});
          hours = value.data()!['workHours'].split(":")[0];
          minutes = value.data()!['workHours'].split(":")[1];
          seconds = value.data()!['workHours'].split(":")[2];
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
                "date": DateFormat('MMMM dd yyyy').format(DateTime.now()),
                "reportingToId": reportingTo,
                "checkin": FieldValue.serverTimestamp(),
                "empId": "$uid",
                "late":
                    "${_hr.toStringAsFixed(0)} hrs & ${_minute.toStringAsFixed(0)} mins",
                "companyId": "$companyId",
                "docId": reference.id,
                "checkout": null,
                "month": DateFormat('MMMM yyyy').format(DateTime.now()),
              });
            })
            .then(
              (onValue) {},
            )
            .catchError((e) {});
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
          content: const Text('Are you sure you want to want to checkout?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            OfflineBuilder(connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity2,
              Widget child,
            ) {
              if (connectivity2 == conT.ConnectivityResult.none) {
                return FlatButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("No Internet Connection"),
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
                  setState(() {
                    buttonText = "CLOCK IN";
                  });

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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainCheckInTeam(uid: uid)));
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const MyProfileEdit()));
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
                                        builder: (context) => Notifications(
                                            uid: uid, key: null)));
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const MyProfileEdit()));
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
