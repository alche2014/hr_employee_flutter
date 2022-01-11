import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';

//Manager can approve or reject the applied leaves of the employees

class LeaveApprovalScreen extends StatefulWidget {
  final docId, empId;

  const LeaveApprovalScreen({Key? key, this.docId, this.empId})
      : super(key: key);
  @override
  _LeaveApprovalScreenState createState() => _LeaveApprovalScreenState();
}

class _LeaveApprovalScreenState extends State<LeaveApprovalScreen> {
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
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
    connectivity = new Connectivity();
    subscription =
        connectivity!.onConnectivityChanged.listen((ConnectivityResult result) {
      print(result.toString());
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

    setState(() {
      loadLeaveInfo();
    });
    Future.delayed(Duration(milliseconds: 500), () {
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
        // .collection("employees")
        // .doc("${widget.empId}")
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

      print("List = $days");
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

      print("managerName = $managerName");
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
      print("leaves=========$leaves");

      print("employeeName = $employeeName");
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFBF2B38),
          title: Text(
            "Leave Approval",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Hind",
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    "DETAILS",
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: "Avenir",
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 2),
                  child: Text(
                    "$employeeName has applied for $leaveType",
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: "Avenir",
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 25,
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "APPROVAL HIERARCHY",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                          height: 60.0,
                          width: 60.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 3.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(80.0)),
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
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    "Employee: $employeeName",
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: "Avenir",
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    "Leave Type: $leaveType",
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: "Avenir",
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  height: 1,
                  color: Colors.grey[300],
                ),

                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    "Date ",
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: "Avenir",
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: days.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        selectHalfRadioTile.add(-1);
                        selectedRadioTile.add(-1);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              child: Text(
                                days[index]['days'],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        Container(
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
                    margin: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2.5,
                          margin: EdgeInsets.only(left: 10, right: 10, top: 3),
                          child: RaisedButton(
                            color: Colors.green[500],
                            child: Text(
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
                                    title: Text('Approve Leave'),
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
                                              Flushbar(
                                                messageText: Text(
                                                  "No Internet Connection",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                duration: Duration(seconds: 3),
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
                                              )..show(context);
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
                                                      .collection("employees")
                                                      .doc("${widget.empId}");

                                              for (int i = 0;
                                                  i < leaves.length;
                                                  i++) {
                                                if (leaveType ==
                                                    leaves[i]["displayName"]) {
                                                  print(
                                                      'leaveType============$leaveType');

                                                  reference.update({
                                                    "leaves":
                                                        FieldValue.arrayRemove(
                                                            [leaves[i]])
                                                  }).whenComplete(() {
                                                    print("DELET SUCCESSFUL");
                                                  })
                                                    ..catchError((e) {
                                                      print(
                                                          '======Error======== ');
                                                    });
                                                  Map<String?, dynamic>
                                                      serializedMessage = {
                                                    "active": leaves[i]
                                                        ['active'],
                                                    "docId": leaves[i]['docId'],
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
                                                    "displayName": leaves[i]
                                                        ["displayName"],
                                                    "taken": leaves[i]
                                                            ["taken"] +
                                                        dayNo.toDouble()
                                                  };

                                                  reference.update({
                                                    "leaves":
                                                        FieldValue.arrayUnion(
                                                            [serializedMessage])
                                                  }).whenComplete(() {
                                                    print("UPDATED SUCCESSFUL");
                                                  })
                                                    ..catchError((e) {
                                                      print(
                                                          '======Error======== ');
                                                    });
                                                }
                                              }

                                              await
                                                  // reference

                                                  FirebaseFirestore.instance
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
                                                  "managerId": "$managerId",
                                                  "receiverId":
                                                      "${widget.empId}",
                                                  "timeStamp":
                                                      "${DateTime.now()}",
                                                  "docId": "${reference.id}",
                                                  "employeeName": "",
                                                  "days": days,
                                                  "payload": {
                                                    "notification": {
                                                      "title": "Leave Approved",
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
                                                      "managerId": "$managerId",
                                                      "leaveStatus": "approved"
                                                    }
                                                  }
                                                }).whenComplete(() {
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 500),
                                                      () {
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
                                                }).catchError((onError) {
                                                  print("ERROR = $onError");
                                                });
                                              });
                                            }).catchError((e) {
                                              print('======Error====$e==== ');
                                            });
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
                          margin: EdgeInsets.only(left: 10, right: 10, top: 3),
                          child: RaisedButton(
                            color: Color(0xFFBF2B38),
                            child: Text(
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
                                    title: Text('Reject Leave'),
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
                                            ConnectivityResult.none) {
                                          return FlatButton(
                                            child: const Text('Yes'),
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
                                                duration: Duration(seconds: 3),
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
                                              )..show(context);
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
                                                      // .collection("employees")
                                                      // .doc("${widget.empId}")
                                                      .collection("requests")
                                                      .doc("${widget.docId}");
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
                                                  "docId": "${reference.id}",
                                                  "employeeName": "",
                                                  "days": days,
                                                  "payload": {
                                                    "notification": {
                                                      "title": "Leave Rejected",
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
                                                      "managerId": "$managerId",
                                                      "leaveStatus": "reject"
                                                    }
                                                  }
                                                }).whenComplete(() {
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 500),
                                                      () {
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
                                                }).catchError((onError) {
                                                  print("ERROR = $onError");
                                                });
                                              });
                                            }).catchError((e) {
                                              print('======Error====$e==== ');
                                            });
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
      ),
    );
  }

//for full day  leave
  Widget fullTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          margin: EdgeInsets.only(left: 3, right: 3),
          height: 5.0,
          width: 5,
          color: Colors.transparent,
          child: new Container(
            decoration: new BoxDecoration(
              color: Color(0xFFBF2B38),
              borderRadius: BorderRadius.circular(80.0),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.25,
          height: 5,
          color: Color(0xFFBF2B38),
          // margin: EdgeInsets.only(bottom: 15),
        ),
        new Container(
          margin: EdgeInsets.only(left: 3, right: 3),
          height: 5.0,
          width: 5,
          color: Colors.transparent,
          child: new Container(
            decoration: new BoxDecoration(
              color: Color(0xFFBF2B38),
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
//                 new Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child: new Container(
//                     decoration: new BoxDecoration(
//                       color: selectHalfRadioTile[index] == 0
//                           ? Color(0xFFBF2B38)
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 4.1,
//                   height: 5,
//                   color: selectHalfRadioTile[index] == 0
//                       ? Color(0xFFBF2B38)
//                       : Colors.grey[200],
//                 ),
//                 new Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child: new Container(
//                     decoration: new BoxDecoration(
//                       color: selectHalfRadioTile[index] == 0 ||
//                               selectHalfRadioTile[index] == 1
//                           ? Color(0xFFBF2B38)
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 4.1,
//                   height: 5,
//                   color: selectHalfRadioTile[index] == 1
//                       ? Color(0xFFBF2B38)
//                       : Colors.grey[200],
//                 ),
//                 new Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child: new Container(
//                     decoration: new BoxDecoration(
//                       color: selectHalfRadioTile[index] == 1
//                           ? Color(0xFFBF2B38)
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
//                 new Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child: new Container(
//                     decoration: new BoxDecoration(
//                       color: selectedRadioTile[index] == 0
//                           ? Color(0xFFBF2B38)
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 8.8,
//                   height: 5,
//                   color: selectedRadioTile[index] == 0
//                       ? Color(0xFFBF2B38)
//                       : Colors.grey[200],
//                 ),
//                 new Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child: new Container(
//                     decoration: new BoxDecoration(
//                       color: selectedRadioTile[index] == 0 ||
//                               selectedRadioTile[index] == 1
//                           ? Color(0xFFBF2B38)
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 8.8,
//                   height: 5,
//                   color: selectedRadioTile[index] == 1
//                       ? Color(0xFFBF2B38)
//                       : Colors.grey[200],
//                 ),
//                 new Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child: new Container(
//                     decoration: new BoxDecoration(
//                       color: selectedRadioTile[index] == 1 ||
//                               selectedRadioTile[index] == 2
//                           ? Color(0xFFBF2B38)
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 8.8,
//                   height: 5,
//                   color: selectedRadioTile[index] == 2
//                       ? Color(0xFFBF2B38)
//                       : Colors.grey[200],
//                 ),
//                 new Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child: new Container(
//                     decoration: new BoxDecoration(
//                       color: selectedRadioTile[index] == 2 ||
//                               selectedRadioTile[index] == 3
//                           ? Color(0xFFBF2B38)
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 8.8,
//                   height: 5,
//                   color: selectedRadioTile[index] == 3
//                       ? Color(0xFFBF2B38)
//                       : Colors.grey[200],
//                 ),
//                 new Container(
//                   margin: EdgeInsets.only(left: 3, right: 3),
//                   height: 5.0,
//                   width: 5,
//                   color: Colors.transparent,
//                   child: new Container(
//                     decoration: new BoxDecoration(
//                       color: selectedRadioTile[index] == 3
//                           ? Color(0xFFBF2B38)
//                           : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(80.0),
//                     ),
//                   ),
//                 ),
//               ],
//             ));
//   }

//refresh the screen on scrolling down
  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(milliseconds: 1000));
    setState(() {});
    return null;
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingDialog()));
  }
}
