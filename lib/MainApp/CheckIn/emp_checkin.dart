import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';

class EmpCheckIn extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final timeStatus;
  const EmpCheckIn(this.timeStatus, {Key? key}) : super(key: key);

  @override
  State<EmpCheckIn> createState() => _EmpCheckInState();
}

class _EmpCheckInState extends State<EmpCheckIn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Material(
        elevation: 2,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        //========================================//
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: isdarkmode.value ? const Color(0xff34354A) : Colors.white,
          ),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("attendance")
                  .where("empId", isEqualTo: widget.timeStatus["uid"])
                  .where("date",
                      isEqualTo: DateFormat('MMMM dd yyyy')
                          .format(DateTime.now())
                          .toString())
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshotxx) {
                if (snapshotxx.hasData) {
                  return snapshotxx.data!.docs.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 55,
                                      child: ClipRRect(
                                        clipBehavior: Clip.antiAlias,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          image: NetworkImage(
                                              widget.timeStatus!["imagePath"]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 3),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7),
                                            child: Text(
                                                widget
                                                    .timeStatus["displayName"],
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Text(
                                              DateFormat("dd MMM, yyyy")
                                                  .format(DateTime.now()),
                                              style: const TextStyle(
                                                  color: purpleDark,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //--------------------------//
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.redAccent,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Absent",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ),
                                  ),
                                ])),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 55,
                                          child: ClipRRect(
                                            clipBehavior: Clip.antiAlias,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image(
                                              image: NetworkImage(widget
                                                  .timeStatus!["imagePath"]),
                                              // FileImage(File(imagePath)),

                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 3),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 7),
                                                child: Text(
                                                    widget.timeStatus[
                                                        "displayName"],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Text(
                                                  snapshotxx.data!.docs[0]
                                                      ['date'],
                                                  style: const TextStyle(
                                                      color: purpleDark,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //--------------------------//
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: snapshotxx.data!.docs[0]
                                                            ["late"] ==
                                                        "0 hrs & 0 mins"
                                                    ? lightGreen
                                                    : purpleDark,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  snapshotxx.data!.docs[0]
                                                              ["late"] ==
                                                          "0 hrs & 0 mins"
                                                      ? "On Time"
                                                      : " Late  ",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: snapshotxx.data!
                                                                      .docs[0]
                                                                  ["late"] ==
                                                              "0 hrs & 0 mins"
                                                          ? Colors.black
                                                          : Colors.white),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ])),
                            const SizedBox(height: 20),
                            //==============================//
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Checkin: ',
                                              style: const TextStyle(
                                                  color: purpleDark)),
                                          Text(DateFormat('K:mm a dd-MMM-yy')
                                              .format(snapshotxx
                                                  .data!.docs[0]["checkin"]
                                                  .toDate())),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Checkout: ',
                                              style: const TextStyle(
                                                  color: purpleDark)),
                                          Text(snapshotxx.data!.docs[0]
                                                      ['checkout'] ==
                                                  null
                                              ? "- - - - "
                                              : DateFormat('K:mm a dd-MMM-yy')
                                                  .format(snapshotxx.data!
                                                      .docs[0]['checkout'])),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                            const SizedBox(height: 20),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(snapshotxx.data!.docs[0]
                                          ["checkout"] !=
                                      null
                                  ? 'Total Working Hours: ${snapshotxx.data!.docs[0]["workHours"]}'
                                  : "Total Working Hours: ${((DateTime.now().difference(snapshotxx.data!.docs[0]["checkin"].toDate()).inSeconds) / 3600).toInt()} : ${(((DateTime.now().difference(snapshotxx.data!.docs[0]["checkin"].toDate()).inSeconds) % 3600) / 60).toInt()}"),
                            )
                          ],
                        );
                } else if (!snapshotxx.hasData) {
                  return const Text("No Data Found");
                }

                return Container();
              }),
        ),
      ),
    );
  }
}
