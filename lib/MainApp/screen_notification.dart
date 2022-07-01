import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/MainApp/annoucment_screen.dart';
import 'package:hr_app/MainApp/main_home_profile/leave_approval.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'dart:async';

class Notifications extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  const Notifications({Key? key}) : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
  bool isNetwork = true;
  String? id;
  String? id2;
  String? senderPhoto;
  String? senderPhoto2;
  String? senderName;
  Stream? stream;
  StreamController? streamController;
  @override
  void initState() {
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

    streamController = StreamController.broadcast();
    stream = null;
    loadData2();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    streamController?.close();
    subscription!.cancel();
    streamController = null;
  }

  loadData2() async {
    stream = await load2();
    setState(() {});
  }

  Future<Stream> load2() async {
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("notifications")
        .where("receiver_id", isEqualTo: uid)
        .orderBy("timeStamp", descending: true)
        .snapshots();
    return query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildMyAppBar(context, 'Notifications', false),
        body: Stack(children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15, top: 15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: isNetwork
                  ? StreamBuilder(
                      stream: stream,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("ERROR"),
                          );
                        } else if (snapshot.hasData) {
                          return SingleChildScrollView(
                              child: snapshot.data!.docs.length == 0
                                  ? Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              120,
                                      child: const Text("No notification"),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var timeValue;
                                        if (index == 0) {
                                          timeValue = timeago.format(snapshot
                                              .data!.docs[index]
                                              .data()["timeStamp"]
                                              .toDate());
                                        } else {
                                          timeValue = timeago.format(snapshot
                                                      .data!.docs[index]
                                                      .data()["timeStamp"]
                                                      .toDate()) ==
                                                  timeago.format(snapshot
                                                      .data!.docs[index - 1]
                                                      .data()["timeStamp"]
                                                      .toDate())
                                              ? ""
                                              : timeago.format(snapshot
                                                  .data!.docs[index]
                                                  .data()["timeStamp"]
                                                  .toDate());
                                        }
                                        return StickyHeader(
                                          header: timeValue == ""
                                              ? Container()
                                              : Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 5),
                                                  alignment: Alignment.center,
                                                  height: 35.0,
                                                  child: Text(
                                                    '$timeValue',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                          content: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: isdarkmode.value != true
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .scaffoldBackgroundColor
                                                        .withOpacity(0.1),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  onTap: () {
                                                    snapshot.data!.docs[index]
                                                                ["title"] ==
                                                            "Leave Request"
                                                        ? setState(() {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "requests")
                                                                .doc(snapshot
                                                                            .data
                                                                            .docs[
                                                                        index]
                                                                    ["doc_id"])
                                                                .get()
                                                                .then(
                                                                    (onValues) {
                                                              (onValues['leaveStatus'] ==
                                                                      "pending")
                                                                  ? Navigator
                                                                      .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  LeaveApprovalScreen(
                                                                                    docId: snapshot.data.docs[index]["doc_id"],
                                                                                    empId: snapshot.data.docs[index]["employee_id"],
                                                                                  )))
                                                                  : Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "Notification status expired");
                                                            });
                                                          })
                                                        : snapshot.data!.docs[
                                                                        index]
                                                                    ["title"] ==
                                                                "Announcement"
                                                            ? setState(() {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                ShowAnnouncementScreen(docId: snapshot.data.docs[index]["doc_id"])));
                                                              })
                                                            : setState(() {});
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                            height: 50.0,
                                                            width: 50.0,
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(6),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: snapshot.data!.docs[index]
                                                                              [
                                                                              "title"] ==
                                                                          "Announcement"
                                                                      ? Colors
                                                                          .blue
                                                                      : snapshot.data!.docs[index]["title"] ==
                                                                              "Leave Approved"
                                                                          ? Colors
                                                                              .green
                                                                          : snapshot.data!.docs[index]["title"] == "Leave Rejected"
                                                                              ? Colors.red
                                                                              : Colors.black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Icon(
                                                                  snapshot.data!.docs[index]
                                                                              [
                                                                              "title"] ==
                                                                          "Announcement"
                                                                      ? Icons
                                                                          .campaign_outlined
                                                                      : snapshot.data!.docs[index]["title"] ==
                                                                              "Leave Approved"
                                                                          ? Icons
                                                                              .done
                                                                          : snapshot.data!.docs[index]["title"] == "Leave Rejected"
                                                                              ? Icons.close
                                                                              : Icons.notifications_none,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 40,
                                                                ))),

                                                        //   Container(
                                                        //     padding: EdgeInsets.all(6),
                                                        //     decoration: BoxDecoration(
                                                        //       borderRadius: BorderRadius.circular(10),
                                                        //       color: model.status == "Approved"
                                                        //           ? Colors.green
                                                        //           : model.status == "Rejected"
                                                        //               ? Colors.red
                                                        //               : Colors.blue,
                                                        //     ),
                                                        //     child: Icon(
                                                        //       model.status == "Approved"
                                                        //           ? Icons.done
                                                        //           : model.status == "Rejected"
                                                        //               ? Icons.close
                                                        //               : Icons.campaign_outlined,
                                                        //       color: Colors.white,
                                                        //       size: 40,
                                                        //     ),
                                                        //   ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  120,
                                                              child: Text(snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ["body"]),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                              DateFormat.jm()
                                                                  .add_yMd()
                                                                  .format(DateTime.parse(snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          "timeStamp"]
                                                                      .toDate()
                                                                      .toString()))
                                                                  .toString(),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        );
                                      }));
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })
                  : Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height - 120,
                      child: const Text("No Internet Connection"),
                    ),
            ),
          ),
        ]));
  }

  // String? parse(var model) {
  //   DateTime now = DateTime.now();
  //   String? formattedDate =  DateFormat('yyyy-MM-dd').format(now);

  //   if (DateTime.parse(formattedDate) == model)
  //     return 'today';
  //   else
  //     return 'Earlier';
  // }

  // int mygroup(DateTime model, DateTime model1) {
  //   DateTime now = DateTime.now();
  //   String? formattedDate =  DateFormat('yyyy-MM-dd').format(now);
  //   // print('$model   ' '$model1');
  //   if (model1.isAtSameMomentAs(model))
  //     return 0;
  //   else if (model1.isBefore(model))
  //     return 0;
  //   else
  //     return 1;
  // }

  // int mygroup1(DateTime model, DateTime model1) {
  //   DateTime now = DateTime.now();
  //   String? formattedDate =  DateFormat('yyyy-MM-dd').format(now);
  //   // print('n$model   ' 'n$model1');
  //   if (model.isAtSameMomentAs(DateTime.parse(formattedDate)))
  //     return 0;
  //   else if (model.isBefore(DateTime.parse(formattedDate)))
  //     return 0;
  //   else
  //     return 1;
  // }
}
