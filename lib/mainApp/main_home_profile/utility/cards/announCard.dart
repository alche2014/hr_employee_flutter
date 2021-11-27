// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:hr_app/colors.dart';
import 'package:hr_app/mainApp/main_home_profile/utility/content/list_of_data.dart';
import 'package:hr_app/mainApp/main_home_profile/utility/read_more/read_more_page.dart';

final darkRed = Color(0xffbf2634);

// ignore: must_be_immutable
class AnnHomeCard extends StatefulWidget {
  // final String head;
  // final String body;
  // final String date;
  MyAnnCard myAnnCard = MyAnnCard();

  AnnHomeCard(this.myAnnCard, {Key? key}) : super(key: key);

  @override
  State<AnnHomeCard> createState() => _AnnHomeCardState();
}

class _AnnHomeCardState extends State<AnnHomeCard> {
  int myMaxLines = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 10),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: MediaQuery.of(context).platformBrightness == Brightness.light
            ? Colors.white
            : Color(0xff34354A),
        child: Container(
          width: 320,
          // margin: EdgeInsets.all(20),
          padding: EdgeInsets.only(left: 15, top: 20, bottom: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.myAnnCard.head!,
                style: TextStyle(
                  color: darkRed, //color red
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.myAnnCard.body!,
                    maxLines: myMaxLines,
                    style: TextStyle(
                      fontSize: 15,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.myAnnCard.body!.length > 80)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReadMoreAnnouncement(
                                  head: widget.myAnnCard.head,
                                  body: widget.myAnnCard.body,
                                  date: widget.myAnnCard.date)));
                        },
                        child: Text(
                          'Readmore!',
                          // maxLines: 3,
                          style: TextStyle(
                              fontSize: 15,
                              // overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryRed),
                        ),
                      ),
                    ),
                ],
              ),
              // SizedBox(height: 50),
              Text(
                widget.myAnnCard.date!,
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
