// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:connectivity/connectivity.dart' as conT;

import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/UserprofileScreen.dart/my_profile_edit.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

//Manager can approve or reject the applied leaves of the employees

class LeaveApprovalScreen extends StatefulWidget {
  final docId, empId;

  const LeaveApprovalScreen({Key? key, this.docId, this.empId})
      : super(key: key);
  @override
  _LeaveApprovalScreenState createState() => _LeaveApprovalScreenState();
}

class _LeaveApprovalScreenState extends State<LeaveApprovalScreen> {
  conT.Connectivity? connectivity;
  StreamSubscription<conT.ConnectivityResult>? subscription;
  bool isNetwork = true;
  List<int> selectHalfRadioTile = [];
  List<int> selectedRadioTile = [];
  List days = [];
  String? leaveType;
  String empPhoto = "";
  String? employeeName;
  String? employeeDesig;
  String? managerId;
  String? empToken;
  String? fromTo;
  String? reason;
  String? reporting;
  var leaves;
  var dayNo;

  @override
  void initState() {
    super.initState();
    //check internet connection
    connectivity = conT.Connectivity();
    subscription = connectivity!.onConnectivityChanged
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

    loadLeaveInfo();
    loadEmployeeInfo();
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

//loading leave data from that document
  loadLeaveInfo() {
    FirebaseFirestore.instance
        .collection("requests")
        .doc("${widget.docId}")
        .snapshots()
        .listen((onData) {
      if (mounted) {
        setState(() {
          dayNo = onData["days"];
          days = onData["leavesDays"];
          managerId = onData["managerId"];
          leaveType = onData["leaveType"];
          fromTo = onData['from-to-date'];
          reason = onData['reason'];
        });
      }
    });
  }

//loading employee's information
  loadEmployeeInfo() {
    FirebaseFirestore.instance
        .collection("employees")
        .doc("${widget.empId}")
        .snapshots()
        .listen((onData) {
      if (mounted) {
        setState(() {
          empPhoto = onData['imagePath'];
          employeeDesig = onData['designation'];
          employeeName = onData["displayName"];
          empToken = onData["deviceToken"];
          leaves = onData["leaves"];
          reporting = onData['reportingTo'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildMyAppBar(context, 'Leave Approval', false),
      body: employeeName == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MyProfileEdit(teamId: widget.empId)));
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 50,
                              child: ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(100),
                                child: empPhoto != null || empPhoto != ""
                                    ? CachedNetworkImage(
                                        imageUrl: empPhoto,
                                        fit: BoxFit.cover,
                                        height: 70,
                                        width: 70,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          color: Colors.white,
                                        ),
                                        errorWidget: (context, url, error) =>
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
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(employeeName!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(height: 5),
                              Text(employeeDesig!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      color: Colors.black)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 92,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: leaves.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return leaves[index]["active"] == true &&
                                  leaves[index]["status"] == true &&
                                  int.parse(leaves[index]["minExpDays"]) <
                                      (joiningDate == ""
                                          ? 0
                                          : DateTime.now()
                                              .difference(
                                                  DateFormat('dd-MMM-yyyy')
                                                      .parse(joiningDate))
                                              .inDays)
                              ? Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularPercentIndicator(
                                        animationDuration: 1000,
                                        animateFromLastPercent: true,
                                        animation: true,
                                        radius: 50.0,
                                        lineWidth: 3.0,
                                        percent: (leaves[index]!['taken'])
                                                .toDouble() /
                                            leaves[index]!['leaveQuota']
                                                .toDouble(),
                                        center: RichText(
                                          text: TextSpan(
                                            text:
                                                '${leaves[index]!['leaveQuota']}/',
                                            style: const TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 11),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      "${(leaves[index]!['leaveQuota'] - leaves[index]!['taken']).toInt()}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: purpleDark,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        progressColor: purpleDark,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(leaves[index]!["name"].toString(),
                                          style: const TextStyle(fontSize: 13)),
                                    ],
                                  ),
                                )
                              : Container();
                        }),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.6,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 10),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                        color: Colors.white),
                    child: Column(children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                            left: 20, right: 10, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            const Expanded(
                                flex: 3,
                                child: Text(
                                  "Applied for: ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Avenir",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                            Expanded(
                              flex: 7,
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    "$leaveType",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Avenir",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                            left: 20, right: 10, bottom: 10),
                        child: Row(
                          children: [
                            const Expanded(
                                flex: 3,
                                child: Text(
                                  "Applied Dates: ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Avenir",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                            Expanded(
                              flex: 7,
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    "$fromTo",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Avenir",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                            left: 20, right: 10, bottom: 10),
                        child: Row(
                          children: [
                            const Expanded(
                                flex: 3,
                                child: Text(
                                  "Reason: ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Avenir",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                            Expanded(
                              flex: 7,
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    reason == '' ? "N/A" : "$reason",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Avenir",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: InkWell(
                                  child: Container(
                                    height: 40,
                                    margin: const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: purpleDark,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'APPROVE',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button for close dialog!
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: const Text('Approve Leave'),
                                          content: const Text(
                                              'Are you sure you want to approve this Leave Request?'),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: const Text('No'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            OfflineBuilder(
                                                connectivityBuilder: (
                                              BuildContext context,
                                              ConnectivityResult connectivity2,
                                              Widget child,
                                            ) {
                                              if (connectivity2 ==
                                                  ConnectivityResult.none) {
                                                return FlatButton(
                                                  child: const Text('Yes'),
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        content: Text(
                                                            "No Internet Connection",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                return child;
                                              }
                                            }, builder: (BuildContext context) {
                                              return FlatButton(
                                                child: const Text('Yes'),
                                                onPressed: () {
                                                  showLoadingDialog(context);
                                                  FirebaseFirestore.instance
                                                      .runTransaction((Transaction
                                                          transaction) async {
                                                    DocumentReference
                                                        reference =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "employees")
                                                            .doc(
                                                                "${widget.empId}");

                                                    for (int i = 0;
                                                        i < leaves.length;
                                                        i++) {
                                                      if (leaveType ==
                                                          leaves[i]["name"]) {
                                                        reference
                                                            .update({
                                                              "leaves": FieldValue
                                                                  .arrayRemove([
                                                                leaves[i]
                                                              ])
                                                            })
                                                            .whenComplete(() {})
                                                            .catchError((e) {});
                                                        Map<String?, dynamic>
                                                            serializedMessage =
                                                            {
                                                          "active": leaves[i]
                                                              ['active'],
                                                          "docId": leaves[i]
                                                              ['docId'],
                                                          "leaveQuota": leaves[
                                                              i]["leaveQuota"],
                                                          "minExpDays": leaves[
                                                              i]['minExpDays'],
                                                          "status": leaves[i]
                                                              ['status'],
                                                          "sandwich": leaves[i]
                                                              ["sandwich"],
                                                          "minApply": leaves[i]
                                                              ['minApply'],
                                                          "name": leaves[i]
                                                              ["name"],
                                                          "taken": leaves[i]
                                                                  ["taken"] +
                                                              dayNo.toDouble()
                                                        };

                                                        reference
                                                            .update({
                                                              "leaves": FieldValue
                                                                  .arrayUnion([
                                                                serializedMessage
                                                              ])
                                                            })
                                                            .whenComplete(() {})
                                                            .catchError((e) {});
                                                      }
                                                    }
                                                    for (int i = 0;
                                                        i < days.length;
                                                        i++) {
                                                      DocumentReference ref =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "attendance")
                                                              .doc();
                                                      await ref.set({
                                                        "workHours": "-",
                                                        "date": DateFormat(
                                                                'MMMM dd yyyy')
                                                            .format(DateFormat(
                                                                    'dd MMM yyyy')
                                                                .parse(days[i]
                                                                    ['days'])),
                                                        "reportingToId": uid,
                                                        "checkin":
                                                            DateTime.now(),
                                                        "empId": widget.empId,
                                                        "late": "-",
                                                        "companyId":
                                                            "$companyId",
                                                        "docId": ref.id,
                                                        "checkout":
                                                            DateTime.now(),
                                                        "leave": "$leaveType",
                                                        "month": DateFormat(
                                                                'MMMM yyyy')
                                                            .format(DateFormat(
                                                                    'dd MMM yyyy')
                                                                .parse(days[i]
                                                                    ['days']))
                                                      });
                                                    }

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("requests")
                                                        .doc("${widget.docId}")
                                                        .update({
                                                      "leaveStatus": "approved",
                                                      "approvalTime":
                                                          "${DateTime.now()}",
                                                    }).whenComplete(() {
                                                      var note = FirebaseFunctions
                                                          .instance
                                                          .httpsCallable(
                                                              'sendSpecificFcm');
                                                      note.call({
                                                        "fcmToken": "$empToken",
                                                        "employeeId":
                                                            "${widget.empId}",
                                                        "managerId":
                                                            "$managerId",
                                                        "receiverId":
                                                            "${widget.empId}",
                                                        "timeStamp":
                                                            "${DateTime.now()}",
                                                        "docId": reference.id,
                                                        "employeeName": "",
                                                        "days": days,
                                                        "payload": {
                                                          "notification": {
                                                            "title":
                                                                "Leave Approved",
                                                            "body":
                                                                "$empName has approved your leave request",
                                                            "sound": "default",
                                                            "badge": "1",
                                                            "click_action":
                                                                "FLUTTER_NOTIFICATION_CLICK"
                                                          },
                                                          "data": {
                                                            "employeeName":
                                                                "$employeeName",
                                                            "employeeId":
                                                                "${widget.empId}",
                                                            "managerId":
                                                                "$managerId",
                                                            "leaveStatus":
                                                                "approved"
                                                          }
                                                        }
                                                      }).whenComplete(() {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    500), () {
                                                          Navigator.of(context)
                                                              .pushNamedAndRemoveUntil(
                                                                  '/app',
                                                                  (Route<dynamic>
                                                                          route) =>
                                                                      false);
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "You have approved leave request");
                                                        });
                                                      }).catchError(
                                                          (onError) {});
                                                    });
                                                  }).catchError((e) {});
                                                },
                                              );
                                            })
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              //manager rejecting the leave

                              Expanded(
                                flex: 5,
                                child: InkWell(
                                  child: Container(
                                    height: 40,
                                    margin: const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: purpleDark,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'REJECT',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button for close dialog!
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: const Text('Reject Leave'),
                                          content: const Text(
                                              'Are you sure you want to reject this Leave Request?'),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: const Text('No'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            OfflineBuilder(
                                                connectivityBuilder: (
                                              BuildContext context,
                                              ConnectivityResult connectivity2,
                                              Widget child,
                                            ) {
                                              if (connectivity2 ==
                                                  conT.ConnectivityResult
                                                      .none) {
                                                return FlatButton(
                                                  child: const Text('Yes'),
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          content: Text(
                                                              'No Internet Connection',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black))),
                                                    );
                                                  },
                                                );
                                              } else {
                                                return child;
                                              }
                                            }, builder: (BuildContext context) {
                                              return FlatButton(
                                                child: const Text('Yes'),
                                                onPressed: () {
                                                  showLoadingDialog(context);
                                                  FirebaseFirestore.instance
                                                      .runTransaction((Transaction
                                                          transaction) async {
                                                    DocumentReference reference =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "requests")
                                                            .doc(
                                                                "${widget.docId}");
                                                    await reference.update({
                                                      "leaveStatus": "rejected",
                                                      "approvalTime":
                                                          "${DateTime.now()}",
                                                    }).whenComplete(() {
                                                      var note = FirebaseFunctions
                                                          .instance
                                                          .httpsCallable(
                                                              'sendSpecificFcm');
                                                      note.call({
                                                        "fcmToken": "$empToken",
                                                        "employeeId":
                                                            "${widget.empId}",
                                                        "managerId":
                                                            "$managerId",
                                                        "receiverId":
                                                            "${widget.empId}",
                                                        "timeStamp":
                                                            "${DateTime.now()}",
                                                        "docId": reference.id,
                                                        "employeeName": "",
                                                        "days": days,
                                                        "payload": {
                                                          "notification": {
                                                            "title":
                                                                "Leave Rejected",
                                                            "body":
                                                                "$empName has rejected your leave request",
                                                            "sound": "default",
                                                            "badge": "1",
                                                            "click_action":
                                                                "FLUTTER_NOTIFICATION_CLICK"
                                                          },
                                                          "data": {
                                                            "employeeName":
                                                                "$employeeName",
                                                            "employeeId":
                                                                "${widget.empId}",
                                                            "managerId":
                                                                "$managerId",
                                                            "leaveStatus":
                                                                "reject"
                                                          }
                                                        }
                                                      }).whenComplete(() {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    500), () {
                                                          Navigator.of(context)
                                                              .pushNamedAndRemoveUntil(
                                                                  '/app',
                                                                  (Route<dynamic>
                                                                          route) =>
                                                                      false);
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "You have rejected leave request");
                                                        });
                                                      }).catchError(
                                                          (onError) {});
                                                    });
                                                  }).catchError((e) {});
                                                },
                                              );
                                            })
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          )),
                    ]),
                  ),

                  // Container(
                  //   margin: const EdgeInsets.only(left: 10, right: 10),
                  //   child: ListView.builder(
                  //       padding: const EdgeInsets.all(0),
                  //       shrinkWrap: true,
                  //       itemCount: days.length,
                  //       physics: const NeverScrollableScrollPhysics(),
                  //       itemBuilder: (BuildContext context, int index) {
                  //         selectHalfRadioTile.add(-1);
                  //         selectedRadioTile.add(-1);
                  //         return Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: <Widget>[
                  //             Container(
                  //               margin: const EdgeInsets.only(
                  //                   left: 10, right: 10, top: 10, bottom: 10),
                  //               child: Text(
                  //                 days[index]['days'],
                  //               ),
                  //             ),
                  //             Container(
                  //               margin: const EdgeInsets.only(
                  //                   left: 10, right: 10, top: 10, bottom: 10),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.start,
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: <Widget>[
                  //                   Expanded(
                  //                     flex: 9,
                  //                     child:
                  //                         // days[index]['dayType'] == "Full Day"
                  //                         // ? fullTile()
                  //                         // : days[index]['dayType'] == "Half Day"
                  //                         //     ? halfRadioTiles(
                  //                         //         context, days[index]["daytime"])
                  //                         //     : days[index]['dayType'] ==
                  //                         //             "Quarter Day"
                  //                         //         ? quarterRadioTiles(context,
                  //                         //             days[index]["daytime"])
                  //                         //         :
                  //                         SizedBox(
                  //                             width:
                  //                                 MediaQuery.of(context).size.width,
                  //                             child: fullTile()),
                  //                   ),
                  //                   // Expanded(
                  //                   //   flex: 2,
                  //                   //   child: Container(
                  //                   //     alignment: Alignment.centerRight,
                  //                   //     margin:
                  //                   //         EdgeInsets.only(left: 10, right: 10),
                  //                   //     child: Text(
                  //                   //       // days[index]['dayType'] == "Full Day"
                  //                   //       //     ? "1 Day"
                  //                   //       //     : days[index]['dayType'] ==
                  //                   //       //             "Half Day"
                  //                   //       //         ? "0.5 Day"
                  //                   //       //         : days[index]['dayType'] ==
                  //                   //       //                 "Quarter Day"
                  //                   //       //             ? "0.25 Day"
                  //                   //       //             :
                  //                   //       "1 Day",
                  //                   //     ),
                  //                   //   ),
                  //                   // ),
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         );
                  //       }),
                  // ),
                  //manager approving the leave
                ],
              ),
            ),
    );
  }

//for full day  leave
  Widget fullTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 3, right: 3),
          height: 5.0,
          width: 5,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: purpleDark,
              borderRadius: BorderRadius.circular(80.0),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.25,
          height: 5,
          color: purpleDark,
          // margin: EdgeInsets.only(bottom: 15),
        ),
        Container(
          margin: const EdgeInsets.only(left: 3, right: 3),
          height: 5.0,
          width: 5,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: purpleDark,
              borderRadius: BorderRadius.circular(80.0),
            ),
          ),
        ),
      ],
    );
  }

// //for half leave
//   Widget halfRadioTiles(BuildContext context, int index) {
//     selectHalfRadioTile[index] = index;
//     return StatefulBuilder(
//         builder: (BuildContext context, setState) => Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                  Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child:  Container(
//                     decoration:  BoxDecoration(
//                       color: selectHalfRadioTile[index] == 0
//                           ? purpleDark
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 4.1,
//                   height: 5,
//                   color: selectHalfRadioTile[index] == 0
//                       ? purpleDark
//                       : Colors.grey[200],
//                 ),
//                  Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child:  Container(
//                     decoration:  BoxDecoration(
//                       color: selectHalfRadioTile[index] == 0 ||
//                               selectHalfRadioTile[index] == 1
//                           ? purpleDark
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 4.1,
//                   height: 5,
//                   color: selectHalfRadioTile[index] == 1
//                       ? purpleDark
//                       : Colors.grey[200],
//                 ),
//                  Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child:  Container(
//                     decoration:  BoxDecoration(
//                       color: selectHalfRadioTile[index] == 1
//                           ? purpleDark
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//               ],
//             ));
//   }

// //for quarter leave
//   Widget quarterRadioTiles(BuildContext context, int index) {
//     selectedRadioTile[index] = index;
//     return StatefulBuilder(
//         builder: (BuildContext context, setState) => Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                  Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child:  Container(
//                     decoration:  BoxDecoration(
//                       color: selectedRadioTile[index] == 0
//                           ? purpleDark
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 8.8,
//                   height: 5,
//                   color: selectedRadioTile[index] == 0
//                       ? purpleDark
//                       : Colors.grey[200],
//                 ),
//                  Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child:  Container(
//                     decoration:  BoxDecoration(
//                       color: selectedRadioTile[index] == 0 ||
//                               selectedRadioTile[index] == 1
//                           ? purpleDark
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 8.8,
//                   height: 5,
//                   color: selectedRadioTile[index] == 1
//                       ? purpleDark
//                       : Colors.grey[200],
//                 ),
//                  Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child:  Container(
//                     decoration:  BoxDecoration(
//                       color: selectedRadioTile[index] == 1 ||
//                               selectedRadioTile[index] == 2
//                           ? purpleDark
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 8.8,
//                   height: 5,
//                   color: selectedRadioTile[index] == 2
//                       ? purpleDark
//                       : Colors.grey[200],
//                 ),
//                  Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child:  Container(
//                     decoration:  BoxDecoration(
//                       color: selectedRadioTile[index] == 2 ||
//                               selectedRadioTile[index] == 3
//                           ? purpleDark
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 8.8,
//                   height: 5,
//                   color: selectedRadioTile[index] == 3
//                       ? purpleDark
//                       : Colors.grey[200],
//                 ),
//                  Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child:  Container(
//                     decoration:  BoxDecoration(
//                       color: selectedRadioTile[index] == 3
//                           ? purpleDark
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//               ],
//             ));
//   }

//refresh the screen on scrolling down
  Future _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {});
    return null;
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            const LoadingDialog(value: "Loading")));
  }
}
