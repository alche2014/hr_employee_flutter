import 'package:flutter/material.dart';
import '../../../colors.dart';

// ignore: must_be_immutable
class LeaveHistoryCard extends StatelessWidget {

  String header;
  String bodyContent;
  String value;

  LeaveHistoryCard(this.header, this.bodyContent, this.value, {Key? key}) : super(key: key);

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
                    header,
                    style: TextStyle(
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? darkredForWhite
                          : lightRedForDark, //color red
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: value == 'apd' ? lightGreen : lightPink,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: value == 'apd' ? const Text('Approved',textAlign: TextAlign.center) : const Text('Pending',textAlign: TextAlign.center),
                        )),
                ],
              ),
              SizedBox(height: 20.0),
              if(bodyContent.isNotEmpty)
                Text(
                  '$bodyContent',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              SizedBox(height: 30),
              Text(
                '14:01 20/10/2020',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
