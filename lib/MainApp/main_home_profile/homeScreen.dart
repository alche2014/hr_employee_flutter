// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
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
import 'package:hr_app/MainApp/HomeScreen.dart';
import 'package:hr_app/MainApp/main_home_profile/announCard.dart';
import 'package:hr_app/MainApp/main_home_profile/leaveCard.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/MainApp/annoucment_screen.dart';
import 'package:hr_app/MainApp/CheckIn/team_check_in.dart';
import 'package:hr_app/MainApp/CheckIn/main_check_in.dart';
import 'package:hr_app/MainApp/LeaveManagement/leave_management.dart';
import 'package:hr_app/MainApp/main_home_profile/apply_leaves.dart';
import 'package:hr_app/MainApp/main_home_profile/leave_approval.dart';
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

class MainHomeProfile extends StatefulWidget {
  const MainHomeProfile({Key? key}) : super(key: key);

  @override
  _MainHomeProfileState createState() => _MainHomeProfileState();
}

class _MainHomeProfileState extends State<MainHomeProfile>
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
  late String buttonText = "CHECK IN";
  late Position _currentPosition;
  double? currentLat;
  // String yourAddress = "Location";
  double? currentLng;
  String? userId;
  String? locationId;
  String? shiftId;
  double? officeLat;
  double? officeLng;
  String? companyId;
  String? location;
  late int hours = 00;
  late int minutes = 00;
  late int seconds = 00;
  late Timestamp checkinTime;
  late String docId;
  // late Timer timer;
  // ScheduleController controllers;
  late String to;
  late String from;
  late String shiftName;
  late String token;
  // String empName = '';
  // String empEmail = '';
  String uid = '';
  int? weekend;
  var weekendDefi;
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
          .doc(userId)
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
          .doc(userId)
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
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    userId = firebaseUser!.uid;
    await FirebaseFirestore.instance
        .collection('attendance')
        .where("empId", isEqualTo: userId)
        .where("checkout", isNull: true)
        .get()
        .then((onValue) {
      if (onValue.docs.isEmpty) {
        setState(() {
          buttonText = "CHECK IN";
        });
      } else if (onValue.docs.length != 0) {
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
          buttonText = "CHECK OUT";
        });
      }
    });
    await FirebaseFirestore.instance
        .collection('employees')
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((onValue) {
      locationId = onValue.data()!["locationId"];
      shiftId = onValue.data()!["shiftId"];
      companyId = onValue.data()!["companyId"];
      reportingTo = onValue.data()!['reportingToId'];
      // imagePath = onValue.data()!['imagePath'];
      // empName = onValue.data()!['displayName'];
      // empEmail = onValue.data()!['email'];
      // leaveData = onValue.data()!['leaves'] ?? [];
      // joiningDate = onValue.data()!['joiningDate'] ?? "";

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 330,
              child: Stack(
                children: [
                  //--------------backimage-----------------//
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/foggy.jpg'),
                      fit: BoxFit.cover,
                    )),
                    child: Container(
                      color: const Color(0xFF242126).withOpacity(0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              radius: 45,
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
                          const SizedBox(height: 10),
                          InkWell(
                              onTap: () {
                                final tz.TZDateTime now =
                                    tz.TZDateTime.now(tz.local);
                                tz.TZDateTime scheduledDate = now.weekday != 2
                                    ? tz.TZDateTime(tz.local, now.year,
                                        now.month, now.day, 06, 27)
                                    : tz.TZDateTime(
                                        tz.local, now.year, now.month);
                                print(scheduledDate.isAfter(now).toString());
                              },
                              child: Text(empName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(height: 5),
                          Text(empEmail.toString(),
                              style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: 260,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: isdarkmode.value == false
                            ? Colors.white
                            : const Color(0xFF1D1D35),
                      ),
                    ),
                  ),

                  //-------------center-card-----------------//
                  Positioned(
                      top: 195,
                      left: 0,
                      right: 0,
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Container(
                                  height: 125,
                                  // margin: EdgeInsets.symmetric(horizontal: 25),
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(
                                            color: purpleDark, width: 3)),
                                    color: isdarkmode.value == false
                                        ? Colors.white
                                        : const Color(0xff34354A),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.location_on,
                                                        size: 20),
                                                    Text(yourAddress,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                buttonText == "CHECK OUT"
                                                    ? lateTime ==
                                                            "0 hrs & 0 mins"
                                                        ? Container()
                                                        : Text("$lateTime late")
                                                    : Container(),
                                                buttonText == "CHECK OUT"
                                                    ? Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        child: Text(
                                                          "$hours : $minutes : $seconds  HRS",
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ))
                                                    : Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 13),
                                                        child: Text(
                                                          "Date: ${DateFormat('MMMM dd').format(DateTime.now())}",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                //----------------------//
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MainCheckIn()));
                                                    },
                                                    child: const Text(
                                                        'View History')),
                                              ],
                                            ),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      height: 100,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: purpleDark,
                                                            width: 3),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: isdarkmode
                                                                    .value ==
                                                                false
                                                            ? Colors.grey[100]
                                                            : const Color(
                                                                0xff34354A),
                                                      ),
                                                      child: OfflineBuilder(
                                                          connectivityBuilder: (
                                                        BuildContext context,
                                                        ConnectivityResult
                                                            connectivity2,
                                                        Widget child,
                                                      ) {
                                                        if (connectivity2 ==
                                                            conT.ConnectivityResult
                                                                .none) {
                                                          return ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  const CircleBorder(),
                                                            ),
                                                            onPressed: () {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  content: Text(
                                                                      "No Internet Connection",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black)),
                                                                ),
                                                              );
                                                            },
                                                            child: Text(
                                                                buttonText,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        8)),
                                                          );
                                                        } else {
                                                          return child;
                                                        }
                                                      }, builder: (BuildContext
                                                              context) {
                                                        return ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                const CircleBorder(),
                                                          ),
                                                          onPressed: () {
                                                            if (buttonText ==
                                                                "CHECK OUT") {
                                                              if (locationId !=
                                                                  null) {
                                                                _getOfficeLocation();
                                                                determinePosition();
                                                                setState(() {
                                                                  Future.delayed(
                                                                      const Duration(
                                                                          milliseconds:
                                                                              150),
                                                                      () {
                                                                    location ==
                                                                            "ON"
                                                                        ? _calculations()
                                                                        : noLocationCheckin();
                                                                  });
                                                                });
                                                              } else {
                                                                noLocationCheckin();
                                                              }
                                                            } else if (shiftId !=
                                                                null) {
                                                              // if (weekend == 1) {
                                                              if (weekendDefi
                                                                      .contains(
                                                                          "${DateFormat('EEE').format(DateTime.now())}${DateFormat("M").format(DateTime.now())}") ||
                                                                  weekendDefi
                                                                      .contains(
                                                                          "${DateFormat('EEE').format(DateTime.now())}0")) {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Today is not a working day");
                                                              } else {
                                                                if (locationId !=
                                                                    null) {
                                                                  _getOfficeLocation();
                                                                  determinePosition();
                                                                  setState(() {
                                                                    Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                150),
                                                                        () {
                                                                      location ==
                                                                              "ON"
                                                                          ? _calculations()
                                                                          : noLocationCheckin();
                                                                    });
                                                                  });
                                                                } else {
                                                                  noLocationCheckin();
                                                                }
                                                              }
                                                            } else {
                                                              if (DateFormat('EEEE').format(
                                                                          DateTime
                                                                              .now()) !=
                                                                      "Saturday" ||
                                                                  DateFormat('EEEE')
                                                                          .format(
                                                                              DateTime.now()) !=
                                                                      "Sunday") {
                                                                if (locationId !=
                                                                    null) {
                                                                  _getOfficeLocation();
                                                                  determinePosition();
                                                                  setState(() {
                                                                    Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                150),
                                                                        () {
                                                                      location ==
                                                                              "ON"
                                                                          ? _calculations()
                                                                          : noLocationCheckin();
                                                                    });
                                                                  });
                                                                } else {
                                                                  noLocationCheckin();
                                                                }
                                                              } else {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Today is not a working day");
                                                              }
                                                            }
                                                          },
                                                          child: Text(
                                                              buttonText,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          8)),
                                                        );
                                                      }))
                                                ])
                                          ]))))))
                ],
              ),
            ),
            const SizedBox(height: 5),
            //--------------------ALL--Widgets------------------//
            headViewList('Announcements', Colors.orange, announData),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: 170,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("announcements")
                      .where("Employees", arrayContains: userId)
                      .orderBy("timeStamp", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.0,
                                  color: isdarkmode.value
                                      ? const Color(0xff34354A)
                                      : Colors.grey,
                                )),
                            child: const Center(
                              child: Text("No Announcement created yet"),
                            )),
                      );
                    } else if (snapshot.hasError) {
                      return const Text("ERROR");
                    } else if (snapshot.hasData) {
                      announData = snapshot.data!.docs.isEmpty;
                      return snapshot.data!.docs.isEmpty
                          ? Container(
                              margin: const EdgeInsets.only(
                                  left: 25, right: 20, bottom: 2),
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 0.0,
                                        color: isdarkmode.value
                                            ? const Color(0xff34354A)
                                            : Colors.grey,
                                      )),
                                  child: const Center(
                                    child: Text("No Announcements created yet"),
                                  )),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(0.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return AnnHomeCard(
                                    snapshot.data!.docs[index]
                                        ['announcementTitle'],
                                    snapshot.data!.docs[index]
                                        ["announcementDes"],
                                    snapshot.data!.docs[index]["timeStamp"]);
                              });
                    } else {
                      return _shimmer();
                    }
                  }),
            ),
            const SizedBox(height: 5),
            //----------------Birthday----------------------//
            // headViewList('Birthday', 'lightgreen'),
            // Container(
            //   height: 120,
            //   child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: birthCardData.length,
            //       itemBuilder: (context, index) => birthCardData[index]),
            // ),
            //----------------------Leave Management---------------------------//
            headViewList(
                'Leaves', Colors.green, leaveData.isEmpty || joiningDate == ""),
            joiningDate == ""
                ? Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 0.0,
                              color: isdarkmode.value
                                  ? const Color(0xff34354A)
                                  : Colors.grey,
                            )),
                        child: const Center(
                          child: Text("No Leaves assigned yet"),
                        )),
                  )
                : leaveData.isEmpty
                    ? Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.0,
                                  color: isdarkmode.value
                                      ? const Color(0xff34354A)
                                      : Colors.grey,
                                )),
                            child: const Center(
                              child: Text("No Leaves assigned yet"),
                            )),
                      )
                    : StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('employees')
                            .doc(userId)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot2) {
                          if (!snapshot2.hasData) {
                            return Container(
                              color: isdarkmode.value
                                  ? const Color(0xff34354A)
                                  : Colors.white,
                              child: const Card(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, top: 20, bottom: 10, right: 10),
                                  child: Text("No Leaves assigned yet"),
                                ),
                              ),
                            );
                          } else if (snapshot2.hasData) {
                            // name = snapshot2.data!["name"];
                            // role = snapshot2.data!['email'];
                            leaveData = snapshot2.data!['leaves'] ?? [];
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.0,
                                        color: isdarkmode.value
                                            ? const Color(0xff34354A)
                                            : Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: ListView.builder(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: leaveData.length,
                                                itemBuilder: (context, index) {
                                                  leaveType.length ==
                                                          leaveData.length
                                                      ? print("")
                                                      : leaveType.add(
                                                          leaveData[index]
                                                              ['name']);

                                                  return leaveData[index]
                                                                  ["active"] ==
                                                              true &&
                                                          leaveData[index]
                                                                  ["status"] ==
                                                              true &&
                                                          int.parse(leaveData[
                                                                      index][
                                                                  "minExpDays"]) <
                                                              (joiningDate == ""
                                                                  ? 0
                                                                  : DateTime.now()
                                                                      .difference(DateFormat(
                                                                              'dd-MMM-yyyy')
                                                                          .parse(
                                                                              joiningDate))
                                                                      .inDays)
                                                      ? LeaveCard(
                                                          data:
                                                              leaveData[index])
                                                      : Container();
                                                }),
                                          ),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AddLeave());
                                              },
                                              child: const Text('Apply Leaves',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          const SizedBox(height: 10),
                                        ]),
                                  ),
                                ));
                          } else if (snapshot2.hasError) {
                            return const Text("Error");
                          } else {
                            return _shimmer();
                          }
                        }),

            //-------------------Team Member----------------------------------//
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("employees")
                    .where("reportingToId", isEqualTo: userId)
                    .where("active", isEqualTo: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshotx) {
                  totalemployee =
                      snapshotx.hasData ? snapshotx.data!.docs.length : 0;
                  if (!snapshotx.hasData) {
                    return const Text("");
                  } else if (snapshotx.hasData) {
                    return snapshotx.data!.docs.isEmpty
                        ? const Text("")
                        : Column(
                            children: [
                              headViewList('Team Members', Colors.blue,
                                  snapshotx.data!.docs.isEmpty),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: SizedBox(
                                    height: 170,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 17, vertical: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 0.0,
                                              color: isdarkmode.value
                                                  ? const Color(0xff34354A)
                                                  : Colors.grey,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          //.....................Text above Linear bar.................................

                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 20),
                                              Text(
                                                "Today's Detail",
                                                style: TextStyle(
                                                    color: Colors.red[800],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 22),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text(
                                                    'Absents',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text('On Time',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text('Late',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection("attendance")
                                                      .where("reportingToId",
                                                          isEqualTo: userId)
                                                      .where("date",
                                                          isEqualTo: DateFormat(
                                                                  'MMMM dd yyyy')
                                                              .format(DateTime
                                                                  .now())
                                                              .toString())
                                                      .snapshots(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              QuerySnapshot>
                                                          snapshots) {
                                                    absent = (snapshotx
                                                            .data!.docs.length -
                                                        snapshots
                                                            .data!.docs.length);
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            snapshots.hasData
                                                                ? absent
                                                                    .toString()
                                                                : "0",
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        StreamBuilder<
                                                                QuerySnapshot>(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "attendance")
                                                                .where(
                                                                    "reportingToId",
                                                                    isEqualTo:
                                                                        userId)
                                                                .where("date",
                                                                    isEqualTo: DateFormat(
                                                                            'MMMM dd yyyy')
                                                                        .format(DateTime
                                                                            .now())
                                                                        .toString())
                                                                .where("late",
                                                                    isEqualTo:
                                                                        "0 hrs & 0 mins")
                                                                .snapshots(),
                                                            builder: (context,
                                                                AsyncSnapshot<
                                                                        QuerySnapshot>
                                                                    onTime) {
                                                              ontime = onTime
                                                                  .data!
                                                                  .docs
                                                                  .length;
                                                              lates = totalemployee -
                                                                  (onTime
                                                                          .data!
                                                                          .docs
                                                                          .length +
                                                                      absent);
                                                              return Text(
                                                                  onTime.hasData
                                                                      ? ontime
                                                                          .toString()
                                                                      : "0",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold));
                                                            }),
                                                        Text(
                                                            snapshots.hasData
                                                                ? lates
                                                                    .toString()
                                                                : "0",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red[800],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    );
                                                  }),
                                              const SizedBox(height: 10),
                                              //----------------------------Bar----------------------------------//

                                              FittedBox(
                                                child: Container(
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: Colors.grey[300],
                                                  ),
                                                  height: 15,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: !snapshotx.hasData
                                                      ? Container()
                                                      : Row(
                                                          children: [
                                                            Container(
                                                              height: 15,
                                                              width: totalemployee ==
                                                                      0
                                                                  ? 0
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      ((absent /
                                                                              totalemployee *
                                                                              100) /
                                                                          100),
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            Container(
                                                              height: 15,
                                                              width: totalemployee ==
                                                                      0
                                                                  ? 0
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      ((ontime /
                                                                              totalemployee *
                                                                              100) /
                                                                          100),
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            Container(
                                                              height: 15,
                                                              width: totalemployee ==
                                                                      0
                                                                  ? 0
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      ((lates /
                                                                              totalemployee *
                                                                              100) /
                                                                          100),
                                                              color: Colors.red,
                                                            )
                                                          ],
                                                        ),
                                                ),
                                              )
                                            ],
                                          )),
                                    )),
                              ),
                            ],
                          );
                  } else if (snapshotx.hasError) {
                    return Text("Error");
                  } else {
                    return _shimmer();
                  }
                }),

            //--------------------------Events-------------------------------//
            // headViewList('Events', 'blue'),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: SizedBox(
            //       height: 210,
            //       child: ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: eventCardData.length,
            //           itemBuilder: (context, index) => eventCardData[index])),
            // ),
            //-----------------------Upcoming Holiday----------------------------------//
            // headViewList('Upcoming Holidays', 'lightblue'),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: Material(
            //     elevation: 3,
            //     borderRadius: BorderRadius.circular(10),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(15),
            //         ),
            //         color: MediaQuery.of(context).platformBrightness ==
            //                 Brightness.light
            //             ? Colors.white
            //             : Color(0xff34354A),
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20),
            //         child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: const [
            //               SizedBox(height: 20),
            //               // SizedBox(
            //               //   height: 240,
            //               //   child: ListView.builder(
            //               //       physics: NeverScrollableScrollPhysics(),
            //               //       itemCount: holidayCardData.length,
            //               //       itemBuilder: (context, index) =>
            //               //           holidayCardData[index]),
            //               // ),
            //             ]),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Padding headViewList(String head, Color icon, show) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        leading: (head == "Announcements")
            ? Image.asset(
                "assets/Announcement.png",
                height: 43,
                width: 43,
              )
            : (head == "Leaves")
                ? Image.asset(
                    "assets/Leave-management.png",
                    height: 43,
                    width: 43,
                  )
                : Image.asset(
                    "assets/Team.png",
                    height: 43,
                    width: 43,
                  ),

        //Icon(Icons.now_widgets, color: icon, size: 30),
        title: Text(head, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: show
            ? Text("")
            : TextButton(
                onPressed: () {
                  if (head == "Team Members") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainCheckInTeam()));
                  } else if (head == "Announcements") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HrDashboard()));
                  } else if (head == "Leaves") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LeaveManagement()));
                  }
                },
                child: const Text('View All',
                    style: TextStyle(color: Color(0xffbf2634)))),
      ),
    );
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
      double disMeters = totalDistance * 1000;

      if (disMeters < 1000) {
        if (buttonText == "CHECK IN") {
          checkin();
        } else if (buttonText == "CHECK OUT") {
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
    if (buttonText == "CHECK IN") {
      checkin();
    } else if (buttonText == "CHECK OUT") {
      checkout();
    }
  }

//checkin
  checkin() {
    setState(() {
      buttonText = "CHECK OUT";
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
        .where("empId", isEqualTo: "$userId")
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
                "empId": "$userId",
                "late":
                    "${_hr.toStringAsFixed(0)} hrs & ${_minute.toStringAsFixed(0)} mins",
                "companyId": "$companyId",
                "docId": reference.id,
                "checkout": null,
                "month": DateFormat('MMMM').format(DateTime.now()),
              });
            })
            .then(
              (onValue) {},
            )
            .catchError((e) {});
      }
    });
  }

  Widget _shimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Column(
          children: [0]
              .map((_) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4.0)),
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 30, left: 30),
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(50.0)),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4.0),
                                color: Colors.white,
                                width: double.infinity,
                                height: 8.0,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )))
              .toList(),
        ),
      ),
    );
  }

//checkout
  checkout() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('CHECK OUT'),
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
                  setState(() {
                    buttonText = "CHECK IN";
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
                  Navigator.pop(context);
                },
              );
            })
          ],
        );
      },
    );
  }
}
