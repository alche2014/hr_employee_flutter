import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class LeaveHistoryCard extends StatelessWidget {
  // String header;
  final bodyContent;
  // String value;

  const LeaveHistoryCard(this.bodyContent, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Colors.grey.shade300, width: 1)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bodyContent["leaveType"],
                        style: TextStyle(
                          color: purpleLight, //color red
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat.jm()
                            .add_yMd()
                            .format(DateTime.parse(
                                bodyContent["timeStamp"].toDate().toString()))
                            .toString(),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: bodyContent['leaveStatus'] == 'approved'
                            ? lightGreen
                            : lightPink,
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text(bodyContent['leaveStatus'].toUpperCase()))),
                ],
              ),
              const SizedBox(height: 15.0),

              Text(
                bodyContent['reason'],
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Applied Dates: " + bodyContent["from-to-date"],
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
