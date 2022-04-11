import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckInCard extends StatefulWidget {
  final timeStatus, index, day, a;
  CheckInCard(this.timeStatus, this.index, this.day, this.a, {Key? key})
      : super(key: key);

  @override
  State<CheckInCard> createState() => _CheckInCardState();
}

class _CheckInCardState extends State<CheckInCard> {
  // late Timestamp timestamp = widget.timeStatus['checkin'] as Timestamp;

  // late DateTime dateTime = timestamp.toDate();

  // late Timestamp timestamp2 = widget.timeStatus['checkout'] as Timestamp;

  // late DateTime dateTime2 = timestamp2.toDate();
  @override
  void initState() {
    if (DateFormat('EEE')
                .format(DateFormat('dd MMMM yyyy')
                    .parse("${widget.index + 1} ${widget.day}"))
                .toUpperCase() ==
            "SAT" ||
        DateFormat('EEE')
                .format(DateFormat('dd MMMM yyyy')
                    .parse("${widget.index + 1} ${widget.day}"))
                .toUpperCase() ==
            "SUN") {
      widget.a + 1;
      print(widget.a);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    Text("${widget.index + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                    const SizedBox(height: 2),
                    Text(
                        DateFormat('EEE')
                            .format(DateFormat('dd MMMM yyyy')
                                .parse("${widget.index + 1} ${widget.day}"))
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
                                  .format(DateFormat('dd MMMM yyyy').parse(
                                      "${widget.index + 1} ${widget.day}"))
                                  .toUpperCase() ==
                              "SAT" ||
                          DateFormat('EEE')
                                  .format(DateFormat('dd MMMM yyyy').parse(
                                      "${widget.index + 1} ${widget.day}"))
                                  .toUpperCase() ==
                              "SUN"
                      ? Text("Weekend")
                      : Text(
                          widget.timeStatus[0]['date']
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
