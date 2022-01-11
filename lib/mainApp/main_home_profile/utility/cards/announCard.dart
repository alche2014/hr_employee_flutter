// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:hr_app/colors.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/Components/model.dart';
import 'package:hr_app/mainUtility/read_more/read_more_page.dart';
import 'package:intl/intl.dart';

final darkRed = Color(0xffbf2634);

// ignore: must_be_immutable
class AnnHomeCard extends StatefulWidget {
  MyAnnouncement myAnnCard = MyAnnouncement();

  AnnHomeCard(this.myAnnCard, {Key? key}) : super(key: key);

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
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 7),
        width: MediaQuery.of(context).size.width / 1.13,
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 30, right: 7),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.myAnnCard.text1!,
              style: TextStyle(
                color: darkRed, //color red
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            Text(
              widget.myAnnCard.text2!,
              maxLines: myMaxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            if (widget.myAnnCard.text2!.length > 80)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReadMoreAnnouncement(
                              head: widget.myAnnCard.text1.toString(),
                              body: widget.myAnnCard.text2.toString(),
                              date: DateFormat.jm()
                                  .add_yMd()
                                  .format(DateTime.parse(widget.myAnnCard.date!
                                      .toDate()
                                      .toString()))
                                  .toString(),
                            )));
                  },
                  child: Text(
                    'Read more!',
                    // maxLines: 3,
                    style: TextStyle(
                        fontSize: 15,
                        // overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryRed),
                  ),
                ),
              ),
            // SizedBox(height: 50),
            Text(
              DateFormat.jm().add_yMd().format(
                  DateTime.parse(widget.myAnnCard.date!.toDate().toString())),
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
