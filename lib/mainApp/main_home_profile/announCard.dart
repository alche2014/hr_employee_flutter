// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/main_home_profile/read_one_announcement.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AnnHomeCard extends StatefulWidget {
  final text1;
  final text2;
  final date;

  AnnHomeCard(this.text1, this.text2, this.date, {Key? key}) : super(key: key);

  @override
  State<AnnHomeCard> createState() => _AnnHomeCardState();
}

class _AnnHomeCardState extends State<AnnHomeCard> {
  int myMaxLines = 3;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: isdarkmode.value ? Colors.transparent : Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ReadMoreAnnouncement(
                    head: widget.text1.toString(),
                    body: widget.text2.toString(),
                    date: DateFormat.jm()
                        .add_yMd()
                        .format(
                            DateTime.parse(widget.date!.toDate().toString()))
                        .toString(),
                  )));
        },
        child: Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          width: MediaQuery.of(context).size.width / 1.13,
          padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            border: Border.all(
              width: 0.0,
              // assign the color to the border color
              color: Colors.grey,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text(
                  widget.text1!,
                  style: TextStyle(
                    color: purpleDark, //color red
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Text(
                  widget.text2!,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  DateFormat.jm()
                      .add_yMd()
                      .format(DateTime.parse(widget.date!.toDate().toString())),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
