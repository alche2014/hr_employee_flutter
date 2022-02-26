// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/main.dart';

import '../AddAbout.dart';

class AboutCard extends StatefulWidget {
  final data;
  const AboutCard({Key? key, this.data}) : super(key: key);

  @override
  _AboutCardState createState() => _AboutCardState();
}

class _AboutCardState extends State<AboutCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('About Me',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: purpleDark)),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddAboutScreen(
                                title: widget.data,
                              )));
                },
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.centerRight,
                  child: const Text('Edit',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w400)),
                )),
          ]),
          Container(
            margin: const EdgeInsets.only(right: 15, top: 10),
            child: Text(
              widget.data["aboutYou"] ?? "Not added yet",
              style: TextStyle(
                  color: isdarkmode.value == false
                      ? Colors.grey[700]
                      : Colors.grey[500],
                  fontWeight: FontWeight.w400,
                  fontFamily: "Sofia Pro",
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
