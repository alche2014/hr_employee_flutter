// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';
import 'package:hr_app/colors.dart';
import 'package:hr_app/widgets/ExpansionPanel.dart';
import 'package:intl/intl.dart';

//employee can apply leave
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class AddLeave extends StatefulWidget {
  final leavesData, joiningDate;
  const AddLeave({this.leavesData, this.joiningDate, Key? key})
      : super(key: key);
  @override
  _AddLeaveState createState() => _AddLeaveState();
}

class _AddLeaveState extends State<AddLeave>
    with SingleTickerProviderStateMixin {
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
  bool isNetwork = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String reportingToId = "not assigned";
  bool sandwich = true;
  String? name;
  String? managerToken;
  List leaves = [];
  VoidCallback? _showPersBottomSheetCallBack;
  List<String> _selectedDayType = [];
  List<int> selectHalfRadioTile = [];
  List<int> selectedRadioTile = [];
  List days = [];
  late String userId;
  double total = 0;
  late String leaveReason;
  String? compId;
  String selectleave = "Select Leave";
  int minDays = 0;
  FocusNode _leaveReasonFocus = new FocusNode();
  TextEditingController leaveReasonController = TextEditingController();
  DateTime toDate = DateTime.now();
  DateTime fromDate = DateTime.now();
  int? availableDays;
  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: fromDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != toDate) {
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        toDate = picked;
        // if (selectleave == "Casual Leave" || selectleave == "Casual") {
        //   Navigator.pop(context);
        //   Future.delayed(Duration(milliseconds: 150), () {
        //     _persistentBottomSheet();
        //   });
        // }
      });
    }
  }

  Future _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  User? firebaseUser;
  String? uid;

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
    loadFIrebaseUser();
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

// loading employee data
  loadFIrebaseUser() async {
    firebaseUser = await FirebaseAuth.instance.currentUser!;
    uid = firebaseUser!.uid;
    print("Firebase User Id :: ${firebaseUser!.uid}");

    setState(() {
      FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .snapshots()
          .listen((onValue) {
        setState(() {
          reportingToId =
              onValue["reportingToId"] == "" || onValue["reportingToId"] == null
                  ? "not assigned"
                  : onValue["reportingToId"];
          name = onValue["displayName"];
          leaves = onValue['leaves'];
          compId = onValue['companyId'];
          userId = onValue['uid'];
        });
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          loadManagerToken();
        });
      });
    });
  }

//loading managers token
  loadManagerToken() {
    FirebaseFirestore.instance
        .collection('employees')
        .doc("$reportingToId")
        .snapshots()
        .listen((onValue) {
      setState(() {
        managerToken = onValue["deviceToken"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // backgroundColor: Colors.red,
      content: Container(
        height: 400.0,
        width: 450.0,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Apply Leave',
                      style: TextStyle(
                          color: kPrimaryRed,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close)),
                  ],
                ),
                SizedBox(height: 20),
                Container(child: _buildPanel()),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _selectFromDate(context);
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1)),
                          child: Center(
                            child: Text(
                              DateFormat("dd MMM, yyyy").format(fromDate),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1)),
                          child: Center(
                            child: Text(
                              DateFormat("dd MMM, yyyy").format(toDate),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 4,
                  controller: leaveReasonController,
                  decoration: InputDecoration(
                    hintText: "Reason for Leave",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      validateAndSave();
                    },
                    style: ElevatedButton.styleFrom(
                        //button used in dialog
                        primary: Colors.red[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    child: const Text(
                      'Apply Now',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (reportingToId == "not assigned") {
        Flushbar(
          messageText: const Text(
            "You don't have any team leader to approve your request",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
          isDismissible: true,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: const Color(0xFFBF2B38),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        ).show(context);
      } else if (selectleave == "Select Leave") {
        Flushbar(
          messageText: const Text(
            "Kindly Select Leave Type",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
          isDismissible: true,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: const Color(0xFFBF2B38),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        ).show(context);
      } else if (toDate.difference(fromDate).inDays < 0) {
        Flushbar(
          messageText: const Text(
            "Kindly Select To Date properly",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
          isDismissible: true,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: const Color(0xFFBF2B38),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        ).show(context);
      } else if ((toDate.difference(fromDate).inDays + 2) < minDays) {
        Flushbar(
          messageText: Text(
            "You can minimum apply for $minDays Days",
            style: const TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
          isDismissible: true,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: const Color(0xFFBF2B38),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        ).show(context);
      } else {
        if (sandwich) {
          int daysCount = toDate.difference(fromDate).inDays;
          if (availableDays! <= toDate.difference(fromDate).inDays) {
            Fluttertoast.showToast(
                msg: "you have only $availableDays available Leaves");
          } else {
            for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
              days.add({
                "days":
                    "${DateFormat('dd MMM yyyy').format(fromDate.add(Duration(days: i)))}",
                "dayType": "Full Day",
                "daytime": 0
              });
            }
            print("otherDaysssssssssssss = $days");
            return showDialog(
              context: context,
              barrierDismissible:
                  false, // user must tap button for close dialog!
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text('Apply Leave'),
                  content: const Text(
                      'Are you sure you want to apply for this Leave?'),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('No'),
                      onPressed: () {
                        days.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        showLoadingDialog(context);
                        FirebaseFirestore.instance
                            .runTransaction((Transaction transaction) async {
                          DocumentReference reference =
                              FirebaseFirestore.instance
                                  // .collection("employees")
                                  // .doc("YPxLbSRZ0iMkukUVGlXWH8DZrVZ2")
                                  .collection("requests")
                                  .doc();
                          await reference.set({
                            "docId": reference.id,
                            "leaveType": selectleave,
                            "leavesDays": days,
                            "leaveStatus": "pending",
                            "managerId": "$reportingToId",
                            "empId": userId,
                            "timeStamp": "${DateTime.now()}",
                            "reason": leaveReasonController.text,
                            "compId": compId,
                            "days": daysCount + 1
                          }).then((value) {
                            var note = FirebaseFunctions.instance
                                .httpsCallable('sendSpecificFcm');
                            note.call({
                              "fcmToken": "$managerToken",
                              "employeeId": userId,
                              "managerId": "$reportingToId",
                              "receiverId": "$reportingToId",
                              "timeStamp": "${DateTime.now()}",
                              "docId": "${reference.id}",
                              "employeeName": "$name",
                              "days": days,
                              "payload": {
                                "notification": {
                                  "title": "Leave Request",
                                  "body": "$name has requested for the leave",
                                  "sound": "default",
                                  "badge": "1",
                                  "click_action": "FLUTTER_NOTIFICATION_CLICK"
                                },
                                "data": {
                                  "docId": "${reference.id}",
                                  "employeeId": userId,
                                  "managerId": "$reportingToId",
                                  "title": "Leave Request",
                                  "days": "${daysCount + 1}"
                                }
                              }
                            }).whenComplete(() {
                              Future.delayed(Duration(milliseconds: 500), () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/app', (Route<dynamic> route) => false);
                                Fluttertoast.showToast(
                                    msg:
                                        "You have successfully applied for the leave");
                              });
                            }).catchError((onError) {
                              print("ERROR = $onError");
                            });
                          });
                        }).catchError((e) {
                          print('======Error====$e==== ');
                        });
                      },
                    )
                  ],
                );
              },
            );
          }
        } else {
          // if (availableDays! <= toDate.difference(fromDate).inDays) {
          //   Fluttertoast.showToast(
          //       msg: "you have only $availableDays available Leaves");
          // } else {
          days.clear();
          for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
            if (fromDate.add(Duration(days: i)).weekday != 7 &&
                fromDate.add(Duration(days: i)).weekday != 6) {
              days.add({
                "days":
                    "${DateFormat('dd MMM yyyy').format(fromDate.add(Duration(days: i)))}",
                "dayType": "Full Day",
                "daytime": 0
              });
            }
          }

          if (availableDays! <= days.length) {
            Fluttertoast.showToast(
                msg: "you have only $availableDays available Leaves");
          } else {
            return showDialog(
              context: context,
              barrierDismissible:
                  false, // user must tap button for close dialog!
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text('Apply Leave'),
                  content: const Text(
                      'Are you sure you want to apply for this Leave?'),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('No'),
                      onPressed: () {
                        days.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        showLoadingDialog(context);
                        FirebaseFirestore.instance
                            .runTransaction((Transaction transaction) async {
                          DocumentReference reference = FirebaseFirestore
                              .instance
                              .collection("requests")
                              .doc();
                          await reference.set({
                            "docId": reference.id,
                            "leaveType": selectleave,
                            "leavesDays": days,
                            "leaveStatus": "pending",
                            "managerId": "$reportingToId",
                            "empId": userId,
                            "timeStamp": "${DateTime.now()}",
                            "reason": leaveReasonController.text,
                            "compId": compId,
                            "days": days.length + 1
                          }).then((value) {
                            var note = FirebaseFunctions.instance
                                .httpsCallable('sendSpecificFcm');
                            note.call({
                              "fcmToken": "$managerToken",
                              "employeeId": userId,
                              "managerId": "$reportingToId",
                              "receiverId": "$reportingToId",
                              "timeStamp": "${DateTime.now()}",
                              "docId": "${reference.id}",
                              "employeeName": "$name",
                              "days": days,
                              "payload": {
                                "notification": {
                                  "title": "Leave Request",
                                  "body": "$name has requested for the leave",
                                  "sound": "default",
                                  "badge": "1",
                                  "click_action": "FLUTTER_NOTIFICATION_CLICK"
                                },
                                "data": {
                                  "docId": "${reference.id}",
                                  "employeeId": userId,
                                  "managerId": "$reportingToId",
                                  "title": "Leave Request",
                                  "days": "${days.length + 1}"
                                }
                              }
                            }).whenComplete(() {
                              Future.delayed(Duration(milliseconds: 500), () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/app', (Route<dynamic> route) => false);
                                Fluttertoast.showToast(
                                    msg:
                                        "You have successfully applied for the leave");
                              });
                            }).catchError((onError) {
                              print("ERROR = $onError");
                            });
                          });
                        }).catchError((e) {
                          print('======Error====$e==== ');
                        });
                      },
                    )
                  ],
                );
              },
            );
          }
        }
      }
    } else {
      print('form is invalid');
    }
  }

  String validateleavereason(String? value) {
    return "null";
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingDialog()));
  }

  Widget _buildPanel() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              AppExpansionTile(
                key: expansionTile,
                trailing: Icon(Icons.expand_more),
                title: Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: Text(selectleave,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis),
                ),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: <Widget>[
                  ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: widget.leavesData == null
                          ? 0
                          : widget.leavesData.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return widget.leavesData[index]["status"] == true &&
                                widget.leavesData[index]["active"] == true &&
                                int.parse(leaves[index]["minExpDays"]) <
                                    (widget.joiningDate == ""
                                        ? 0
                                        : DateTime.now()
                                            .difference(
                                                DateFormat('dd-MMM-yyyy')
                                                    .parse(widget.joiningDate))
                                            .inDays)
                            ? ListTile(
                                onTap: () {
                                  setState(() {
                                    selectleave =
                                        widget.leavesData[index]["name"];
                                    sandwich =
                                        widget.leavesData[index]["sandwich"];
                                    minDays = int.parse(
                                        widget.leavesData[index]["minApply"]);
                                    expansionTile.currentState!.collapse();
                                    setState(() {});
                                    // print(
                                    //     "selectleave::::::::::::::::${widget.leavesData[index]["name"]}");
                                    days.clear();
                                    total = 0.0;
                                    _showBottomSheet(index);
                                  });
                                },
                                title: Text(
                                  widget.leavesData[index]["name"],
                                  style: TextStyle(
                                      fontWeight: selectleave ==
                                              widget.leavesData[index]["name"]
                                          ? FontWeight.w700
                                          : FontWeight.w400),
                                ))
                            : Container();
                      }),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  void _persistentBottomSheet(int i) {
    double a = 180.0 + (100.0 * toDate.difference(fromDate).inDays);
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, setState) => Container(
                    margin: EdgeInsets.only(top: 20, bottom: 40),
                    height: a,
                    child: _dropDown(
                        toDate.difference(fromDate).inDays, fromDate, i)));
          },
        );
      },
    );
  }

  _showBottomSheet(int i) {
    availableDays = leaves[i]["leaveQuota"] - leaves[i]["taken"];
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState!
        .showBottomSheet((context) {
          return new Container(
              height: 49.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 8, right: 30),
                        child: Text("Avaialable Leave")),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 8, left: 30),
                        child: Text(
                            '${leaves[i]["leaveQuota"] - leaves[i]["taken"]}')),
                  ),
                ],
              ));
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            // setState(() {
            //   _showPersBottomSheetCallBack = null;
            // });
          }
        });
  }

  Widget _dropDown(int daysCount, DateTime date, int i) {
    return StatefulBuilder(
        builder: (BuildContext context, setState) => SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: daysCount + 1,
                      itemBuilder: (BuildContext ctxt, int index) {
                        _selectedDayType.add("Full Day");
                        selectHalfRadioTile.add(0);
                        selectedRadioTile.add(0);
                        return Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 40),
                                      child: Text(DateFormat('dd MMM yyyy')
                                          .format(fromDate
                                              .add(Duration(days: index)))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 45,
                                      margin:
                                          EdgeInsets.only(right: 30, left: 20),
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 8, top: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFFBF2B38))),
                                      child: new DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            isDense: true,
                                            iconSize: 17,
                                            hint: Container(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: Text(
                                                'Full Day',
                                                style: new TextStyle(
                                                  color: Color(0xFFBF2B38),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            value: _selectedDayType[index]
                                                .toString(),
                                            onChanged: (String? newValue) {
                                              // _refreshIndicatorKey.currentState.show();
                                              setState(() {
                                                _selectedDayType[index] =
                                                    newValue!;
                                              });
                                            },
                                            items: _dropDownItems()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(
                                      top: 20, left: 10, right: 10),
                                  child: _selectedDayType[index] == "Full Day"
                                      ? fullTile()
                                      : _selectedDayType[index] == "Half Day"
                                          ? halfRadioTiles(context, index)
                                          : _selectedDayType[index] ==
                                                  "Quarter Day"
                                              ? quarterRadioTiles(
                                                  context, index)
                                              : fullTile()),
                            ],
                          ),
                        );
                      }),
                  // Container(
                  //   child: RaisedButton(
                  //     child: Text("APPLY"),
                  //     onPressed: () {
                  //       double aa = leaves[i]["days"].toDouble() -
                  //           leaves[i]["taken"].toDouble();
                  //       if (aa < (daysCount + 1).toDouble()) {
                  //         Fluttertoast.showToast(
                  //             msg: "you have only $aa available Leaves");
                  //       } else {
                  //         for (int i = 0; i < daysCount + 1; i++) {
                  //           if (_selectedDayType[i].toString() == "Full Day") {
                  //             total = total + 1.0;
                  //           } else if (_selectedDayType[i].toString() ==
                  //               "Half Day") {
                  //             total = total + 0.5;
                  //           } else if (_selectedDayType[i].toString() ==
                  //               "Quarter Day") {
                  //             total = total + 0.25;
                  //           }
                  //           days.add({
                  //             "days":
                  //                 "${DateFormat('dd MMM yyyy').format(fromDate.add(Duration(days: i)))}",
                  //             "dayType": "${_selectedDayType[i].toString()}",
                  //             "daytime": _selectedDayType[i].toString() ==
                  //                     "Full Day"
                  //                 ? 0
                  //                 : _selectedDayType[i].toString() == "Half Day"
                  //                     ? selectHalfRadioTile[i].toInt()
                  //                     : _selectedDayType[i].toString() ==
                  //                             "Quarter Day"
                  //                         ? selectedRadioTile[i].toInt()
                  //                         : 0
                  //           });
                  //         }

                  //         print(days);
                  //         print("total=$total");
                  //         Navigator.of(context).pop();
                  //       }
                  //     },
                  //   ),
                  // )
                ],
              ),
            ));
  }

  List<DropdownMenuItem<String>> _dropDownItems() {
    List<String> _itemDay = ['Full Day', 'Half Day', 'Quarter Day'];
    return _itemDay
        .map((itemValues) => DropdownMenuItem(
              value: itemValues,
              child: Container(
                padding: EdgeInsets.only(right: 13),
                child: new Text(
                  itemValues,
                  style: new TextStyle(
                    color: Color(0xFFBF2B38),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ))
        .toList();
  }

  Widget fullTile() {
    return Container(
      height: 5,
      color: Color(0xFFBF2B38),
      margin: EdgeInsets.only(bottom: 15),
    );
  }

  Widget halfRadioTiles(BuildContext context, int index) {
    return StatefulBuilder(
        builder: (BuildContext context, setState) => Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 5,
                        color: selectHalfRadioTile[index] == 0
                            ? Color(0xFFBF2B38)
                            : Colors.grey[200],
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: selectHalfRadioTile[index],
                            onChanged: (int? val) {
                              setState(() {
                                selectHalfRadioTile[index] = val!;
                              });
                            },
                            activeColor: Color(0xFFBF2B38),
                            // selected: false,
                          ),
                          Text(
                            "1st",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 5,
                        color: selectHalfRadioTile[index] == 1
                            ? Color(0xFFBF2B38)
                            : Colors.grey[200],
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 1,
                            groupValue: selectHalfRadioTile[index],
                            onChanged: (int? val) {
                              setState(() {
                                setState(() {});
                                selectHalfRadioTile[index] = val!;
                              });
                            },
                            activeColor: Color(0xFFBF2B38),
                            // selected: false,
                          ),
                          Text(
                            "2nd",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  Widget quarterRadioTiles(BuildContext context, int index) {
    return StatefulBuilder(
        builder: (BuildContext context, setState) => Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 5,
                        color: selectedRadioTile[index] == 0
                            ? Color(0xFFBF2B38)
                            : Colors.grey[200],
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: selectedRadioTile[index],
                            onChanged: (int? val) {
                              setState(() {
                                selectedRadioTile[index] = val!;
                              });
                            },
                            activeColor: Color(0xFFBF2B38),
                            // selected: false,
                          ),
                          Text(
                            "1st",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // fit: FlexFit.loose,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 5,
                        color: selectedRadioTile[index] == 1
                            ? Color(0xFFBF2B38)
                            : Colors.grey[200],
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 1,
                            groupValue: selectedRadioTile[index],
                            onChanged: (int? val) {
                              setState(() {
                                selectedRadioTile[index] = val!;
                              });
                              ;
                            },
                            activeColor: Color(0xFFBF2B38),
                            // selected: false,
                          ),
                          Text(
                            "2nd",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // fit: FlexFit.loose,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 5,
                        color: selectedRadioTile[index] == 2
                            ? Color(0xFFBF2B38)
                            : Colors.grey[200],
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 2,
                            groupValue: selectedRadioTile[index],
                            onChanged: (int? val) {
                              setState(() {
                                selectedRadioTile[index] = val!;
                              });
                            },
                            activeColor: Color(0xFFBF2B38),
                            // selected: false,
                          ),
                          Text(
                            "3rd",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // fit: FlexFit.loose,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 5,
                        color: selectedRadioTile[index] == 3
                            ? Color(0xFFBF2B38)
                            : Colors.grey[200],
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 3,
                            groupValue: selectedRadioTile[index],
                            onChanged: (int? val) {
                              setState(() {
                                selectedRadioTile[index] = val!;
                              });
                            },
                            activeColor: Color(0xFFBF2B38),
                          ),
                          Text(
                            "4th",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}
