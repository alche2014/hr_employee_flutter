// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:hr_app/colors.dart';

final darkRed = Color(0xffbf2634);

class AnnCard extends StatelessWidget {
  final String head;
  final String body;
  final String date;
  AnnCard(this.head, this.body, this.date, {Key? key}) : super(key: key);

  //reuse but with changing
  @override
  Widget build(BuildContext context) {
    int myMaxLines = 3;
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
              head,
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
                  body,
                  maxLines: myMaxLines,
                  style: TextStyle(
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (body.length > 80)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      onTap: () {},
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
              date,
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
