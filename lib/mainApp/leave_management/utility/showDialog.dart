// // ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, file_names, prefer_const_constructors, sized_box_for_whitespace, must_be_immutable, duplicate_ignore, prefer_typing_uninitialized_variables

// import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flushbar/flushbar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hr_app/Dailog/loading_dailog.dart';
// import 'package:hr_app/colors.dart';
// import 'package:hr_app/mainApp/leave_management/leave_history/leave_history.dart';
// import 'package:hr_app/mainApp/leave_management/models/list_of_leave.dart';
// import 'package:intl/intl.dart';

// DateTime? _fromDate;
// DateTime? _tillDate;
// String? reportingToId;
// String? name;
// String? managerToken;
// List leaves = [];
// VoidCallback? _showPersBottomSheetCallBack;
// List<String> _selectedDayType = [];
// List<int> selectHalfRadioTile = [];
// List<int> selectedRadioTile = [];
// List days = [];
// double total = 0;
// late String leaveReason;
// String? compId;
// String selectleave = "Select Leave";
// FocusNode _leaveReasonFocus = new FocusNode();
// TextEditingController leaveReasonController = TextEditingController();
// DateTime toDate = DateTime.now();
// DateTime fromDate = DateTime.now();
// double? availableDays;
// User? firebaseUser;
// String? uid;

// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Future<dynamic> applyLeave(BuildContext context, leavetype) {
// // loading employee data

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   return showDialog(
//     //showdialog on Apply now
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => CupertinoAlertDialog(
//       // backgroundColor: Colors.grey[100],
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Apply Leave',
//             style: TextStyle(color: kPrimaryRed),
//           ),
//           IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               icon: Icon(Icons.close)),
//         ],
//       ), //on which popup pops
//       content: SingleChildScrollView(
//         child: Container(
//           width: MediaQuery.of(context).size.width * 1,
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _TypeDropMenu(leaves: leavetype),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Row(children: [
//                   Expanded(
//                     flex: 5,
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: FromDate(),
//                     ),
//                   ),

//                   Container(margin: EdgeInsets.only(left: 2, right: 2)),
//                   // Expanded(
//                   //   flex: 1,
//                   //   child: SizedBox(
//                   //       // width: 1,
//                   //       ),
//                   // ),
//                   SizedBox(
//                     height: 10,
//                   ),

//                   Expanded(
//                     flex: 5,
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: TillDate(),
//                     ),
//                   ),
//                   // Align(
//                   //     alignment: Alignment.centerRight,
//                   //     child: SizedBox(width: 120, child: _FormDropMenu('Form'))),
//                 ]),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 TextField(
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     hintText: '$days',
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(2),
//                       borderSide: const BorderSide(
//                         color: Colors.transparent,
//                       ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(2),
//                       borderSide: BorderSide(
//                         color: Colors.grey.withOpacity(0.2),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 ElevatedButton(
//                     onPressed: () {
//                       validateAndSave(context);
//                       // showDialog(
//                       //   //another pop used to show cleared and exit
//                       //   context: context,
//                       //   barrierDismissible: false,
//                       //   builder: (context) => CupertinoAlertDialog(
//                       //     shape: RoundedRectangleBorder(
//                       //         borderRadius: BorderRadius.circular(30)),
//                       //     title: Row(
//                       //       mainAxisAlignment: MainAxisAlignment.end,
//                       //       children: [
//                       //         IconButton(
//                       //           icon: Icon(Icons.close),
//                       //           onPressed: () {
//                       //             Navigator.of(context).pop();
//                       //           },
//                       //         ),
//                       //       ],
//                       //     ),
//                       //     content: Column(
//                       //       mainAxisSize: MainAxisSize.min,
//                       //       children: [
//                       //         SizedBox(
//                       //             height: 200,
//                       //             child:
//                       //                 Image.asset('assets/custom/truecheck.png')),
//                       //         SizedBox(
//                       //           height: 50,
//                       //         ),
//                       //         Text('You have Applied for your leave'),
//                       //         Text('Waiting for approval'),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // );
//                     },
//                     style: ElevatedButton.styleFrom(
//                         //button used in dialog
//                         primary: Colors.red[800],
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(7))),
//                     child: Text(
//                       'Apply Now',
//                       style: TextStyle(color: Colors.white),
//                     ))
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

// //loading managers token
// loadManagerToken() {
//   FirebaseFirestore.instance
//       .collection('employees')
//       .doc("$reportingToId")
//       .snapshots()
//       .listen((onValue) {
//     // setState(() {
//     managerToken = onValue["deviceToken"];
//     //   });

//     print("managerToken $managerToken");
//     print("reportingToId $reportingToId");
//     print("name $name");
//     print("leaves $leaves");
//   });
// }

// validateAndSave(context) async {
//   firebaseUser = await FirebaseAuth.instance.currentUser!;
//   uid = firebaseUser!.uid;
//   print("Firebase User Id :: ${firebaseUser!.uid}");

//   await FirebaseFirestore.instance
//       .collection('employees')
//       .doc(uid)
//       .snapshots()
//       .listen((onValue) {
//     // setState(() {
//     reportingToId = onValue["reportingToId"];
//     name = onValue["name"];
//     leaves = onValue['leaves'];
//     compId = onValue['compId'];
//     //   });
//   });

//   Future.delayed(const Duration(milliseconds: 500), () {
//     // setState(() {
//     loadManagerToken();
//     // });
//   });

//   final form = _formKey.currentState;
//   if (form!.validate()) {
//     if (selectleave == "Select Leave") {
//       Flushbar(
//         messageText: Text(
//           "Kindly Select Leave Type",
//           style: TextStyle(
//               fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
//         ),
//         duration: Duration(seconds: 3),
//         isDismissible: true,
//         icon: Image.asset(
//           "assets/images/cancel.png",
//           height: 30,
//           width: 30,
//         ),
//         backgroundColor: Color(0xFFBF2B38),
//         margin: EdgeInsets.all(8),
//         borderRadius: 8,
//       ).show(context);
//     } else {
//       // if (selectleave.contains("casual") || selectleave.contains("Casual")) {
//       //   print(selectleave.contains("Casual"));

//       //   print("casualDaysList = $days");

//       //   return showDialog(
//       //     context: context,
//       //     barrierDismissible: false, // user must tap button for close dialog!
//       //     builder: (BuildContext context) {
//       //       return CupertinoAlertDialog(
//       //         title: Text('Apply Leave'),
//       //         content: const Text(
//       //             'Are you sure you want to apply for this Leave?'),
//       //         actions: <Widget>[
//       //           FlatButton(
//       //             child: const Text('No'),
//       //             onPressed: () {
//       //               days.clear();
//       //               Navigator.of(context).pop();
//       //             },
//       //           ),
//       //           FlatButton(
//       //             child: const Text('Yes'),
//       //             onPressed: () {
//       //               showLoadingDialog(context);
//       //               FirebaseFirestore.instance
//       //                   .runTransaction((Transaction transaction) async {
//       //                     DocumentReference reference = FirebaseFirestore
//       //                         .instance
//       //                         .collection("employees")
//       //                         .doc("$uid")
//       //                         .collection("leaves")
//       //                         .doc();
//       //                     await reference.set({
//       //                       "docId": "${reference.id}",
//       //                       "leaveType": "$selectleave",
//       //                       "leavesDays": days,
//       //                       "leaveStatus": "pending",
//       //                       "managerId": "$reportingToId",
//       //                       "empId": "$uid",
//       //                       "reason": leaveReasonController.text,
//       //                       "timeStamp": "${DateTime.now()}",
//       //                       "days": total
//       //                     }).then((value) {
//       //                       var note = FirebaseFunctions.instanceFor(
//       //                               region: "europe-west3")
//       //                           .httpsCallable('sendSpecificFcm');
//       //                       note.call({
//       //                         "fcmToken": "$managerToken",
//       //                         "employeeId": "$uid",
//       //                         "managerId": "$reportingToId",
//       //                         "receiverId": "$reportingToId",
//       //                         "timeStamp": "${DateTime.now()}",
//       //                         "docId": "${reference.id}",
//       //                         "employeeName": "$name",
//       //                         "days": days,
//       //                         "payload": {
//       //                           "notification": {
//       //                             "title": "Leave Request",
//       //                             "body":
//       //                                 "$name has requested for the leave",
//       //                             "sound": "default",
//       //                             "badge": "1",
//       //                             "click_action": "FLUTTER_NOTIFICATION_CLICK"
//       //                           },
//       //                           "data": {
//       //                             "docId": "${reference.id}",
//       //                             "employeeId": "$uid",
//       //                             "managerId": "$reportingToId",
//       //                             "title": "Leave Request",
//       //                             "days": "$total"
//       //                           }
//       //                         }
//       //                       }).whenComplete(() {
//       //                         Future.delayed(Duration(milliseconds: 500), () {
//       //                           Navigator.of(context).pushNamedAndRemoveUntil(
//       //                               '/app', (Route<dynamic> route) => false);
//       //                           Fluttertoast.showToast(
//       //                               msg:
//       //                                   "You have successfully applied for the leave");
//       //                         });
//       //                       }).catchError((onError) {
//       //                         print("ERROR = $onError");
//       //                       });
//       //                     });
//       //                   })
//       //                   .whenComplete(() {})
//       //                   .catchError((e) {
//       //                     print('======Error====$e==== ');
//       //                   });
//       //             },
//       //           )
//       //         ],
//       //       );
//       //     },
//       //   );
//       // } else {
//       print("otherDaysList = $days");
//       int daysCount = toDate.difference(fromDate).inDays;
//       // DateTime date = fromDate;
//       print("daysCount = $daysCount");
//       if (availableDays! <= (toDate.difference(fromDate).inDays).toDouble()) {
//         Fluttertoast.showToast(
//             msg: "you have only $availableDays available Leaves");
//       } else {
//         for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
//           days.add({
//             "days":
//                 "${DateFormat('dd MMM yyyy').format(fromDate.add(Duration(days: i)))}",
//             "dayType": "Full Day",
//             "daytime": 0
//           });
//         }
//         print("otherDaysList = $days");
//         return showDialog(
//           context: context,
//           barrierDismissible: false, // user must tap button for close dialog!
//           builder: (BuildContext context) {
//             return CupertinoAlertDialog(
//               title: Text('Apply Leave'),
//               content:
//                   const Text('Are you sure you want to apply for this Leave?'),
//               actions: <Widget>[
//                 FlatButton(
//                   child: const Text('No'),
//                   onPressed: () {
//                     days.clear();
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 FlatButton(
//                   child: const Text('Yes'),
//                   onPressed: () {
//                     showLoadingDialog(context);
//                     FirebaseFirestore.instance
//                         .runTransaction((Transaction transaction) async {
//                       print("${selectleave}" +
//                           "," +
//                           days.toString() +
//                           "," +
//                           reportingToId.toString() +
//                           "," +
//                           "$uid" +
//                           "${leaveReasonController.text}" +
//                           "," +
//                           "${daysCount + 1}");

//                       //   DocumentReference reference = FirebaseFirestore.instance
//                       //       .collection("employees")
//                       //       .doc("$uid")
//                       //       .collection("leaves")
//                       //       .doc();

//                       //   await reference.set({
//                       //     "docId": reference.id,
//                       //     "leaveType": selectleave,
//                       //     "leavesDays": days,
//                       //     "leaveStatus": "pending",
//                       //     "managerId": "$reportingToId",
//                       //     "empId": "$uid",
//                       //     "timeStamp": "${DateTime.now()}",
//                       //     "reason": leaveReasonController.text,
//                       //     "days": daysCount + 1
//                       //   }).then((value) {
//                       //     var note = FirebaseFunctions.instance
//                       //         .httpsCallable('sendSpecificFcm');
//                       //     note.call({
//                       //       "fcmToken": "$managerToken",
//                       //       "employeeId": "$uid",
//                       //       "managerId": "$reportingToId",
//                       //       "receiverId": "$reportingToId",
//                       //       "timeStamp": "${DateTime.now()}",
//                       //       "docId": "${reference.id}",
//                       //       "employeeName": "$name",
//                       //       "days": days,
//                       //       "payload": {
//                       //         "notification": {
//                       //           "title": "Leave Request",
//                       //           "body":
//                       //               "$name has requested for the leave",
//                       //           "sound": "default",
//                       //           "badge": "1",
//                       //           "click_action": "FLUTTER_NOTIFICATION_CLICK"
//                       //         },
//                       //         "data": {
//                       //           "docId": "${reference.id}",
//                       //           "employeeId": "$uid",
//                       //           "managerId": "$reportingToId",
//                       //           "title": "Leave Request",
//                       //           "days": "${daysCount + 1}"
//                       //         }
//                       //       }
//                       //     }).whenComplete(() {
//                       //       Future.delayed(Duration(milliseconds: 500), () {
//                       //         Navigator.of(context).pushNamedAndRemoveUntil(
//                       //             '/app', (Route<dynamic> route) => false);
//                       //         Fluttertoast.showToast(
//                       //             msg:
//                       //                 "You have successfully applied for the leave");
//                       //       });
//                       //     }).catchError((onError) {
//                       //       print("ERROR = $onError");
//                       //     });
//                       //   });
//                       // }).catchError((e) {
//                       //   print('======Error====$e==== ');
//                     });
//                   },
//                 )
//               ],
//             );
//           },
//         );
//       }
//       // }
//     }
//   } else {
//     print('form is invalid');
//   }
// }

// //===========================================================================//

// class FromDate extends StatefulWidget {
//   FromDate({Key? key}) : super(key: key);

//   @override
//   _FromDateState createState() => _FromDateState();
// }

// class _FromDateState extends State<FromDate> {
//   DateTime toDate = DateTime.now();
//   DateTime fromDate = DateTime.now();
//   double? availableDays;

//   Future _selectFromDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: fromDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != fromDate)
//       setState(() {
//         fromDate = picked;
//         _fromDate = picked;
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 60,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(2),
//           border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               // showDatePicker(
//               //         context: context,
//               //         initialDate: DateTime.now(),
//               //         firstDate: DateTime.now(),
//               //         lastDate: DateTime(2029))
//               //     .then((value) {
//               //   setState(() {
//               //     _fromDate = value;
//               //     print(_fromDate);
//               //   });
//               // });
//               _selectFromDate(context);
//             },
//             child: Text(
//               _fromDate == null
//                   ? 'From Date'
//                   : DateFormat("dd MMM, yyyy").format(_fromDate!),
//               // : '${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}'
//               // .toString(),
//               style: TextStyle(
//                   color: MediaQuery.of(context).platformBrightness ==
//                           Brightness.light
//                       ? Colors.grey
//                       : null),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// //---------------------------------------------------------------//
// class TillDate extends StatefulWidget {
//   const TillDate({Key? key}) : super(key: key);

//   @override
//   _TillDateState createState() => _TillDateState();
// }

// class _TillDateState extends State<TillDate> {
//   DateTime toDate = DateTime.now();
//   DateTime fromDate = DateTime.now();
//   double? availableDays;
//   Future _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: fromDate,
//         firstDate: fromDate,
//         lastDate: DateTime(2101));
//     if (picked != null && picked != toDate)
//       setState(() {
//         toDate = picked;
//         _tillDate = picked;
//         // if (selectleave == "Casual Leave" || selectleave == "Casual") {
//         //   Navigator.pop(context);
//         //   Future.delayed(Duration(milliseconds: 150), () {
//         //     _persistentBottomSheet();
//         //   });
//         // }
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 60,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(2),
//           border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1)),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () {
//               if (_fromDate != null) {
//                 _selectDate(context);
//                 // showDatePicker(
//                 //         context: context,
//                 //         initialDate: DateTime(_fromDate!.year.toInt(),
//                 //             _fromDate!.month.toInt(), _fromDate!.day.toInt()),
//                 //         firstDate: DateTime(_fromDate!.year.toInt(),
//                 //             _fromDate!.month.toInt(), _fromDate!.day.toInt()),
//                 //         lastDate: DateTime(2025))
//                 //     .then((value) {
//                 //   setState(() {
//                 //     _tillDate = value;
//                 //     print(_tillDate);
//                 //  });
//                 //});
//               }
//             },
//             child: Text(
//               _tillDate == null
//                   ? 'Till Date'
//                   : DateFormat("dd MMM, yyyy").format(_tillDate!),

//               // : '${_tillDate!.day}/${_tillDate!.month}/${_tillDate!.year}'
//               // .toString(),
//               style: TextStyle(
//                   color: MediaQuery.of(context).platformBrightness ==
//                           Brightness.light
//                       ? Colors.grey
//                       : null),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void showLoadingDialog(BuildContext context) {
//   // flutter defined function
//   Navigator.of(context).push(PageRouteBuilder(
//       opaque: false,
//       pageBuilder: (BuildContext context, _, __) => LoadingDialog()));
// }

// // ignore: must_be_immutable
// class _TypeDropMenu extends StatefulWidget {
//   final hintTxt;
//   final leaves;
//   const _TypeDropMenu({
//     this.leaves,
//     Key? key,
//     this.hintTxt,
//   }) : super(key: key);
//   @override
//   _TypeDropMenuState createState() => _TypeDropMenuState();
// }

// class _TypeDropMenuState extends State<_TypeDropMenu> {
//   final textFieldColor = Color(0xffFFFFFA);

//   String? dropdownvalue;
//   List items = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     widget.leaves.forEach((doc) {
//       items.add(doc['name'].toString());
//     });
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(2),
//         border: Border.all(
//           color: Colors.grey.withOpacity(0.2),
//         ),
//       ),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton(
//               isExpanded: true,
//               elevation: 0,
//               hint: Text(
//                 'Type',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               value: dropdownvalue,
//               icon: Icon(Icons.keyboard_arrow_down),
//               items: items.map((dynamic items) {
//                 return DropdownMenuItem(value: items, child: Text(items));
//               }).toList(),
//               onChanged: (dynamic newValue) {
//                 setState(() {
//                   dropdownvalue = newValue!;
//                 });
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _FormDropMenu extends StatefulWidget {
//   String hintText;
//   _FormDropMenu(this.hintText, {Key? key}) : super(key: key);

//   @override
//   _FormDropMenuState createState() => _FormDropMenuState();
// }

// class _FormDropMenuState extends State<_FormDropMenu> {
//   String? dropdownvalue;
//   var items = [
//     // 'Gender',
//     'Causal',
//     'Married',
//     'Check up',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(2),
//           border: Border.all(
//             color: Colors.grey.withOpacity(0.2),
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(8),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton(
//                 isExpanded: true,
//                 elevation: 0,
//                 hint: Text(
//                   '${widget.hintText}',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 value: dropdownvalue,
//                 icon: Icon(Icons.keyboard_arrow_down),
//                 items: items.map((String items) {
//                   return DropdownMenuItem(value: items, child: Text(items));
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     dropdownvalue = newValue!;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
