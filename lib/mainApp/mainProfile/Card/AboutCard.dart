// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/mainProfile/add_about.dart';

import '../../../colors.dart';

class AboutCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const AboutCard({Key? key, this.data}) : super(key: key);

  @override
  _AboutCardState createState() => _AboutCardState();
}

class _AboutCardState extends State<AboutCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
              color: isdarkmode.value == false
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.white,
              width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('About',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        color: darkRed)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAboutScreen(
                                    title: widget.data,
                                  )));
                    },
                    icon: Icon(Icons.edit_outlined,
                        color: isdarkmode.value == false
                            ? const Color(0xff34354A)
                            : Colors.grey[500])),
              ]),
              Container(
                margin: const EdgeInsets.only(right: 25),
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
              // Text(bodyText),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
