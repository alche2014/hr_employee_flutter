// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/MainApp/main_home_profile/teamInfo.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';

class MainCheckInTeam extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  const MainCheckInTeam({Key? key}) : super(key: key);

  @override
  _MainCheckInTeamState createState() => _MainCheckInTeamState();
}

class _MainCheckInTeamState extends State<MainCheckInTeam> {
  DateTime now = DateTime.now();
  List<Map<String, dynamic>> empAtten = [];
  int presentEmp = 0;
  DateTime avg = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 00);
  List avgCheckin = [];
  List avgCheckout = [];
  int avgIn = 0;
  int avgOut = 0;
  var weekendDefi;

  @override
  void initState() {
    super.initState();
    loadTeam();
    _getShiftSchedule();
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

  loadTeam() {
    FirebaseFirestore.instance
        .collection('employees')
        .where("reportingToId", isEqualTo: uid)
        .where("active", isEqualTo: true)
        .snapshots()
        .listen((onValue) async {
      empAtten.clear();
      presentEmp = 0;
      avgCheckin.clear();
      avgCheckout.clear();
      avgOut = 0;
      avgIn = 0;
      avg = DateTime(now.year, now.month, now.day, 00, 00);
      setState(() {
        for (var doc in onValue.docs) {
          FirebaseFirestore.instance
              .collection("attendance")
              .where("empId", isEqualTo: doc.id.toString())
              .where("date",
                  isEqualTo: DateFormat('MMMM dd yyyy').format(now).toString())
              .snapshots()
              .listen((onValues) {
            setState(() {
              if (onValues.docs.isEmpty) {
                empAtten.add({
                  "id": doc.id.toString(),
                  "image": doc['imagePath'],
                  "name": doc['displayName'],
                  "desig": doc['designation'],
                  "absent": "true",
                  "late": "",
                  "checkin": null,
                  "checkout": null,
                });
              } else {
                presentEmp++;
                late Timestamp checkin =
                    onValues.docs.first['checkin'] as Timestamp;
                late DateTime dateIn = checkin.toDate();
                empAtten.add({
                  "id": doc.id.toString(),
                  "image": doc['imagePath'],
                  "name": doc['displayName'],
                  "desig": doc['designation'],
                  "absent": "false",
                  "late": onValues.docs.first['late'],
                  "checkin": dateIn,
                  "checkout": onValues.docs.first['checkout'],
                });

                avgIn = avgIn +
                    int.parse(dateIn.difference(avg).inMinutes.toString());
                avgCheckin.add(dateIn.difference(avg).inMinutes);
                if (onValues.docs.first['checkout'] != null) {
                  late Timestamp checkout;
                  checkout = onValues.docs.first['checkout'] as Timestamp;
                  late DateTime dateOut;
                  dateOut = checkout.toDate();
                  avgOut = avgOut +
                      int.parse(dateOut.difference(avg).inMinutes.toString());
                  avgCheckout.add(dateOut.difference(avg).inMinutes);
                }
              }
            });
          });
        }
      });
    });
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(now.year - 5),
        lastDate: DateTime.now());
    if (picked != null && picked != now) {
      setState(() {
        now = picked;
        loadTeam();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildMyAppBar(context, 'My Team', false),
        body: weekendDefi == null
            ? shimmer(context)
            : Column(
                children: [
                  Container(
                    height: 90,
                    margin: const EdgeInsets.all(20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 3,
                              child: miniCards(
                                  'assets/announcement.jpg', "Team Reports")),
                          SizedBox(width: 10),
                          Expanded(
                              flex: 3,
                              child: miniCards(
                                  'assets/leaves.png', "Performance")),
                          SizedBox(width: 10),
                          Expanded(
                              flex: 3,
                              child: miniCards(
                                  'assets/announcement.jpg', "Requests")),
                        ]),
                  ),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                        color: Colors.white),
                    child: Container(
                      margin: EdgeInsets.only(top: 30, left: 12),
                      child: Text("Present",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade400)),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 278,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  margin: EdgeInsets.only(
                                      top: 5, bottom: 5, right: 8),
                                  padding: EdgeInsets.all(15),
                                  child: Text("Team Members",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: greyShade)),
                                )),
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5))),
                                      margin: EdgeInsets.only(
                                          top: 5, bottom: 5, left: 8),
                                      padding: EdgeInsets.all(11),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.calendar_month_outlined,
                                              color: purpleDark),
                                          Text(
                                              DateFormat('dd MMMM yyyy')
                                                  .format(now),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500,
                                                  color: greyShade)),
                                        ],
                                      )),
                                ))
                              ],
                            ),
                            SizedBox(height: 10),

                            !weekendDefi.contains(
                                        "${DateFormat('EEE').format(now)}${(now.day / 8).toInt() + 1}") &&
                                    !weekendDefi.contains(
                                        "${DateFormat('EEE').format(now)}0")
                                ? Row(
                                    children: [
                                      Expanded(
                                          child: avgPresent(
                                              "$presentEmp/${empAtten.length}",
                                              "Present",
                                              'assets/workingHrs.png')),
                                      Container(
                                          width: 1,
                                          height: 40,
                                          color: Colors.grey.shade300),
                                      Expanded(
                                          child: avgPresent(
                                              avgCheckin.isEmpty
                                                  ? " -- : --"
                                                  : DateFormat('K:mma').format(
                                                      DateTime(
                                                          now.year,
                                                          now.month,
                                                          now.day,
                                                          (avgIn /
                                                                  avgCheckin
                                                                      .length ~/
                                                                  60)
                                                              .toInt(),
                                                          (avgIn /
                                                                  avgCheckin
                                                                      .length %
                                                                  60)
                                                              .toInt())),
                                              "Avg Clock In",
                                              'assets/checkin.png')),
                                      Container(
                                          width: 1,
                                          height: 40,
                                          color: Colors.grey.shade300),
                                      Expanded(
                                          child: avgPresent(
                                              avgCheckout.isEmpty
                                                  ? " -- : --"
                                                  : DateFormat('K:mma').format(
                                                      DateTime(
                                                          now.year,
                                                          now.month,
                                                          now.day,
                                                          (avgOut /
                                                                  avgCheckout
                                                                      .length ~/
                                                                  60)
                                                              .toInt(),
                                                          (avgOut /
                                                                  avgCheckout
                                                                      .length %
                                                                  60)
                                                              .toInt())),
                                              "Avg Clock Out",
                                              'assets/checkout.png'))
                                    ],
                                  )
                                : Container(
                                    height: 45,
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    color: Colors.purple.shade50,
                                    child: Center(
                                      child: Text(
                                        "Weekend: ${now.day} ${DateFormat('EEE').format(now).toUpperCase()}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                            empAtten.isEmpty
                                ? shimmer(context)
                                : ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: empAtten.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          TeamMemberInfo(
                                                              teamId:
                                                                  "${empAtten[index]['id']}")));
                                            },
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                radius: 20,
                                                child: ClipRRect(
                                                  clipBehavior: Clip.antiAlias,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: empAtten[index]
                                                                  ["image"]
                                                              .toString() !=
                                                          null
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                              empAtten[index]
                                                                      ["image"]
                                                                  .toString(),
                                                          fit: BoxFit.cover,
                                                          height: 40,
                                                          width: 40,
                                                          progressIndicatorBuilder:
                                                              (context, url,
                                                                      downloadProgress) =>
                                                                  CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress,
                                                            color: Colors.white,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        )
                                                      : Image.asset(
                                                          'assets/placeholder.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                              title: Text(
                                                empAtten[index]["name"]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                empAtten[index]["desig"]
                                                    .toString(),
                                                style: TextStyle(fontSize: 11),
                                              ),
                                              trailing: SizedBox(
                                                  width: 150,
                                                  child: empAtten[index]
                                                                  ["absent"]
                                                              .toString() ==
                                                          "true"
                                                      ? !weekendDefi.contains(
                                                                  "${DateFormat('EEE').format(now)}${(now.day / 8).toInt() + 1}") &&
                                                              !weekendDefi.contains(
                                                                  "${DateFormat('EEE').format(now)}0")
                                                          ? Container(
                                                              width: 70,
                                                              height: 30,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 80),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .red
                                                                    .shade600,
                                                              ),
                                                              child: Text(
                                                                "Absent",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ))
                                                          : Container()
                                                      : empAtten[index]
                                                                  ['late'] ==
                                                              '-'
                                                          ? Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                empAtten[index]
                                                                    ['leave'],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            )
                                                          : Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Row(
                                                                        children: [
                                                                      SizedBox(
                                                                        height:
                                                                            15,
                                                                        width:
                                                                            15,
                                                                        child: Image.asset(
                                                                            "assets/Arrowdown.png"),
                                                                      ),
                                                                      Text(
                                                                          DateFormat('K:mma')
                                                                              .format(empAtten[index][
                                                                                  "checkin"])
                                                                              .toLowerCase(),
                                                                          style:
                                                                              TextStyle(color: empAtten[index]["late"].toString() == "0 hrs & 0 mins" ? Colors.green : Colors.red))
                                                                    ])),
                                                                SizedBox(
                                                                    width: 10),
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            15,
                                                                        width:
                                                                            15,
                                                                        child: Image.asset(
                                                                            "assets/Arrowup.png"),
                                                                      ),
                                                                      Text(
                                                                          empAtten[index]['checkout'] == null
                                                                              ? "  -- : --"
                                                                              : DateFormat('K:mma').format(empAtten[index]['checkout'].toDate()).toLowerCase(),
                                                                          style: TextStyle(color: empAtten[index]['checkout'] == null ? Colors.black : Colors.green)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            height: 1,
                                            color: Colors.grey.shade300,
                                          ),
                                        ],
                                      );
                                    }),

                            // StreamBuilder<QuerySnapshot>(
                            //     stream: FirebaseFirestore.instance
                            //         .collection("employees")
                            //         .where("reportingToId", isEqualTo: uid)
                            //         .where("active", isEqualTo: true)
                            //         .snapshots(),
                            //     builder: (context,
                            //         AsyncSnapshot<QuerySnapshot> snapshotx) {
                            //       if (!snapshotx.hasData) {
                            //         return Text("");
                            //       } else if (snapshotx.hasData) {
                            //         return snapshotx.data!.docs.isEmpty
                            //             ? Text("")
                            //             : SingleChildScrollView(
                            //                 child: Column(
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.start,
                            //                 children: [
                            //                   Column(children: [
                            //                     // StreamBuilder<QuerySnapshot>(
                            //                     //     stream: FirebaseFirestore.instance
                            //                     //         .collection("attendance")
                            //                     //         .where("reportingToId",
                            //                     //             isEqualTo: widget.uid)
                            //                     //         .where("date",
                            //                     //             isEqualTo: DateFormat(
                            //                     //                     'MMMM dd yyyy')
                            //                     //                 .format(DateTime.now())
                            //                     //                 .toString())
                            //                     //         .snapshots(),
                            //                     //     builder: (context,
                            //                     //         AsyncSnapshot<QuerySnapshot>
                            //                     //             snapshots) {
                            //                     //       absent = (snapshotx
                            //                     //               .data!.docs.length -
                            //                     //           snapshots.data!.docs.length);
                            //                     //       return Row(
                            //                     //         mainAxisAlignment:
                            //                     //             MainAxisAlignment
                            //                     //                 .spaceBetween,
                            //                     //         children: [
                            //                     //           Text(
                            //                     //               snapshots.hasData
                            //                     //                   ? (snapshotx
                            //                     //                               .data!
                            //                     //                               .docs
                            //                     //                               .length -
                            //                     //                           snapshots
                            //                     //                               .data!
                            //                     //                               .docs
                            //                     //                               .length)
                            //                     //                       .toString()
                            //                     //                   : "0",
                            //                     //               style: TextStyle(
                            //                     //                   color: Colors.blue,
                            //                     //                   fontWeight:
                            //                     //                       FontWeight.bold)),
                            //                     //           StreamBuilder<QuerySnapshot>(
                            //                     //               stream: FirebaseFirestore
                            //                     //                   .instance
                            //                     //                   .collection(
                            //                     //                       "attendance")
                            //                     //                   .where(
                            //                     //                       "reportingToId",
                            //                     //                       isEqualTo:
                            //                     //                           widget.uid)
                            //                     //                   .where("date",
                            //                     //                       isEqualTo: DateFormat(
                            //                     //                               'MMMM dd yyyy')
                            //                     //                           .format(
                            //                     //                               DateTime
                            //                     //                                   .now())
                            //                     //                           .toString())
                            //                     //                   .where("late",
                            //                     //                       isEqualTo:
                            //                     //                           "0 hrs & 0 mins")
                            //                     //                   .snapshots(),
                            //                     //               builder: (context,
                            //                     //                   AsyncSnapshot<
                            //                     //                           QuerySnapshot>
                            //                     //                       onTime) {
                            //                     //                 ontime = onTime
                            //                     //                     .data!.docs.length;
                            //                     //                 lates = totalemployee -
                            //                     //                     (onTime.data!.docs
                            //                     //                             .length +
                            //                     //                         absent);
                            //                     //                 return Text(
                            //                     //                     onTime.hasData
                            //                     //                         ? ontime
                            //                     //                             .toString()
                            //                     //                         : "0",
                            //                     //                     style: TextStyle(
                            //                     //                         color: Colors
                            //                     //                             .green,
                            //                     //                         fontWeight:
                            //                     //                             FontWeight
                            //                     //                                 .bold));
                            //                     //               }),
                            //                     //           Text(
                            //                     //               snapshots.hasData
                            //                     //                   ? lates.toString()
                            //                     //                   : "0",
                            //                     //               style: TextStyle(
                            //                     //                   color:
                            //                     //                       Colors.red[800],
                            //                     //                   fontWeight:
                            //                     //                       FontWeight.bold)),
                            //                     //         ],
                            //                     //       );
                            //                     //     }),

                            //                     // FittedBox(
                            //                     //   child: Container(
                            //                     //     clipBehavior: Clip.antiAlias,
                            //                     //     decoration: BoxDecoration(
                            //                     //       borderRadius:
                            //                     //           BorderRadius.circular(50),
                            //                     //       color: Colors.grey[300],
                            //                     //     ),
                            //                     //     height: 15,
                            //                     //     width: MediaQuery.of(context)
                            //                     //         .size
                            //                     //         .width,
                            //                     //     child: !snapshotx.hasData
                            //                     //         ? Container()
                            //                     //         : Row(
                            //                     //             children: [
                            //                     //               Container(
                            //                     //                 height: 15,
                            //                     //                 width: totalemployee ==
                            //                     //                         0
                            //                     //                     ? 0
                            //                     //                     : MediaQuery.of(
                            //                     //                                 context)
                            //                     //                             .size
                            //                     //                             .width *
                            //                     //                         ((absent /
                            //                     //                                 totalemployee *
                            //                     //                                 100) /
                            //                     //                             100),
                            //                     //                 color: Colors.blue,
                            //                     //               ),
                            //                     //               Container(
                            //                     //                 height: 15,
                            //                     //                 width: totalemployee ==
                            //                     //                         0
                            //                     //                     ? 0
                            //                     //                     : MediaQuery.of(
                            //                     //                                 context)
                            //                     //                             .size
                            //                     //                             .width *
                            //                     //                         ((ontime /
                            //                     //                                 totalemployee *
                            //                     //                                 100) /
                            //                     //                             100),
                            //                     //                 color: Colors.green,
                            //                     //               ),
                            //                     //               Container(
                            //                     //                 height: 15,
                            //                     //                 width: totalemployee ==
                            //                     //                         0
                            //                     //                     ? 0
                            //                     //                     : MediaQuery.of(
                            //                     //                                 context)
                            //                     //                             .size
                            //                     //                             .width *
                            //                     //                         ((lates /
                            //                     //                                 totalemployee *
                            //                     //                                 100) /
                            //                     //                             100),
                            //                     //                 color: Colors.red,
                            //                     //               )
                            //                     //             ],
                            //                     //           ),
                            //                     //   ),
                            //                     // ),
                            //                     // const SizedBox(
                            //                     //   height: 15,
                            //                     // )
                            //                   ]),
                            //                   !snapshotx.hasData
                            //                       ? Container()
                            //                       : ListView.builder(
                            //                           padding: EdgeInsets.all(0),
                            //                           shrinkWrap: true,
                            //                           physics:
                            //                               NeverScrollableScrollPhysics(),
                            //                           itemCount:
                            //                               snapshotx.data!.docs.length,
                            //                           itemBuilder: (context, index) {
                            //                             return StreamBuilder<
                            //                                     DocumentSnapshot>(
                            //                                 stream: FirebaseFirestore
                            //                                     .instance
                            //                                     .collection(
                            //                                         "employees")
                            //                                     .doc(snapshotx.data!
                            //                                             .docs[index]
                            //                                         ["uid"])
                            //                                     .snapshots(),
                            //                                 builder: (context,
                            //                                     AsyncSnapshot<
                            //                                             DocumentSnapshot>
                            //                                         snapshot) {
                            //                                   if (!snapshot
                            //                                       .hasData) {
                            //                                     return Text("");
                            //                                   } else if (snapshot
                            //                                       .hasData) {
                            //                                     return EmpCheckIn(
                            //                                         snapshot.data!);
                            //                                   } else {
                            //                                     return CircularProgressIndicator();
                            //                                   }
                            //                                 });
                            //                           }),
                            //                 ],
                            //               ));
                            //       } else if (snapshotx.hasError) {
                            //         return Text("Error");
                            //       } else {
                            //         return CircularProgressIndicator();
                            //       }
                            //     }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  Widget avgPresent(title, subtitle, image) {
    return Container(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(4),
              height: 20,
              width: 20,
              child: Image.asset(image, height: 10),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 11,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500)),
              ],
            ),
          ],
        ));
  }

  Widget miniCards(image, title) {
    return InkWell(
      onTap: () {
        Fluttertoast.showToast(msg: "In Progress");

        // if (title == "Team Reports") {
        // Fluttertoast.showToast(msg: "You are not the team lead");

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => TeamReports()));
        // } else if (title == "Announcements") {
        //   // Navigator.push(context,
        //   //     MaterialPageRoute(builder: (context) => const Announcements()));
        // } else if (title == "Leaves") {
        //   // Navigator.push(context,
        //   //     MaterialPageRoute(builder: (context) => const LeaveManagement()));
        // }
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: purpleLight.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 3))
                ]),
            child: Container(
              padding: const EdgeInsets.all(12),
              height: 10,
              child: Image.asset(image, height: 10),
            ),
          ),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: greyShade)),
        ],
      ),
    );
  }
}
