// ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';

import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/main.dart';
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
  const AddLeave({Key? key}) : super(key: key);
  @override
  _AddLeaveState createState() => _AddLeaveState();
}

class _AddLeaveState extends State<AddLeave>
    with SingleTickerProviderStateMixin {
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
  bool isNetwork = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<AppExpansionTileState> expansionTile = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool sandwich = true;
  String? managerToken;
  VoidCallback? _showPersBottomSheetCallBack;
  List<String> _selectedDayType = [];
  List<int> selectHalfRadioTile = [];
  List<int> selectedRadioTile = [];
  List days = [];
  double total = 0;
  int pending = 0;
  late String leaveReason;
  String selectleave = "Select Leave";
  int minDays = 0;
  FocusNode _leaveReasonFocus = FocusNode();
  TextEditingController leaveReasonController = TextEditingController();
  DateTime now = DateTime.now();
  DateTime toDate = DateTime.now();
  DateTime fromDate = DateTime.now();
  double? availableDays;
  var weekendDefi;

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2020),
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
        firstDate: DateTime(2020),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    toDate = DateTime(now.year, now.month, now.day, 00, 00);
    fromDate = DateTime(now.year, now.month, now.day, 00, 00);

    //check internet connection
    connectivity = Connectivity();
    subscription =
        connectivity!.onConnectivityChanged.listen((ConnectivityResult result) {
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
    if (shiftId != null) {
      _getShiftSchedule();
    }
    loadMPendingRequests();
    reportingTo == null ? print("not assigned") : loadManagerToken();
  }

  _getShiftSchedule() {
    FirebaseFirestore.instance
        .collection('shiftSchedule')
        .doc(shiftId)
        .snapshots()
        .listen((onValue) {
      setState(() {
        weekendDefi = onValue.data()!["weekendDef"];
      });
    });
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

//loading managers token

  loadMPendingRequests() {
    FirebaseFirestore.instance
        .collection('requests')
        .where("leaveStatus", isEqualTo: "pending")
        .snapshots()
        .listen((onValue) {
      setState(() {
        pending = onValue.docs.length;
      });
    });
  }

  loadManagerToken() {
    FirebaseFirestore.instance
        .collection('employees')
        .doc(reportingTo)
        .snapshots()
        .listen((onValue) {
      setState(() {
        managerToken = onValue["deviceToken"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildMyAppBar(context, 'Apply For Leave', false),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Choose Leave Type',
                  style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                const SizedBox(height: 10),
                Container(child: _buildPanel()),
                const SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Date',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              _selectFromDate(context);
                            },
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.white, width: 0)),
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
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              height: 55,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.white, width: 0)),
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
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  'Reason',
                  style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 4,
                  controller: leaveReasonController,
                  decoration: InputDecoration(
                    hintText: "Reason for Leave",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: const Text('SUBMIT FOR APPROVAL'), //next button
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            primary: purpleDark,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          if (selectleave == "Select Leave") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text("Kindly Select Leave Type",
                                      style: TextStyle(color: Colors.black))),
                            );
                          } else if (pending != 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    "You cannot apply for leave because previous your leave request is already pending",
                                    style: TextStyle(color: Colors.black),
                                  )),
                            );
                          } else {
                            validateAndSave();
                          }
                        }))
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
      if (reportingTo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.white,
            content: Text(
                "You don't have any team leader to approve your request",
                style: TextStyle(color: Colors.black)),
          ),
        );
      } else if (toDate.difference(fromDate).inDays < 0.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.white,
              content: Text("Kindly Select To Date properly",
                  style: TextStyle(color: Colors.black))),
        );
      } else {
        if (sandwich) {
          if ((toDate.difference(fromDate).inDays + 1) < minDays) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "You can minimum apply for $minDays Days",
                ),
              ),
            );
          } else if (availableDays! <= toDate.difference(fromDate).inDays) {
            Fluttertoast.showToast(
                msg: "you have only $availableDays available Leaves");
          } else {
            for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
              days.add({
                "days": DateFormat('dd MMM yyyy')
                    .format(fromDate.add(Duration(days: i)))
                    .toString(),
                "dayType": "Full Day",
                "daytime": 0
              });
            }
            return showDialog(
              context: context,
              barrierDismissible:
                  false, // user must tap button for close dialog!
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: const Text('Apply Leave'),
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
                            "managerId": reportingTo,
                            "empId": uid,
                            "from-to-date":
                                "${DateFormat('dd MMM yyyy').format(fromDate)} - ${DateFormat('dd MMM yyyy').format(toDate)}",
                            "timeStamp": DateTime.now(),
                            "reason": leaveReasonController.text,
                            "compId": companyId,
                            "days": days.length
                          }).then((value) {
                            var note = FirebaseFunctions.instance
                                .httpsCallable('sendSpecificFcm');
                            note.call({
                              "fcmToken": "$managerToken",
                              "employeeId": uid,
                              "managerId": reportingTo,
                              "receiverId": reportingTo,
                              "timeStamp": "${DateTime.now()}",
                              "docId": reference.id,
                              "employeeName": empName,
                              "days": days,
                              "payload": {
                                "notification": {
                                  "title": "Leave Request",
                                  "body":
                                      "$empName has requested for the leave",
                                  "sound": "default",
                                  "badge": "1",
                                  "click_action": "FLUTTER_NOTIFICATION_CLICK"
                                },
                                "data": {
                                  "docId": reference.id,
                                  "employeeId": uid,
                                  "managerId": reportingTo,
                                  "title": "Leave Request",
                                  "days": "${days.length}"
                                }
                              }
                            }).whenComplete(() {
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/app', (Route<dynamic> route) => false);
                                Fluttertoast.showToast(
                                    msg:
                                        "You have successfully applied for the leave");
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12.0)), //this right here
                                          child: SizedBox(
                                            height: 300.0,
                                            width: 300.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Icon(
                                                            Icons.close))),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: Image.asset(
                                                      "assets/leaveApplied.png",
                                                      height: 140),
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10.0)),
                                                Center(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 15,
                                                              top: 15),
                                                      child: const Text(
                                                          'Your leave request has been submitted, waiting for approval',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                              });
                            }).catchError((onError) {});
                          });
                        }).catchError((e) {});
                      },
                    )
                  ],
                );
              },
            );
          }
        } else {
          days.clear();
          for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
            if ((!weekendDefi.contains(
                    "${DateFormat('EEE').format(fromDate.add(Duration(days: i)))}${(fromDate.add(Duration(days: i)).day / 8).toInt() + 1}") &&
                !weekendDefi.contains(
                    "${DateFormat('EEE').format(fromDate.add(Duration(days: i)))}0"))) {
              days.add({
                "days": DateFormat('dd MMM yyyy')
                    .format(fromDate.add(Duration(days: i))),
                "dayType": "Full Day",
                "daytime": 0
              });
            }
          }
          if (days.length + 1 < minDays) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "You can minimum apply for $minDays Days",
                ),
              ),
            );
          } else if (availableDays! < days.length) {
            Fluttertoast.showToast(
                msg: "you have only $availableDays available Leaves");
          } else {
            return showDialog(
              context: context,
              barrierDismissible:
                  false, // user must tap button for close dialog!
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: const Text('Apply Leave'),
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
                            "managerId": reportingTo,
                            "empId": uid,
                            "from-to-date":
                                "${DateFormat('dd MMM yyyy').format(fromDate)} - ${DateFormat('dd MMM yyyy').format(toDate)}",
                            "timeStamp": DateTime.now(),
                            "reason": leaveReasonController.text,
                            "compId": companyId,
                            "days": days.length
                          }).then((value) {
                            var note = FirebaseFunctions.instance
                                .httpsCallable('sendSpecificFcm');
                            note.call({
                              "fcmToken": "$managerToken",
                              "employeeId": uid,
                              "managerId": reportingTo,
                              "receiverId": reportingTo,
                              "timeStamp": "${DateTime.now()}",
                              "docId": reference.id,
                              "employeeName": empName,
                              "days": days,
                              "payload": {
                                "notification": {
                                  "title": "Leave Request",
                                  "body":
                                      "$empName has requested for the leave",
                                  "sound": "default",
                                  "badge": "1",
                                  "click_action": "FLUTTER_NOTIFICATION_CLICK"
                                },
                                "data": {
                                  "docId": reference.id,
                                  "employeeId": uid,
                                  "managerId": reportingTo,
                                  "title": "Leave Request",
                                  "days": "${days.length + 1}"
                                }
                              }
                            }).whenComplete(() {
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/app', (Route<dynamic> route) => false);
                                Fluttertoast.showToast(
                                    msg:
                                        "You have successfully applied for the leave");
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12.0)), //this right here
                                          child: SizedBox(
                                            height: 300.0,
                                            width: 300.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Icon(
                                                            Icons.close))),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: Image.asset(
                                                      "assets/leaveApplied.png",
                                                      height: 140),
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10.0)),
                                                Center(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 15,
                                                              top: 15),
                                                      child: const Text(
                                                          'Your leave request has been submitted, waiting for approval',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                              });
                            }).catchError((onError) {});
                          });
                        }).catchError((e) {});
                      },
                    )
                  ],
                );
              },
            );
          }
        }
      }
    }
  }

  String validateleavereason(String? value) {
    return "null";
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            const LoadingDialog(value: "Loading")));
  }

  Widget _buildPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          AppExpansionTile(
            key: expansionTile,
            trailing: const Icon(
              Icons.expand_more,
            ),
            title: SizedBox(
              width: MediaQuery.of(context).size.width / 1.8,
              child: Text(selectleave,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis),
            ),
            children: <Widget>[
              ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: leaveData == null ? 0 : leaveData.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return leaveData[index]["status"] == true &&
                            leaveData[index]["active"] == true &&
                            int.parse(leaveData[index]["minExpDays"]) <
                                (joiningDate == ""
                                    ? 0
                                    : DateTime.now()
                                        .difference(DateFormat('dd-MMM-yyyy')
                                            .parse(joiningDate))
                                        .inDays)
                        ? ListTile(
                            onTap: () {
                              setState(() {
                                selectleave = leaveData[index]["name"];
                                sandwich = leaveData[index]["sandwich"];
                                minDays =
                                    int.parse(leaveData[index]["minApply"]);
                                expansionTile.currentState!.collapse();
                                setState(() {});
                                days.clear();
                                total = 0.0;
                                availableDays =
                                    leaveData[index]["leaveQuota"].toDouble() -
                                        leaveData[index]["taken"].toDouble();
                              });
                            },
                            title: Text(
                              leaveData[index]["name"],
                              style: TextStyle(
                                  fontWeight:
                                      selectleave == leaveData[index]["name"]
                                          ? FontWeight.w700
                                          : FontWeight.w400),
                            ))
                        : Container();
                  }),
            ],
          )
        ],
      ),
    );
  }

  _showBottomSheet(int i) {
    availableDays = leaveData[i]["leaveQuota"] - leaveData[i]["taken"];
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState!
        .showBottomSheet((context) {
          return SizedBox(
              height: 49.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 8, right: 30),
                        child: const Text("Avaialable Leave")),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 8, left: 30),
                        child: Text(
                            '${leaveData[i]["leaveQuota"] - leaveData[i]["taken"]}')),
                  ),
                ],
              ));
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = null;
            });
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: daysCount + 1,
                      itemBuilder: (BuildContext ctxt, int index) {
                        _selectedDayType.add("Full Day");
                        selectHalfRadioTile.add(0);
                        selectedRadioTile.add(0);
                        return Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 40),
                                    child: Text(DateFormat('dd MMM yyyy')
                                        .format(fromDate
                                            .add(Duration(days: index)))),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    margin: const EdgeInsets.only(
                                        right: 30, left: 20),
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 8, top: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: purpleDark)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          isDense: true,
                                          iconSize: 17,
                                          hint: Container(
                                            padding: const EdgeInsets.only(
                                                left: 0.0),
                                            child: const Text(
                                              'Full Day',
                                              style: TextStyle(
                                                color: purpleDark,
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
                                margin: const EdgeInsets.only(
                                    top: 20, left: 10, right: 10),
                                child: _selectedDayType[index] == "Full Day"
                                    ? fullTile()
                                    : _selectedDayType[index] == "Half Day"
                                        ? halfRadioTiles(context, index)
                                        : _selectedDayType[index] ==
                                                "Quarter Day"
                                            ? quarterRadioTiles(context, index)
                                            : fullTile()),
                          ],
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
                padding: const EdgeInsets.only(right: 13),
                child: Text(
                  itemValues,
                  style: const TextStyle(
                    color: purpleDark,
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
      color: purpleDark,
      margin: const EdgeInsets.only(bottom: 15),
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
                            ? purpleDark
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
                            activeColor: purpleDark,
                            // selected: false,
                          ),
                          const Text(
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
                            ? purpleDark
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
                            activeColor: purpleDark,
                            // selected: false,
                          ),
                          const Text(
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
                            ? purpleDark
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
                            activeColor: purpleDark,
                            // selected: false,
                          ),
                          const Text(
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
                            ? purpleDark
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
                            },
                            activeColor: purpleDark,
                            // selected: false,
                          ),
                          const Text(
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
                              ? purpleDark
                              : Colors.grey[200]),
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
                            activeColor: purpleDark,
                            // selected: false,
                          ),
                          const Text(
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
                            ? purpleDark
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
                            activeColor: purpleDark,
                          ),
                          const Text(
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
