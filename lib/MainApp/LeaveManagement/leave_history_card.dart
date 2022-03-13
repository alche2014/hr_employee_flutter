import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class LeaveHistoryCard extends StatelessWidget {
  final bodyContent;

  const LeaveHistoryCard(this.bodyContent, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      height: 30,
                      child: RichText(
                        text: TextSpan(
                          text: bodyContent["leaveType"],
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: " Applied from " +
                                    bodyContent["from-to-date"]
                                        .replaceAll("-", "to"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        DateFormat.jm()
                            .add_yMd()
                            .format(DateTime.parse(
                                bodyContent["timeStamp"].toDate().toString()))
                            .toString(),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                    decoration: BoxDecoration(
                        color: bodyContent['leaveStatus'] == 'approved'
                            ? Colors.green
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1.0,
                          color: bodyContent['leaveStatus'] == 'approved'
                              ? Colors.green
                              : Colors.grey.shade300,
                        )),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          bodyContent['leaveStatus'].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: bodyContent['leaveStatus'] == 'approved'
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: 12),
                        ))),
              ),
            ],
          ),
          SizedBox(height: bodyContent['reason'] == "" ? 1 : 15.0),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              bodyContent['reason'],
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            margin: const EdgeInsets.only(left: 10, right: 10),
            color: Colors.grey.shade300,
          )
        ],
      ),
    );
  }
}
