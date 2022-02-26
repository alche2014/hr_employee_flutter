// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/main.dart';

import '../main_skill.dart';

class SkillsCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const SkillsCard({Key? key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Skills',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: purpleDark)),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainSkills(data: data)));
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
          data['skills'] == null
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "No Skills added yet",
                      style: TextStyle(
                          color: isdarkmode.value == false
                              ? Colors.grey[700]
                              : Colors.grey[500],
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                  ),
                )
              : data['skills'] != null && data['skills'].length == 0
                  ? Center(
                      child: Text(
                      "No Skills added yet",
                      style: TextStyle(
                          color: isdarkmode.value == false
                              ? Colors.grey[700]
                              : Colors.grey[500],
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ))
                  : Container(
                      padding:
                          const EdgeInsets.only(left: 7, right: 7, top: 10),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: data['skills'] != null
                              ? data['skills'].length
                              : 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Wrap(
                                spacing: 10.0,
                                direction: Axis.horizontal,
                                runSpacing: 20.0,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          data['skills'] == null
                                              ? "No Skills added Yet"
                                              : data['skills'][index],
                                          style: TextStyle(
                                              color: isdarkmode.value == false
                                                  ? Colors.grey[700]
                                                  : Colors.grey[500],
                                              fontFamily: "Sofia Pro",
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ]);
                          }),
                    ),
        ],
      ),
    );
  }
}
