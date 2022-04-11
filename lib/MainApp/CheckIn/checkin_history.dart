import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/CheckIn/check_in_card.dart';
import 'package:intl/intl.dart';

class CheckinHistory extends StatefulWidget {
  final memId;
  const CheckinHistory({Key? key, this.memId}) : super(key: key);

  @override
  State<CheckinHistory> createState() => _CheckinHistoryState();
}

class _CheckinHistoryState extends State<CheckinHistory> {
  int a = 0;
  DateTime now = DateTime.now();
  int days = 0;
  String dropdownValue =
      '${DateFormat('MMMM yyyy').format(DateTime.now()).toString()}';
  @override
  void initState() {
    days = DateTime(now.year, now.month + 1, now.day).day;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 120),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("attendance")
                        .where("empId", isEqualTo: widget.memId)
                        .where("month", isEqualTo: dropdownValue)
                        .orderBy("checkin", descending: false)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("ERROR"),
                        );
                      } else if (snapshot.hasData) {
                        return snapshot.data!.docs.isEmpty
                            ? Center(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height - 450,
                                  margin: const EdgeInsets.only(
                                      bottom: 20, top: 50),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.calendar_today,
                                        color: purpleDark,
                                        size: 100,
                                      ),
                                      const Text(
                                        "It's empty here.",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "No records found.",
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: days,
                                // reverse: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return
                                      // snapshot.data!.docs[index]['late'] ==
                                      //         "-"
                                      //     ? Column(children: [
                                      //         Row(
                                      //           children: [
                                      //             Expanded(
                                      //               flex: 2,
                                      //               child: Center(
                                      //                 child: Container(
                                      //                   width: 43,
                                      //                   padding:
                                      //                       const EdgeInsets.all(
                                      //                           5.0),
                                      //                   decoration: BoxDecoration(
                                      //                       color: Colors.white,
                                      //                       borderRadius:
                                      //                           BorderRadius
                                      //                               .circular(5),
                                      //                       border: Border.all(
                                      //                           color: Colors
                                      //                               .grey.shade300,
                                      //                           width: 1)),
                                      //                   child: Column(children: [
                                      //                     Text(
                                      //                         DateFormat('dd').format(DateFormat(
                                      //                                 'MMMM dd yyyy')
                                      //                             .parse(snapshot
                                      //                                         .data!
                                      //                                         .docs[
                                      //                                     index]
                                      //                                 ['date'])),
                                      //                         style: const TextStyle(
                                      //                             fontWeight:
                                      //                                 FontWeight
                                      //                                     .bold,
                                      //                             fontSize: 17)),
                                      //                     const SizedBox(height: 2),
                                      //                     Text(
                                      //                         DateFormat(
                                      //                                 'EEE')
                                      //                             .format(DateFormat(
                                      //                                     'MMMM dd yyyy')
                                      //                                 .parse(snapshot
                                      //                                         .data!
                                      //                                         .docs[index]
                                      //                                     ['date']))
                                      //                             .toUpperCase(),
                                      //                         style: TextStyle(
                                      //                             fontWeight:
                                      //                                 FontWeight
                                      //                                     .bold,
                                      //                             fontSize: 12,
                                      //                             color: Colors.grey
                                      //                                 .shade700)),
                                      //                   ]),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             Expanded(
                                      //                 flex: 9,
                                      //                 child: Center(
                                      //                   child: Text(
                                      //                     snapshot.data!.docs[index]
                                      //                         ['leave'],
                                      //                     style: const TextStyle(
                                      //                         color: Colors.red),
                                      //                   ),
                                      //                 )),
                                      //           ],
                                      //         ),
                                      //         Container(
                                      //           margin: const EdgeInsets.only(
                                      //               top: 5,
                                      //               bottom: 5,
                                      //               left: 75,
                                      //               right: 10),
                                      //           height: 1,
                                      //           color: Colors.grey.shade300,
                                      //         )
                                      //       ])
                                      //     :
                                      checkinCard(snapshot.data!.docs, index,
                                          dropdownValue);
                                });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.white,
                height: 60,
                child: ListTile(
                  leading: InkWell(
                      onTap: () {
                        setState(() {
                          now = DateTime(now.year, now.month - 1);
                          dropdownValue =
                              '${DateFormat('MMMM yyyy').format(now).toString()}';
                          days = DateTime(now.year, now.month + 1, 0).day;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_back_ios_new, size: 18))),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: purpleDark, size: 20),
                      Text(" ${DateFormat('MMMM yyyy').format(now)}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: purpleDark)),
                    ],
                  ),
                  trailing: InkWell(
                      onTap: () {
                        if (now.year == DateTime.now().year &&
                            now.month == DateTime.now().month) {
                          Fluttertoast.showToast(msg: "No more records");
                        } else {
                          setState(() {
                            now = DateTime(now.year, now.month + 1);
                            dropdownValue =
                                '${DateFormat('MMMM yyyy').format(now).toString()}';
                            days = DateTime(now.year, now.month + 1, 0).day;
                          });
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child:
                              const Icon(Icons.arrow_forward_ios, size: 18))),
                ),
              ),
              Container(height: 1, color: Colors.grey.shade400),
              Container(
                height: 50,
                color: Colors.grey.shade100,
                child: Row(children: const [
                  Expanded(
                      flex: 2,
                      child: Text("Date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade))),
                  Expanded(
                      flex: 3,
                      child: Text("Clock in",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade))),
                  Expanded(
                      flex: 3,
                      child: Text("Clock out",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade))),
                  Expanded(
                      flex: 3,
                      child: Text("Working Hrs",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade)))
                ]),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget checkinCard(timeStatus, index, day) {
    if (DateFormat('EEE')
                .format(DateFormat('dd MMMM yyyy').parse("${index + 1} $day"))
                .toUpperCase() ==
            "SAT" ||
        DateFormat('EEE')
                .format(DateFormat('dd MMMM yyyy').parse("${index + 1} $day"))
                .toUpperCase() ==
            "SUN") {
      a++;
    } else if (timeStatus[index - a]['date'].toString() !=
        DateFormat('MMMM dd yyyy')
            .format(DateFormat('dd MMMM yyyy').parse("${index + 1} $day"))) {
      a++;
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  width: 43,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),
                  child: Column(children: [
                    Text("${index + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                    const SizedBox(height: 2),
                    Text(
                        DateFormat('EEE')
                            .format(DateFormat('dd MMMM yyyy')
                                .parse("${index + 1} $day"))
                            .toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey.shade700)),
                  ]),
                ),
              ),
            ),
            Expanded(
                flex: 9,
                child: Center(
                  child: DateFormat('EEE')
                                  .format(DateFormat('dd MMMM yyyy')
                                      .parse("${index + 1} $day"))
                                  .toUpperCase() ==
                              "SAT" ||
                          DateFormat('EEE')
                                  .format(DateFormat('dd MMMM yyyy')
                                      .parse("${index + 1} $day"))
                                  .toUpperCase() ==
                              "SUN"
                      ? Text("Weekend")
                      : timeStatus[index - a]['date'].toString() !=
                              DateFormat('MMMM dd yyyy').format(
                                  DateFormat('dd MMMM yyyy')
                                      .parse("${index + 1} $day"))
                          ? Text("absent")
                          : Text(
                              timeStatus[index - a]['date']
                                  // .indexOf(DateFormat('dd MMMM yyyy')
                                  //     .parse("${index + 1} $day"))
                                  .toString(),
                              // [6]['late'].toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                )),
            // Expanded(
            //     flex: 3,
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         SizedBox(
            //           height: 12,
            //           width: 12,
            //           child: Image.asset("assets/Arrowdown.png"),
            //         ),
            //         const SizedBox(width: 4),
            //         Text(
            //           DateFormat('K:mma').format(dateTime).toLowerCase(),
            //           style: TextStyle(
            //               color: timeStatus["late"] == "0 hrs & 0 mins"
            //                   ? Colors.green
            //                   : Colors.red),
            //         ),
            //       ],
            //     )),
            // Expanded(
            //   flex: 3,
            //   child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         timeStatus['checkout'] != null
            //             ? SizedBox(
            //                 height: 12,
            //                 width: 12,
            //                 child: Image.asset("assets/Arrowup.png"),
            //               )
            //             : Container(),
            //         const SizedBox(width: 4),
            //         Text(timeStatus['checkout'] == null
            //             ? "- - - - "
            //             : DateFormat('K:mma').format(dateTime2).toLowerCase()),
            //       ]),
            // ),
            // Expanded(
            //   flex: 3,
            //   child: Center(
            //       child: timeStatus["checkout"] == null
            //           ? Text(
            //               "${((DateTime.now().difference(dateTime).inSeconds) / 3600).toInt()} : ${(((DateTime.now().difference(dateTime).inSeconds) % 3600) / 60).toInt()}")
            //           : Text(' ${timeStatus["workHours"]}')),
            // ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5, left: 75, right: 10),
          height: 1,
          color: Colors.grey.shade300,
        )
      ],
    );
  }
}
