import 'package:flutter/material.dart';

import '../../../colors.dart';

class CheckInCard extends StatelessWidget {
  final String timeStatus;
  CheckInCard(this.timeStatus);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        elevation: 3,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        //========================================//
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            //========================================//
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.white
                : Color(0xff34354A),
          ),
          //=======================================//
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //==============================//
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('02-05-2021 Thu',
                      style:
                          TextStyle(color: darkRed, fontWeight: FontWeight.bold)),
                  //--------------------------//
                  Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightGreen,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          timeStatus,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                ]),
              ),
              SizedBox(height: 20 ),
              //==============================//
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Checkin: 09:20 am'),
                //--------------------------//
                  Text('Checkout: 06:00 am'),
                ]),
              ),
              SizedBox(height: 20 ),
              //==============================//
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Total Working Hours: 8hr 20min'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
