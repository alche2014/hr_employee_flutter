import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TeamCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: MediaQuery.of(context).platformBrightness ==
                  Brightness.light
                  ? Colors.white
                  : Color(0xff34354A),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 30),
                    Text(
                      'Today Detail',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red[700]),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Absents',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('On Time',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('Late',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('12',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue[300])),
                    Text('10',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green[300])),
                    Text('02',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red[700])),
                  ],
                ),
                SizedBox(height: 30),
                FittedBox(
                  child: Stack(
                    children: [
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width *0.9,
                        lineHeight: 15.0,
                        percent: 0.9,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.red[700],
                      ),
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width*0.9,
                        lineHeight: 15.0,
                        percent: 0.7,
                        backgroundColor: Colors.transparent,
                        progressColor: Colors.green[300],
                      ),
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width*0.9,
                        lineHeight: 15.0,
                        percent: 0.2,
                        backgroundColor: Colors.transparent,
                        progressColor: Colors.blue[300],
                      ),
                    ],
                  ),
                )
              ],
            ),
            //------------Bar------------//
      ),
    );
  }
}
