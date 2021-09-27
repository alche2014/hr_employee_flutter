import 'package:flutter/material.dart';
import '../../../../colors.dart';

// ignore: must_be_immutable
class HomeEventCard extends StatelessWidget {
  String date;
  String month;
  String head;
  String timeDate;
  String pic;
  HomeEventCard(this.date, this.month, this.head, this.timeDate, this.pic);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: MediaQuery.of(context).platformBrightness == Brightness.light
            ? Colors.white
            : Color(0xff34354A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Image(
                    image: AssetImage('assets/images/$pic.png'),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$date',
                          style: TextStyle(fontSize: 35),
                        ),
                        Text('$month',
                            style: TextStyle(
                                color: darkRed,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)), //color red
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$head',
                          style: TextStyle(
                            fontSize: 16,
                            color: darkRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ), //color red
                        SizedBox(height: 10),
                        Text('$timeDate', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
