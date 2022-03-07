// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:hr_app/MainApp/CheckIn/emp_checkin.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:shimmer/shimmer.dart';

class MainCheckInTeam extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final uid;
  const MainCheckInTeam({Key? key, this.uid}) : super(key: key);

  @override
  _MainCheckInTeamState createState() => _MainCheckInTeamState();
}

class _MainCheckInTeamState extends State<MainCheckInTeam> {
  var totalemployee = 0;
  var ontime = 0;
  var lates = 0;
  var absent = 0;
  DateTime now = DateTime.now();
  Stream? stream;
  bool wait = false;

  refresh() async {
    await Future.delayed(const Duration(milliseconds: 1250), () {
      setState(() {});
    });
  }

  Future<Stream> load() async {
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("employees")
        .where("reportingToId", isEqualTo: widget.uid)
        .where("active", isEqualTo: true)
        .snapshots();
    return query;
  }

  loadData() async {
    stream = await load();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    stream = null;
    loadData();

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildMyAppBar(context, 'My Team', false),

        // appBar: buildMyAppBar(context, 'Checkin History', true), //custom appbar
        body: Stack(children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            child: now.weekday == 6 || now.weekday == 7
                ? Center(child: Text("Today is not a working day"))
                : (StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("employees")
                        .where("reportingToId", isEqualTo: widget.uid)
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
                            : SingleChildScrollView(
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 17, vertical: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          // padding: const EdgeInsets.symmetric(
                                          //     horizontal: 20, vertical: 10),
                                          // decoration: BoxDecoration(
                                          //   border: Border.all(
                                          //     width: 0.0,
                                          //     color: isdarkmode.value
                                          //         ? Color(0xff34354A)
                                          //         : Colors.grey,
                                          //   ),
                                          //   borderRadius: const BorderRadius.all(
                                          //     Radius.circular(10),
                                          //   ),
                                          // ),
                                          child: Column(children: [
                                            //    SizedBox(height: 20),
                                            // Text(
                                            //   "Today's Detail",
                                            //   style: TextStyle(
                                            //       color: Colors.red[800],
                                            //       fontWeight: FontWeight.bold),
                                            // ),
                                            // SizedBox(
                                            //   height: 22,
                                            // ),
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.spaceBetween,
                                            //   children: const [
                                            //     Text(
                                            //       'Absent',
                                            //       style: TextStyle(
                                            //           fontWeight: FontWeight.bold),
                                            //     ),
                                            //     Text('On Time',
                                            //         style: TextStyle(
                                            //             fontWeight:
                                            //                 FontWeight.bold)),
                                            //     Text('Late',
                                            //         style: TextStyle(
                                            //             fontWeight:
                                            //                 FontWeight.bold)),
                                            //   ],
                                            // ),
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            // StreamBuilder<QuerySnapshot>(
                                            //     stream: FirebaseFirestore.instance
                                            //         .collection("attendance")
                                            //         .where("reportingToId",
                                            //             isEqualTo: widget.uid)
                                            //         .where("date",
                                            //             isEqualTo: DateFormat(
                                            //                     'MMMM dd yyyy')
                                            //                 .format(DateTime.now())
                                            //                 .toString())
                                            //         .snapshots(),
                                            //     builder: (context,
                                            //         AsyncSnapshot<QuerySnapshot>
                                            //             snapshots) {
                                            //       absent = (snapshotx
                                            //               .data!.docs.length -
                                            //           snapshots.data!.docs.length);
                                            //       return Row(
                                            //         mainAxisAlignment:
                                            //             MainAxisAlignment
                                            //                 .spaceBetween,
                                            //         children: [
                                            //           Text(
                                            //               snapshots.hasData
                                            //                   ? (snapshotx
                                            //                               .data!
                                            //                               .docs
                                            //                               .length -
                                            //                           snapshots
                                            //                               .data!
                                            //                               .docs
                                            //                               .length)
                                            //                       .toString()
                                            //                   : "0",
                                            //               style: TextStyle(
                                            //                   color: Colors.blue,
                                            //                   fontWeight:
                                            //                       FontWeight.bold)),
                                            //           StreamBuilder<QuerySnapshot>(
                                            //               stream: FirebaseFirestore
                                            //                   .instance
                                            //                   .collection(
                                            //                       "attendance")
                                            //                   .where(
                                            //                       "reportingToId",
                                            //                       isEqualTo:
                                            //                           widget.uid)
                                            //                   .where("date",
                                            //                       isEqualTo: DateFormat(
                                            //                               'MMMM dd yyyy')
                                            //                           .format(
                                            //                               DateTime
                                            //                                   .now())
                                            //                           .toString())
                                            //                   .where("late",
                                            //                       isEqualTo:
                                            //                           "0 hrs & 0 mins")
                                            //                   .snapshots(),
                                            //               builder: (context,
                                            //                   AsyncSnapshot<
                                            //                           QuerySnapshot>
                                            //                       onTime) {
                                            //                 ontime = onTime
                                            //                     .data!.docs.length;
                                            //                 lates = totalemployee -
                                            //                     (onTime.data!.docs
                                            //                             .length +
                                            //                         absent);
                                            //                 return Text(
                                            //                     onTime.hasData
                                            //                         ? ontime
                                            //                             .toString()
                                            //                         : "0",
                                            //                     style: TextStyle(
                                            //                         color: Colors
                                            //                             .green,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .bold));
                                            //               }),
                                            //           Text(
                                            //               snapshots.hasData
                                            //                   ? lates.toString()
                                            //                   : "0",
                                            //               style: TextStyle(
                                            //                   color:
                                            //                       Colors.red[800],
                                            //                   fontWeight:
                                            //                       FontWeight.bold)),
                                            //         ],
                                            //       );
                                            //     }),
                                            // SizedBox(
                                            //   height: 25,
                                            // ),
                                            //----------------------------Bar----------------------------------//

                                            // FittedBox(
                                            //   child: Container(
                                            //     clipBehavior: Clip.antiAlias,
                                            //     decoration: BoxDecoration(
                                            //       borderRadius:
                                            //           BorderRadius.circular(50),
                                            //       color: Colors.grey[300],
                                            //     ),
                                            //     height: 15,
                                            //     width: MediaQuery.of(context)
                                            //         .size
                                            //         .width,
                                            //     child: !snapshotx.hasData
                                            //         ? Container()
                                            //         : Row(
                                            //             children: [
                                            //               Container(
                                            //                 height: 15,
                                            //                 width: totalemployee ==
                                            //                         0
                                            //                     ? 0
                                            //                     : MediaQuery.of(
                                            //                                 context)
                                            //                             .size
                                            //                             .width *
                                            //                         ((absent /
                                            //                                 totalemployee *
                                            //                                 100) /
                                            //                             100),
                                            //                 color: Colors.blue,
                                            //               ),
                                            //               Container(
                                            //                 height: 15,
                                            //                 width: totalemployee ==
                                            //                         0
                                            //                     ? 0
                                            //                     : MediaQuery.of(
                                            //                                 context)
                                            //                             .size
                                            //                             .width *
                                            //                         ((ontime /
                                            //                                 totalemployee *
                                            //                                 100) /
                                            //                             100),
                                            //                 color: Colors.green,
                                            //               ),
                                            //               Container(
                                            //                 height: 15,
                                            //                 width: totalemployee ==
                                            //                         0
                                            //                     ? 0
                                            //                     : MediaQuery.of(
                                            //                                 context)
                                            //                             .size
                                            //                             .width *
                                            //                         ((lates /
                                            //                                 totalemployee *
                                            //                                 100) /
                                            //                             100),
                                            //                 color: Colors.red,
                                            //               )
                                            //             ],
                                            //           ),
                                            //   ),
                                            // ),
                                            // const SizedBox(
                                            //   height: 15,
                                            // )
                                          ]),
                                        ),
                                        !snapshotx.hasData
                                            ? Container()
                                            : ListView.builder(
                                                padding: EdgeInsets.all(0),
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    snapshotx.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  return StreamBuilder<
                                                          DocumentSnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "employees")
                                                          .doc(snapshotx.data!
                                                                  .docs[index]
                                                              ["uid"])
                                                          .snapshots(),
                                                      builder: (context,
                                                          AsyncSnapshot<
                                                                  DocumentSnapshot>
                                                              snapshotxx) {
                                                        if (!snapshotxx
                                                            .hasData) {
                                                          return Text("");
                                                        } else if (snapshotxx
                                                            .hasData) {
                                                          return EmpCheckIn(
                                                              snapshotxx.data!);
                                                        } else {
                                                          return _shimmer();
                                                        }
                                                      });
                                                }),
                                      ],
                                    )));
                      } else if (snapshotx.hasError) {
                        return Text("Error");
                      } else {
                        return _shimmer();
                      }
                    })),
          )
        ]));
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
}
