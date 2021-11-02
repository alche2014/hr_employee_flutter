// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:hr_app/colors.dart';
import 'package:hr_app/mainApp/main_home_profile/utility/content/list_of_data.dart';

final darkRed = Color(0xffbf2634);

class AnnCard extends StatefulWidget {
  // final String head;
  // final String body;
  // final String date;

  MyAnnCard myAnnCard = MyAnnCard();

  AnnCard(this.myAnnCard, {Key? key}) : super(key: key);

  @override
  State<AnnCard> createState() => _AnnCardState();
}

class _AnnCardState extends State<AnnCard> {
  int myMaxLines = 3;
  bool isExpaneded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        height: isExpaneded == true ? null : widget.myAnnCard.body!.length > 140 ? 225 : 165,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.myAnnCard.head!,
              style: TextStyle(
                color: darkRed, //color red
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(isExpaneded != true)
                Text(
                  widget.myAnnCard.body!,
                  maxLines: myMaxLines,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if(isExpaneded == true)
                Text(
                  widget.myAnnCard.body!,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 15,
                  ),
                ),
                if (widget.myAnnCard.body!.length > 140)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpaneded = !isExpaneded;
                        });
                      },
                      child: Text(
                        isExpaneded != true ? 'Readmore!' : 'Readless!',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryRed),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
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
    );
  }
}
