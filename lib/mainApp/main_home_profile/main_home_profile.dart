// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_app/Notification/screen_notification.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/annoucment_screen.dart';
import 'package:hr_app/mainApp/check_in_history%20_team/main_check_in.dart';
import 'package:hr_app/mainApp/check_in_history/main_check_in.dart';
import 'package:hr_app/mainApp/leave_management/leave_management.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/Components/model.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/screen_announcement.dart';
import 'package:hr_app/mainApp/main_home_profile/apply_leaves.dart';
import 'package:hr_app/mainApp/main_home_profile/leave_approval.dart';
import 'package:hr_app/mainApp/main_home_profile/utility/cards/announCard.dart';
import 'package:hr_app/mainApp/main_home_profile/utility/cards/leaveCard.dart';
import 'package:hr_app/mainApp/personal_Info/main_personal_info.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import 'package:stop_watch_timer/stop_watch_timer.dart';

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
  String joiningDate = '';
  var ontime = 10;
  var lates = 3;
  var absent = 0;
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  late bool isNetwork = true;

  late AnimationController controller;
  late String buttonText = "CHECK IN";
  late Position _currentPosition;
  double? currentLat;
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
  late Timer timer;
  // ScheduleController controllers;
  late String to;
  late String from;
  late String shiftName;
  late String token;
  String empName = '';
  String empEmail = '';
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
  List leaveData = [];
  List<dynamic> leaveType = [];
  late String reportingTo;
  String imagePath = '';
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
    await fbm.requestPermission();
    // fbm.onTokenRefresh.listen(
    //   (event) {
    //     print(event);
    //   },
    // );
    // final key = await fbm.getToken().then((value) => print(value));
    fbm.subscribeToTopic('all');
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print(message.notification!.title);
        print(message.notification!.body);
        print('message recieved on foreground');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('from ${message.notification!.title}'),
        //   ),
        // );
        // print('Handling a background message ${message.messageId}');
        // print(message.data);
        // print("on message: $message");
        // print(
        //     'onMessage: ${message.data["notification"]["title"]},${message.data["notification"]["body"]}, ${message.data["data"]['title']} , ${message.data["data"]['employeeId']} , ${message.data["data"]['docId']}');
        // _showNotificationWithDefaultSound(
        //     message.data["notification"]["title"],
        //     message.data["notification"]["body"],
        //     "${message.data["data"]['title']},${message.data["data"]['employeeId']},${message.data["data"]['docId']}");
        // print('on resume $message');
        // print('onResume= ${message.data["data"]['days']}');
        // _showNotificationWithDefaultSound(
        //     message.data["notification"]["title"],
        //     message.data["notification"]["body"],
        //     "${message.data["data"]['title']},${message.data["data"]['employeeId']},${message.data["data"]['docId']}");
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
          print("messageeeeeeeeeeeeeeeeeeeeeeeee:${message.data}");
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
        // if (message.notification!.title == "test") {
        //   Text(message.notification!.body.toString());
        // }

        // Flushbar(
        //   title: message.notification.title,
        //   message: message.notification.body,
        // )..show(context);
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        print(event);
        print(event.notification!.body);
      },
    );
    // FirebaseMessaging.onBackgroundMessage((message) => "");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  void initState() {
    super.initState();
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
                // channel.description,
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

        print("on message: $message");
        // print(
        //     'onMessage: ${message.data["notification"]["title"]},${message.data["notification"]["body"]}, ${message.data["data"]['title']} , ${message.data["data"]['employeeId']} , ${message.data["data"]['docId']}');

        // _showNotificationWithDefaultSound(
        //     message.data["notification"]["title"],
        //     message.data["notification"]["body"],
        //     "${message.data["data"]['title']},${message.data["data"]['employeeId']},${message.data["data"]['docId']}");

        // print('on resume $message');
        // print('onResume= ${message.data["data"]['days']}');
        // _showNotificationWithDefaultSound(
        //     message.data["notification"]["title"],
        //     message.data["notification"]["body"],
        //     "${message.data["data"]['title']},${message.data["data"]['employeeId']},${message.data["data"]['docId']}");
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
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      // print(result.toString());
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

    loadFirebaseUser();
    _getCurrentLocation();

    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => loadFirebaseUser());
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 32400),
    );

    //check internet connection
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      // print(result.toString());
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
      print("Token :::::::::::::: $tempToken");
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

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //-----Firebase Cloud listner start function----------//

  void firebaseCloudMessagingListeners() {
    firebaseMessaging.setAutoInitEnabled(true);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print('getInitialMessage data: ${message!.data}');
      // _serialiseAndNavigate(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage data: ${message.data}");
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //     print('onMessageOpenedApp data: ${message.data}');
    //     // _serialiseAndNavigate(message);
    //   });
  }

  // // Show a notification every minute with the first appearance happening a minute after invoking the method
  Future _showNotificationWithDefaultSound(
      String title, String message, String description) async {
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel_id', 'channel_name',
            // 'channel_description',
            importance: Importance.max,
            priority: Priority.high);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails();
    await flutterLocalNotificationsPlugin.show(
      0,
      '$title',
      '$message',
      // '$description',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

// notfication details function
  Future onSelectNotification(payload) async {
    print("Payload $payload");

    List payLoadNew = payload.split(",");
    print(payLoadNew[0]);
    String title = payLoadNew[0];
    String empId = payLoadNew[1];
    String docId = payLoadNew[2];

    // if (title == "Leave Request") {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (BuildContext context) =>
    //               LeaveApprovalScreen(docId: docId, empId: empId)));
    // } else if (title == "Announcement") {
    //   // Navigator.push(
    //   //     context,
    //   //     MaterialPageRoute(
    //   //         builder: (BuildContext context) =>
    //   //             ShowAnnouncementScreen(docId: docId)));
    // }
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
      if (queryParams.length > 0) {
        String? userName = queryParams["username"];
        // verify the username is parsed correctly
        print("My users username is: $userName");
      }
    }
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    print("Linkxxxxxxx :" + deepLink!.path);

    if (deepLink != null) {
      print("Linkxxxxxxx :" + deepLink.path);
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  Future<Stream> load() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    DocumentReference collectionReference = FirebaseFirestore.instance
        .collection('employees')
        .doc(firebaseUser!.uid);

    print("idddddddddddddd" + firebaseUser.uid);
    Stream<DocumentSnapshot> query = collectionReference.snapshots();
    documentReference!.update({"deviceToken": "$token"});
    return query;
  }

//getting current user data
  loadFirebaseUser() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    userId = firebaseUser!.uid;
    // print("Firebase User Id :: ${firebaseUser.uid}");
    FirebaseFirestore.instance
        .collection('attendance')
        .where("empId", isEqualTo: userId)
        .where("checkout", isNull: true)
        .get()
        .then((onValue) {
      if (onValue.docs.isEmpty) {
        setState(() {
          buttonText = "CHECK IN";
        });
      } else if (onValue.docs.length == 1) {
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
    FirebaseFirestore.instance
        .collection('employees')
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((onValue) {
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
    setState(() {
      Future.delayed(Duration(milliseconds: 150), () {
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
      to = onValue.data()!["to"];
      from = onValue.data()!["from"];
      shiftName = onValue.data()!["shiftName"];
      weekendDefi = onValue.data()!["weekendDef"];
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.48,
              child: Stack(
                children: [
                  //--------------backimage-----------------//
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/foggy.jpg'),
                      fit: BoxFit.cover,
                    )),
                    child: Container(
                      transform: Matrix4.translationValues(0, -10, 0),
                      color: Color(0xFF242126).withOpacity(0.5),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  Notifications(uid: userId)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Container(
                                        margin: Platform.isIOS
                                            ? EdgeInsets.only(top: 60)
                                            : EdgeInsets.only(top: 0),
                                        child: Icon(Icons.notifications,
                                            color: isdarkmode.value == false
                                                ? Colors.white
                                                : Colors.grey),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          imagePath != null
                              ? CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  radius: 50,
                                  child: ClipRRect(
                                    clipBehavior: Clip.antiAlias,
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image(
                                      image: imagePath == null ||
                                              imagePath == ''
                                          ? NetworkImage(
                                              'https://via.placeholder.com/150')
                                          : NetworkImage(imagePath),
                                      // FileImage(File(imagePath)),
                                      height: 114,
                                      width: 115,
                                      fit: BoxFit.cover,
                                      //  ),
                                    ),
                                  ))
                              : CircleAvatar(
                                  radius: 50,
                                  child: ClipRRect(
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: BorderRadius.circular(100),
                                      child: image == null
                                          ? Image.asset(
                                              "assets/user_image.png",
                                              height: 114,
                                              width: 115,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(image!)),
                                ),
                          SizedBox(height: 10),
                          Text(empName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text(empEmail.toString(),
                              style: TextStyle(color: Colors.white)),
                          SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ),

                  //--------------mainWhite-Back-of-CenterCard---------------//
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.40,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: isdarkmode.value == false
                            ? Colors.white
                            : Color(0xFF1D1D35),
                      ),
                    ),
                  ),

                  //-------------center-card-----------------//
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.29,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Container(
                          height: 150,
                          // margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: darkRed, width: 3)),
                            color: isdarkmode.value == false
                                ? Colors.white
                                : const Color(0xff34354A),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 5),
                                    const Text('Check In',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5),
                                    buttonText == "CHECK OUT"
                                        ? lateTime == "0 hrs & 0 mins"
                                            ? Container()
                                            : Text("$lateTime late")
                                        : Container(),
                                    buttonText == "CHECK OUT"
                                        ? Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              "$hours : $minutes : $seconds  HRS",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Roboto",
                                                  fontWeight: FontWeight.w600),
                                            ))
                                        : Container(
                                            margin: EdgeInsets.only(top: 13),
                                            child: Text(
                                              "Date: ${DateFormat('MMMM dd').format(DateTime.now())}",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontFamily: "Roboto",
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                    //----------------------//
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainCheckIn(
                                                          uid: userId)));
                                        },
                                        child: Text('View History')),
                                  ],
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: darkRed, width: 3),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: isdarkmode.value == false
                                                ? Colors.grey[100]
                                                : Color(0xff34354A),
                                          ),
                                          child: OfflineBuilder(
                                              connectivityBuilder: (
                                            BuildContext context,
                                            ConnectivityResult connectivity2,
                                            Widget child,
                                          ) {
                                            if (connectivity2 ==
                                                ConnectivityResult.none) {
                                              return RaisedButton(
                                                color: Color(0xFFBF2B38),
                                                onPressed: () {
                                                  Flushbar(
                                                    messageText: Text(
                                                      "No Internet Connection",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    duration:
                                                        Duration(seconds: 3),
                                                    isDismissible: true,
                                                    icon: Image.asset(
                                                      "assets/images/cancel.png",
                                                      scale: 1.4,
                                                      // height: 25,
                                                      // width: 25,
                                                    ),
                                                    backgroundColor:
                                                        Color(0xFFBF2B38),
                                                    margin: EdgeInsets.all(8),
                                                    borderRadius: 8,
                                                  ).show(context);
                                                },
                                                child: Text(
                                                  "$buttonText",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              );
                                            } else {
                                              return child;
                                            }
                                          }, builder: (BuildContext context) {
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                // padding: EdgeInsets.all(14),
                                              ),
                                              onPressed: () {
                                                if (buttonText == "CHECK OUT") {
                                                  if (locationId != null) {
                                                    _getOfficeLocation();
                                                    setState(() {
                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  150), () {
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
                                                        msg:
                                                            "Today is not a working day");
                                                  } else {
                                                    if (locationId != null) {
                                                      _getOfficeLocation();
                                                      setState(() {
                                                        Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    150), () {
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
                                                  if ("${DateFormat('EEEE').format(DateTime.now())}" !=
                                                          "Saturday" ||
                                                      "${DateFormat('EEEE').format(DateTime.now())}" !=
                                                          "Sunday") {
                                                    if (locationId != null) {
                                                      _getOfficeLocation();
                                                      setState(() {
                                                        Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    150), () {
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
                                                        msg:
                                                            "Today is not a working day");
                                                  }
                                                }
                                              },
                                              child: Text("$buttonText",
                                                  style:
                                                      TextStyle(fontSize: 8)),
                                            );
                                          }))
                                    ])
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  //------------------card-end-----------------//
                ],
              ),
            ),
            SizedBox(height: 5),
            //--------------------ALL--Widgets------------------//
            headViewList('Announcements', Colors.orange, announData),
            // AnnHomeCard(: null,),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("announcements")
                    .where("Employees", arrayContains: userId)
                    .orderBy("timeStamp")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 140,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 0.0,
                                color: isdarkmode.value
                                    ? Color(0xff34354A)
                                    : Colors.grey,
                              )),
                          child: Center(
                            child: Text("No Announcement created yet"),
                          )),
                    );
                  } else if (snapshot.hasError) {
                    return Text("ERROR");
                  } else if (snapshot.hasData) {
                    announData = snapshot.data!.docs.isEmpty;
                    return snapshot.data!.docs.isEmpty
                        ? Container(
                            margin: EdgeInsets.only(left: 25, right: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 0.0,
                                      color: isdarkmode.value
                                          ? Color(0xff34354A)
                                          : Colors.grey,
                                    )),
                                child: Center(
                                  child: Text("No Announcements created yet"),
                                )),
                          )
                        : Container(
                            padding: EdgeInsets.only(left: 15, right: 5),
                            height: 180,
                            child: ListView.builder(
                                padding: EdgeInsets.all(0.0),
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return AnnHomeCard(MyAnnouncement(
                                    text1: snapshot.data!.docs[index]
                                        ['announcementTitle'],
                                    text2: snapshot.data!.docs[index]
                                        ["announcementDes"],
                                    date: snapshot.data!.docs[index]
                                        ["timeStamp"],
                                  ));
                                }));
                  } else {
                    return _shimmer();
                  }
                }),
            SizedBox(height: 5),
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
                    margin: EdgeInsets.only(left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 0.0,
                              color: isdarkmode.value
                                  ? Color(0xff34354A)
                                  : Colors.grey,
                            )),
                        child: Center(
                          child: Text("No Leaves assigned yet"),
                        )),
                  )
                : leaveData.isEmpty
                    ? Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.0,
                                  color: isdarkmode.value
                                      ? Color(0xff34354A)
                                      : Colors.grey,
                                )),
                            child: Center(
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
                                  ? Color(0xff34354A)
                                  : Colors.white,
                              child: Card(
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
                                          ? Color(0xff34354A)
                                          : Colors.grey,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: ListView.builder(
                                                padding: EdgeInsets.all(0.0),
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
                                                }
                                                //leaveCardData[index]
                                                ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AddLeave(
                                                          leavesData: leaveData,
                                                          joiningDate:
                                                              joiningDate,
                                                        ));
                                              },
                                              child: const Text('Apply Leaves',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          SizedBox(height: 10),
                                        ]),
                                  ),
                                ));
                          } else if (snapshot2.hasError) {
                            return Text("Error");
                          } else {
                            return _shimmer();
                          }
                        }),

            //-------------------Team Member----------------------------------//
            SizedBox(
              height: 10,
            ),
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
                    return Text("");
                  } else if (snapshotx.hasData) {
                    return snapshotx.data!.docs.isEmpty
                        ? Text("")
                        : Column(
                            children: [
                              headViewList('Team Members', Colors.blue,
                                  snapshotx.data!.docs.isEmpty),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: SizedBox(
                                    height: 200,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 17, vertical: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 0.0,
                                              color: isdarkmode.value
                                                  ? Color(0xff34354A)
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
                                              SizedBox(height: 20),
                                              Text(
                                                "Today's Detail",
                                                style: TextStyle(
                                                    color: Colors.red[800],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 22,
                                              ),
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
                                              SizedBox(
                                                height: 10,
                                              ),
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
                                                            style: TextStyle(
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
                                                                  style: TextStyle(
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
                                              SizedBox(
                                                height: 25,
                                              ),
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

  // StreamBuilder<int> stopwatch() {
  //   return StreamBuilder<int>(
  //                                   stream: _stopWatchTimer.rawTime,
  //                                   initialData: 0,
  //                                   builder: (context, snap) {
  //                                     final value = snap.data;
  //                                     final displayTime =
  //                                         StopWatchTimer.getDisplayTime(
  //                                             value!, milliSecond: false);
  //                                     return Column(
  //                                       children: <Widget>[
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(top: 10),
  //                                           child: Text(
  //                                             displayTime,
  //                                             style: TextStyle(
  //                                                 fontSize: 27,
  //                                                 fontWeight:
  //                                                     FontWeight.bold),
  //                                           ),
  //                                         ),

  //                                       ],
  //                                     );
  //                                   },
  //                                 );
  // }
  //-----------------------UI--ended--------------------------------//

  //-----------------HeadView-Extracted-below----------------------//
  Padding headViewList(String head, Color icon, show) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ListTile(
        leading: (head == "Announcements")
            ? Image.asset(
                "assets/Announcement.png",
                height: 45,
                width: 45,
              )
            : (head == "Leaves")
                ? Image.asset(
                    "assets/Leave-management.png",
                    height: 45,
                    width: 45,
                  )
                : Image.asset(
                    "assets/Team.png",
                    height: 45,
                    width: 45,
                  ),

        //Icon(Icons.now_widgets, color: icon, size: 30),
        title: Text(head, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: show
            ? Text("")
            : TextButton(
                onPressed: () {
                  if (head == "Team Members") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MainCheckInTeam(uid: userId)));
                  } else if (head == "Announcements") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Announcements()));
                  } else if (head == "Leaves") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeaveManagement()));
                  }
                },
                child: Text('View all',
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

//getting current location
  _getCurrentLocation() async {
    // for getting the position
    final Geolocator geolocator = Geolocator();
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low)
        .then((position) {
      _currentPosition = position;
      currentLat = position.latitude;
      currentLng = position.longitude;
      // print("_currentPosition => $position");
      return position;
    });
  }

//geting office location
  _getOfficeLocation() {
    if (locationId != null) {
      FirebaseFirestore.instance
          .collection('locations')
          .doc("$locationId")
          .snapshots()
          .listen((onValue) {
        officeLat = onValue.data()!["lat"];
        officeLng = onValue.data()!["lng"];
        location = onValue.data()!["location"];
        // print("LAT = $officeLat , LNG = $officeLng");
      });
      // } else {
      // return Fluttertoast.showToast(msg: "Kindly set office location first");
    }
  }

//calculate difference between current and office location
  _calculations() {
    if (currentLat == null || currentLng == null) {
      Flushbar(
        messageText: Text(
          "Unable to get current location",
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        duration: Duration(seconds: 3),
        isDismissible: true,
        backgroundColor: Color(0xFFBF2B38),
        margin: EdgeInsets.all(8),
        borderRadius: 8,
      ).show(context);
    } else {
      List<dynamic> data = [
        {"lat": officeLat, "lng": officeLng},
        {"lat": currentLat, "lng": currentLng}
      ];
      double totalDistance = 0;
      totalDistance = calculateDistance(
          data[0]["lat"], data[0]["lng"], data[1]["lat"], data[1]["lng"]);

      // print("totalDistance = $totalDistance");
      double disMeters = totalDistance * 1000;
      // print(disMeters);

      if (disMeters < 50) {
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
      // print(DateFormat("HH:mm").format(date));
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
        // print("id============${onValue.docs[0].id}");
        // "workHours": "$hours : $minutes : $seconds";
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
                "checkin": DateTime.now(),
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
            .catchError((e) {
              // print('======Error====$e==== ');
            });
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
          title: Text('CHECK OUT'),
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
              if (connectivity2 == ConnectivityResult.none) {
                return FlatButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Flushbar(
                      messageText: Text(
                        "No Internet Connection",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      duration: Duration(seconds: 3),
                      isDismissible: true,
                      icon: Image.asset(
                        "assets/images/cancel.png",
                        scale: 1.4,
                        // height: 25,
                        // width: 25,
                      ),
                      backgroundColor: Color(0xFFBF2B38),
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                    ).show(context);
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
                      "checkout": DateTime.now(),
                      "workHours": "$hours : $minutes : $seconds"
                    });
                  }).catchError((e) {
                    // print('======Error====$e==== ');
                  });
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

class CustomTextContainer extends StatelessWidget {
  final String? label;
  final String? value;
  const CustomTextContainer({Key? key, this.label, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black87,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(
                color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
          ),
          Text(
            '$label',
            style: TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}
