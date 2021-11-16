// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:hr_app/colors.dart';

final darkRed = Color(0xffbf2634);

class AnnHomeCard extends StatefulWidget {
  final String head;
  final String body;
  final String date;
  AnnHomeCard(this.head, this.body, this.date, {Key? key}) : super(key: key);

  @override
  State<AnnHomeCard> createState() => _AnnHomeCardState();
}

class _AnnHomeCardState extends State<AnnHomeCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        color: MediaQuery.of(context).platformBrightness == Brightness.light
            ? Colors.white
            : Color(0xff34354A),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          // margin: EdgeInsets.all(20),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${widget.head}',
                style: TextStyle(
                  color: darkRed, //color red
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              RichText(
              // maxLines: 3,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  
                ),
                children:  <TextSpan>[
                  TextSpan(
                text: widget.body,
                style: TextStyle(
                  fontSize: 15,
                  color: MediaQuery.of(context).platformBrightness == Brightness.light
            ? Colors.black
            : Colors.grey,
                ),),
                  TextSpan(text: ' Readmore', style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryRed)),
                  // TextSpan(text: ' world!'),
                ],
                ),
              ),
              // Text(
              //   widget.body,
              //   // maxLines: 3,
              //   style: TextStyle(
              //     fontSize: 15,
              //     // overflow: TextOverflow.ellipsis,
              //   ),
              // ),
              SizedBox(height: 50),
              Text(
                '${widget.date}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
