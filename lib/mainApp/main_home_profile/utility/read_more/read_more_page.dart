// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_const_constructors_in_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/colors.dart';

class ReadMoreAnnouncement extends StatelessWidget {
  ReadMoreAnnouncement(
      {required this.head, required this.body, required this.date, Key? key})
      : super(key: key);
  var body;
  var date;
  var head;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const BackgroundCircle(),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              buildMyNewAppBar(context, 'Announcement', true),
            ],
            body: Column(children: [
              _ReadMoreAnnCard(head: head, body: body, date: date)
            ]),
          ),
        ],
      ),
    );
  }
}

//===============================================//

class _ReadMoreAnnCard extends StatefulWidget {
  final String head;
  final String body;
  final String date;
  _ReadMoreAnnCard(
      {required this.head, required this.body, required this.date, Key? key})
      : super(key: key);

  @override
  State<_ReadMoreAnnCard> createState() => _ReadMoreAnnCardState();
}

class _ReadMoreAnnCardState extends State<_ReadMoreAnnCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.head,
              style: TextStyle(
                color: darkRed, //color red
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.body,
              style: TextStyle(
                fontSize: 15,
                height: 1.5
                // letterSpacing: 1.5
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.date,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
