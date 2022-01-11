// import 'dart:async';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:hr_admin/HR_app/Screens/DashBoard/model.dart';
// import 'package:hr_admin/HR_app/Screens/Notification/screen_notification.dart';
// import 'package:hr_admin/HR_app/constants.dart';
// import 'package:hr_admin/main.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:flushbar/flushbar.dart';

// class DashBoard extends StatefulWidget {
//   @override
//   _DashBoardState createState() => _DashBoardState();
// }

// class _DashBoardState extends State<DashBoard>
//     with SingleTickerProviderStateMixin, WidgetsBindingObserver {
//   AnimationController _controller;

//   Future<void> setupmessaging() async {
//     final fbm = FirebaseMessaging.instance;
//     await fbm.requestPermission();
//     // fbm.onTokenRefresh.listen(
//     //   (event) {
//     //     print(event);
//     //   },
//     // );
//     // final key = await fbm.getToken().then((value) => print(value));
//     fbm.subscribeToTopic('all');
//     FirebaseMessaging.onMessage.listen(
//       (RemoteMessage message) {
//         print(message.notification.title);
//         print(message.notification.body);
//         print('message recieved on foreground');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('from ${message.notification.title}'),
//           ),
//         );
//         if (message.notification.title == "test") {
//           Container(child: Text(message.notification.body));
//         }

//         // Flushbar(
//         //   title: message.notification.title,
//         //   message: message.notification.body,
//         // )..show(context);
//       },
//     );
//     FirebaseMessaging.onMessageOpenedApp.listen(
//       (event) {
//         print(event);
//       },
//     );
//     FirebaseMessaging.onBackgroundMessage((message) => null);
//   }
//   // Animation<Offset> _offsetAnimation;

//   // Card1 model = mycard1[i];
//   int i = 0;
//   var dropdownValue;
//   var size;
//   int totalET = 0;
//   int presentET = 0;
//   int absentET = 0;
//   double x = 0;
//   // @override
//   // .................checking the app state...................
//   // void didChangeAppLifecycleState(AppLifecycleState state) {
//   //   // TODO: implement didChangeAppLifecycleState
//   //   super.didChangeAppLifecycleState(state);
//   //   if(state == AppLifecycleState.paused){
//   //     print("app is in ram but not killed");
//   //   }
//   // }
//   @override
//   void initState() {
//     // TODO: implement initState
//     setupmessaging();
//     print('000000000000000000000000000000000000000');
//     totalEmployeeTimer();
//     presentEmployeeTimer();
//     absentEmployeeTimer();
//     super.initState();
//     // WidgetsBinding.instance.addObserver(this);
//     _controller = AnimationController(
//       duration: Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _controller.forward();
//   }

//   Timer totalEmployeeTimer() {
//     Timer timer;
//     return timer = Timer.periodic(Duration(microseconds: 10), (_) {
//       // print('Percent Update');
//       setState(() {
//         if (totalET >= mycard1[i].totalEmployee) {
//           timer.cancel();
//           // percent=0;
//         } else {
//           totalET += 1;
//         }
//       });
//     });
//   }

//   Timer presentEmployeeTimer() {
//     Timer timer;
//     return timer = Timer.periodic(Duration(microseconds: 10), (_) {
//       // print('Percent Update');
//       setState(() {
//         if (presentET >= mycard1[i].present) {
//           timer.cancel();
//           // percent=0;
//         } else {
//           presentET += 1;
//         }
//       });
//     });
//   }

//   Timer absentEmployeeTimer() {
//     Timer timer;
//     return timer = Timer.periodic(Duration(microseconds: 10), (_) {
//       // print('Percent Update');
//       setState(() {
//         if (absentET >= mycard1[i].absent) {
//           timer.cancel();
//           // percent=0;
//         } else {
//           absentET += 1;
//         }
//       });
//     });
//   }

//   void dispose() {
//     if (totalET == mycard1[i].totalEmployee) _controller.dispose();
//     super.dispose();
//     // WidgetsBinding.instance.removeObserver(this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 40),
//               //----------------App Bar-------------------
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         'Hello,',
//                         style: TextStyle(color: kPrimaryColor, fontSize: 18),
//                       ),
//                       Text(
//                         'User Name',
//                         style: TextStyle(
//                             color: kPrimaryColor,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   IconButton(
//                       icon: Icon(Icons.notifications),
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => Notifications()));
//                       }),
//                 ],
//               ),
//               SizedBox(height: 30),

//               //-----------------------Card1------------------------
//               Material(
//                 elevation: 3,
//                 borderRadius: BorderRadius.circular(10),
//                 color: MyApp.isdarkmode.value == false
//                     ? Color(0xFFF5F4F9)
//                     : Theme.of(context)
//                         .scaffoldBackgroundColor
//                         .withOpacity(0.1),
//                 child: Container(
//                   height: 260,
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.transparent,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 56,
//                         decoration: BoxDecoration(
//                           color: MyApp.isdarkmode.value == false
//                               ? Colors.white
//                               : Theme.of(context).scaffoldBackgroundColor
//                             ..withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Material(
//                               color: Colors.transparent,
//                               child: IconButton(
//                                 onPressed: () {
//                                   if (i > 0) {
//                                     setState(() {
//                                       i--;
//                                       if (x >= 0) {
//                                         x -= x;
//                                         x -= 1;
//                                       }
//                                       _controller.forward(from: x);
//                                     });
//                                     totalET = 0;
//                                     presentET = 0;
//                                     absentET = 0;
//                                     totalEmployeeTimer();
//                                     presentEmployeeTimer();
//                                     absentEmployeeTimer();
//                                   }
//                                 },
//                                 icon: Icon(Icons.arrow_back),
//                               ),
//                             ),
//                             Expanded(
//                               child: Container(
//                                 // color: Colors.blue,
//                                 child: Center(
//                                   child: SlideTransition(
//                                     position: Tween<Offset>(
//                                             begin: Offset(x, 0),
//                                             end: Offset.zero)
//                                         .animate(_controller),
//                                     child: mycard1[i]
//                                             .date
//                                             .isAtSameMomentAs(DateTime.now())
//                                         ? Text(
//                                             'Today ' +
//                                                 DateFormat.yMd()
//                                                     .format(mycard1[i].date)
//                                                     .toString(),
//                                             // style: TextStyle(color: Colors.green),
//                                           )
//                                         : Text(
//                                             DateFormat.yMd()
//                                                 .format(mycard1[i].date)
//                                                 .toString(),
//                                             // style
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Material(
//                               color: Colors.transparent,
//                               child: IconButton(
//                                 onPressed: () {
//                                   if (i < mycard1.length - 1) {
//                                     setState(() {
//                                       i++;
//                                       if (x <= 0) {
//                                         x -= x;
//                                         x += 1;
//                                       }
//                                       _controller.forward(from: 0);
//                                     });
//                                     totalET = 0;
//                                     presentET = 0;
//                                     absentET = 0;
//                                     totalEmployeeTimer();
//                                     presentEmployeeTimer();
//                                     absentEmployeeTimer();
//                                   }
//                                   // if (i < mycard1.length- 1) {

//                                   // }
//                                 },
//                                 icon: Icon(Icons.arrow_forward),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Flexible(
//                             flex: 1,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 //--------------------------------------------------
//                                 //             LiquidLinearProgressIndicator(
//                                 //   value: percent / 100,
//                                 //   valueColor: AlwaysStoppedAnimation(Colors.pink),
//                                 //   backgroundColor: Colors.white,
//                                 //   borderColor: Colors.red,
//                                 //   borderWidth: 0,
//                                 //   borderRadius: 15.0,
//                                 //   direction: Axis.horizontal,
//                                 //   center: Text(
//                                 //     percent.toString(),
//                                 //     style: TextStyle(
//                                 //         fontSize: 12.0,
//                                 //         fontWeight: FontWeight.w600,
//                                 //         color: Colors.black),
//                                 //   ),
//                                 // ),
//                                 //-------------------------------------------
//                                 Text(
//                                   totalET.toString(),
//                                   // mycard1[i].totalEmployee.toString(),
//                                   style: TextStyle(
//                                       fontSize: 36,
//                                       color: Color(0xFF555555),
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 Text(
//                                   'Total Employee',
//                                   style: TextStyle(
//                                       color: Color(0xFF555555),
//                                       fontWeight: FontWeight.w500),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Flexible(
//                             flex: 1,
//                             child: Row(
//                               children: [
//                                 RotatedBox(
//                                   quarterTurns: -1,
//                                   child: LinearPercentIndicator(
//                                     width: 160,
//                                     // width: MediaQuery.of(context).size.width * 0.9,
//                                     lineHeight: 12,
//                                     percent: ((mycard1[i].absent.toDouble() /
//                                             mycard1[i]
//                                                 .totalEmployee
//                                                 .toDouble()))
//                                         .toDouble(),
//                                     backgroundColor:
//                                         Color(0XFF4CD3A3).withOpacity(.8),
//                                     progressColor: kPrimaryColor,
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Column(
//                                   // mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               presentET.toString(),
//                                               style: TextStyle(
//                                                   color: Color(0xFF555555),
//                                                   fontSize: 22),
//                                             ),
//                                             Text(
//                                               'Present',
//                                               style: TextStyle(
//                                                   color: Color(0xFF555555),
//                                                   fontSize: 13),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(width: 5),
//                                         Text(
//                                           (mycard1[i].present /
//                                                       mycard1[i].totalEmployee *
//                                                       100)
//                                                   .toInt()
//                                                   .toString() +
//                                               "%",
//                                           style: TextStyle(
//                                               color: Color(0XFF4CD3A3)),
//                                         )
//                                       ],
//                                     ),
//                                     SizedBox(height: 30),
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               absentET.toString(),
//                                               style: TextStyle(
//                                                   color: Color(0xFF555555),
//                                                   fontSize: 22),
//                                             ),
//                                             Text(
//                                               'Absent',
//                                               style: TextStyle(
//                                                   color: Color(0xFF555555),
//                                                   fontSize: 13),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(width: 5),
//                                         Text(
//                                           (mycard1[i].absent /
//                                                       mycard1[i].totalEmployee *
//                                                       100)
//                                                   .toInt()
//                                                   .toString() +
//                                               "%",
//                                           style: TextStyle(
//                                               color: Color(0XFF4CD3A3)),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               //------------------Card 2-------------------------
//               Material(
//                 elevation: 3,
//                 borderRadius: BorderRadius.circular(10),
//                 color: MyApp.isdarkmode.value == false
//                     ? Color(0xFFF5F4F9)
//                     : Theme.of(context)
//                         .scaffoldBackgroundColor
//                         .withOpacity(0.1),
//                 child: Container(
//                   height: 179,
//                   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                   decoration: BoxDecoration(
//                     // color: Color(0xFFF5F4F9),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '174',
//                                 style: TextStyle(
//                                     fontSize: 36,
//                                     color: Color(0xFF555555),
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 'Total Requests',
//                                 style: TextStyle(
//                                     color: Color(0xFF555555),
//                                     fontWeight: FontWeight.w500),
//                               )
//                             ],
//                           ),
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               primary: kPrimaryColor,
//                               padding: EdgeInsets.symmetric(
//                                 // vertical: 20,
//                                 horizontal: 20,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5)),
//                             ),
//                             child: Text(
//                               'View All',
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 50),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Approved',
//                                   style: TextStyle(
//                                     color: Color(0xFF555555),
//                                   ),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   '698',
//                                   style: TextStyle(
//                                       color: Color(0xFF555555),
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w600),
//                                 )
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Rejected',
//                                   style: TextStyle(
//                                     color: Color(0xFF555555),
//                                   ),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   '252',
//                                   style: TextStyle(
//                                       color: Color(0xFF555555),
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w600),
//                                 )
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Pending',
//                                   style: TextStyle(
//                                     color: Color(0xFF555555),
//                                   ),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   '55',
//                                   style: TextStyle(
//                                       color: Color(0xFF555555),
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w600),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               //---------------------Card 3----------------------------
//               Material(
//                 elevation: 3,
//                 borderRadius: BorderRadius.circular(10),
//                 color: MyApp.isdarkmode.value == false
//                     ? Color(0xFFF5F4F9)
//                     : Theme.of(context)
//                         .scaffoldBackgroundColor
//                         .withOpacity(0.1),
//                 child: Container(
//                   // height: 300,
//                   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                   decoration: BoxDecoration(
//                     // color: Color(0xFFF5F4F9),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Annoucments',
//                             style: TextStyle(
//                                 color: Color(0xFF555555),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               primary: kPrimaryColor,
//                               padding: EdgeInsets.symmetric(
//                                 // vertical: 20,
//                                 horizontal: 20,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5)),
//                             ),
//                             child: Text(
//                               'View All',
//                             ),
//                           ),
//                         ],
//                       ),
//                       ListTile(
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                         minLeadingWidth: 3,
//                         // minVerticalPadding: null,
//                         // tileColor: Colors.black,
//                         leading: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: Color(0xFFAAD6EE)),
//                         ),
//                         title: Text(
//                           'User Name',
//                           style:
//                               TextStyle(fontSize: 12, color: Color(0xFFA1A1A1)),
//                         ),
//                         subtitle: Text(
//                           'Fundamentals of Color UI',
//                           style:
//                               TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)),
//                         ),
//                         trailing: Container(
//                           height: 10,
//                           width: 10,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                       ListTile(
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                         minLeadingWidth: 3,
//                         // minVerticalPadding: null,
//                         // tileColor: Colors.black,
//                         leading: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: Color(0xFFAFE5B1)),
//                         ),
//                         title: Text(
//                           'User Name',
//                           style:
//                               TextStyle(fontSize: 12, color: Color(0xFFA1A1A1)),
//                         ),
//                         subtitle: Text(
//                           'Fundamentals of Color UI',
//                           style:
//                               TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)),
//                         ),
//                         trailing: Container(
//                           height: 10,
//                           width: 10,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                       ListTile(
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                         minLeadingWidth: 3,
//                         // minVerticalPadding: null,
//                         // tileColor: Colors.black,
//                         leading: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: Color(0xFFFEBF90)),
//                         ),
//                         title: Text(
//                           'User Name',
//                           style:
//                               TextStyle(fontSize: 12, color: Color(0xFFA1A1A1)),
//                         ),
//                         subtitle: Text(
//                           'Fundamentals of Color UI',
//                           style:
//                               TextStyle(fontSize: 12, color: Color(0xFF2F2F2F)),
//                         ),
//                         trailing: Container(
//                           height: 10,
//                           width: 10,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               //----------------------Card 4---------------------

//               Material(
//                 elevation: 3,
//                 borderRadius: BorderRadius.circular(10),
//                 color: MyApp.isdarkmode.value == false
//                     ? Color(0xFFF5F4F9)
//                     : Theme.of(context)
//                         .scaffoldBackgroundColor
//                         .withOpacity(0.1),
//                 child: Container(
//                   height: 200,
//                   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                   decoration: BoxDecoration(
//                     // color: Color(0xFFF5F4F9),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Strength',
//                         style: TextStyle(
//                             color: Color(0xFF555555),
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: CircularPercentIndicator(
//                               radius: 130,
//                               lineWidth: 8,
//                               backgroundColor: Colors.grey[200],
//                               percent: 0.80,
//                               progressColor: Color(0xff4880FF),
//                               circularStrokeCap: CircularStrokeCap.round,
//                               animation: true,
//                               center: CircularPercentIndicator(
//                                 radius: 100,
//                                 lineWidth: 8,
//                                 backgroundColor: Colors.grey[200],
//                                 percent: 0.50,
//                                 progressColor:
//                                     Color(0XFF4CD3A3).withOpacity(0.8),
//                                 circularStrokeCap: CircularStrokeCap.round,
//                                 animation: true,
//                                 // center:
//                               ),
//                             ),
//                           ), // Class PieChart
//                           Expanded(
//                             flex: 1,
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.accessibility,
//                                       color: Color(0xff4880FF),
//                                     ),
//                                     Column(
//                                       children: [
//                                         Text(
//                                           'Male',
//                                           style: TextStyle(color: Colors.grey),
//                                         ),
//                                         Text(
//                                           '40 %',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 30),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.pregnant_woman_rounded,
//                                       color: Color(0XFF4CD3A3).withOpacity(0.8),
//                                     ),
//                                     Column(
//                                       children: [
//                                         Text(
//                                           'Female',
//                                           style: TextStyle(color: Colors.grey),
//                                         ),
//                                         Text(
//                                           '60 %',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
// //-----------------Floating action button---------------------
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     // Add your onPressed code here!
//       //   },
//       //   backgroundColor: kPrimaryColor,
//       // ),
//     );
//   }
// }
