// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_const_constructors_in_immutables, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/appbar.dart';

import 'package:hr_app/Constants/colors.dart';

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
      appBar: buildMyAppBar(context, 'Announcements', false),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Container(
                  padding: Platform.isIOS
                      ? const EdgeInsets.only(bottom: 50, top: 110)
                      : const EdgeInsets.only(bottom: 15, top: 80),
                  child: _ReadMoreAnnCard(head: head, body: body, date: date))),
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.head,
              style: TextStyle(
                color: purpleDark, //color red
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 14),
            Text(
              widget.body,
              style: TextStyle(fontSize: 14, height: 1.5
                  // letterSpacing: 1.5
                  ),
            ),
            SizedBox(height: 15),
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
