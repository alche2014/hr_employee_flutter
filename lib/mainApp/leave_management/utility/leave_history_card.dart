import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../colors.dart';

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
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bodyContent["leaveType"],
                    style: TextStyle(
                      color: darkredForWhite, //color red
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
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
                          child: Text(bodyContent['leaveStatus'])
                          //== 'approved'
                          // ? const Text('Approved',
                          //     textAlign: TextAlign.center)
                          // : const Text('Pending',
                          //     textAlign: TextAlign.center),
                          )),
                ],
              ),
              const SizedBox(height: 20.0),

              Text(
                bodyContent['reason'],
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                DateFormat.jm().add_yMd().format(
                    DateTime.parse(bodyContent['timeStamp'].toString())),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
