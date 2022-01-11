// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/skills/main_skill.dart';
import '../../../colors.dart';

class SkillsCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const SkillsCard({Key? key, this.data}) : super(key: key);

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
                const Text('Skills',
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
                              builder: (context) => MainSkills(data: data)));
                    },
                    icon: Icon(Icons.edit_outlined,
                        color: isdarkmode.value == false
                            ? const Color(0xff34354A)
                            : Colors.grey[500])),
              ]),
              data['skills'] == null
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "No skills added yet",
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
                          "No skills added yet",
                          style: TextStyle(
                              color: isdarkmode.value == false
                                  ? Colors.grey[700]
                                  : Colors.grey[500],
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ))
                      : ListView.builder(
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
            ],
          ),
        ),
      ),
    );
  }
}
