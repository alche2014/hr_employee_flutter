// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

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
  String? managerName;
  String? leaveType;
  String managerPhoto = "";
  String? employeeId;
  String? employeeName;
  String? managerId;
  String? empId;
  String? empToken;
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

    setState(() {
      loadLeaveInfo();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
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
      dayNo = onData["days"];
      days = onData["leavesDays"];
      managerId = onData["managerId"];
      employeeId = onData["empId"];
      leaveType = onData["leaveType"];

      setState(() {
        loadManagerInfo(managerId);
      });
      setState(() {
        loadEmployeeInfo(employeeId);
      });
    });
  }

//loading manager's information
  loadManagerInfo(String? managerId) {
    FirebaseFirestore.instance
        .collection("employees")
        .doc("$managerId")
        .snapshots()
        .listen((onData) {
      managerName = onData["displayName"];
      managerPhoto = onData["imagePath"];
    });
  }

//loading employee's information
  loadEmployeeInfo(String? employeeId) {
    FirebaseFirestore.instance
        .collection("employees")
        .doc("$employeeId")
        .snapshots()
        .listen((onData) {
      employeeName = onData["displayName"];
      empId = onData["uid"];
      empToken = onData["deviceToken"];
      leaves = onData["leaves"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: buildMyAppBar(context, 'Leave Approval', false),
        body: Stack(
          children: [
            Container(
              padding: Platform.isIOS
                  ? const EdgeInsets.only(bottom: 50, top: 130)
                  : const EdgeInsets.only(bottom: 15, top: 100),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, top: 2, bottom: 10),
                      child: Text(
                        "$employeeName has applied for $leaveType",
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Avenir",
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(width: 1, color: Colors.grey.shade300),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 25,
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: const Text(
                              "APPROVAL HIERARCHY",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 5, left: 5, right: 5),
                            height: 60.0,
                            width: 60.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 3.0,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(80.0)),
                              ),
                              height: 120.0,
                              width: 120.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(88),
                                child: FadeInImage(
                                  fit: BoxFit.fill,
                                  placeholder: const AssetImage(
                                    "assets/images/profileImg.png",
                                    // height: 30,
                                  ),
                                  image: NetworkImage(managerPhoto.toString()),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 5, left: 15, right: 5, bottom: 5),
                            child: Text(
                              "$managerName",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin:
                          const EdgeInsets.only(left: 15, right: 10, top: 10),
                      child: Text(
                        "Employee: $employeeName",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: "Avenir",
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 15, right: 10, top: 10),
                      child: Text(
                        "Leave Type: $leaveType",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: "Avenir",
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                    Container(
                      margin:
                          const EdgeInsets.only(left: 15, right: 10, top: 20),
                      child: const Text(
                        "Applied Dates: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Avenir",
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: days.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            selectHalfRadioTile.add(-1);
                            selectedRadioTile.add(-1);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  child: Text(
                                    days[index]['days'],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 9,
                                        child:
                                            // days[index]['dayType'] == "Full Day"
                                            // ? fullTile()
                                            // : days[index]['dayType'] == "Half Day"
                                            //     ? halfRadioTiles(
                                            //         context, days[index]["daytime"])
                                            //     : days[index]['dayType'] ==
                                            //             "Quarter Day"
                                            //         ? quarterRadioTiles(context,
                                            //             days[index]["daytime"])
                                            //         :
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: fullTile()),
                                      ),
                                      // Expanded(
                                      //   flex: 2,
                                      //   child: Container(
                                      //     alignment: Alignment.centerRight,
                                      //     margin:
                                      //         EdgeInsets.only(left: 10, right: 10),
                                      //     child: Text(
                                      //       // days[index]['dayType'] == "Full Day"
                                      //       //     ? "1 Day"
                                      //       //     : days[index]['dayType'] ==
                                      //       //             "Half Day"
                                      //       //         ? "0.5 Day"
                                      //       //         : days[index]['dayType'] ==
                                      //       //                 "Quarter Day"
                                      //       //             ? "0.25 Day"
                                      //       //             :
                                      //       "1 Day",
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    //manager approving the leave
                    Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 2.5,
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 3),
                              child: RaisedButton(
                                color: Colors.green[600],
                                child: const Text(
                                  "APPROVE",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Avenir",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
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
                                          OfflineBuilder(connectivityBuilder: (
                                            BuildContext context,
                                            ConnectivityResult connectivity2,
                                            Widget child,
                                          ) {
                                            if (connectivity2 ==
                                                ConnectivityResult.none) {
                                              return FlatButton(
                                                child: const Text('Yes'),
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "No Internet Connection"),
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
                                                  DocumentReference reference =
                                                      FirebaseFirestore.instance
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
                                                                .arrayRemove(
                                                                    [leaves[i]])
                                                          })
                                                          .whenComplete(() {})
                                                          .catchError((e) {});
                                                      Map<String?, dynamic>
                                                          serializedMessage = {
                                                        "active": leaves[i]
                                                            ['active'],
                                                        "docId": leaves[i]
                                                            ['docId'],
                                                        "leaveQuota": leaves[i]
                                                            ["leaveQuota"],
                                                        "minExpDays": leaves[i]
                                                            ['minExpDays'],
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

                                                  await
                                                      // reference

                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "requests")
                                                          .doc(
                                                              "${widget.docId}")
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
                                                      "managerId": "$managerId",
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
                                                              "$managerName has approved your leave request",
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
                                                    }).catchError((onError) {});
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
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 2.5,
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 3),
                              child: RaisedButton(
                                color: purpleDark,
                                child: const Text(
                                  "REJECT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Avenir",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
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
                                          OfflineBuilder(connectivityBuilder: (
                                            BuildContext context,
                                            ConnectivityResult connectivity2,
                                            Widget child,
                                          ) {
                                            if (connectivity2 ==
                                                conT.ConnectivityResult.none) {
                                              return FlatButton(
                                                child: const Text('Yes'),
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'No Internet Connection')),
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
                                                      FirebaseFirestore.instance
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
                                                      "managerId": "$managerId",
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
                                                              "$managerName has rejected your leave request",
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
                                                    }).catchError((onError) {});
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
                  ],
                ),
              ),
            ),
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
