// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/mainApp/skills/main_skill.dart';

import '../../../colors.dart';

class SkillsCard extends StatelessWidget {
  final data;
  const SkillsCard({
    Key? key,
    this.data,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var skillsDocument = data;

    var skills = skillsDocument['skills'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Skills',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: darkRed)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainSkills(data: data)));
                    },
                    icon: const Icon(Icons.edit_outlined, color: Colors.grey)),
              ]),

              skills == null
                  ? Center(
                      child: Text(
                        "No skills added yet",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                    )
                  : skills != null && skills.length == 0
                      ? Center(
                          child: Text(
                          "No skills added yet",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ))
                      :

                      //             Column(children: [
                      //   Row(children: [
                      //     SizedBox(height: 40, child: Image.asset('assets/Logo.png')),
                      //     const SizedBox(width: 20),
                      //     Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: const [
                      //           Text(
                      //             'UI UX Designerrrrr',
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //           Text('Alchemative - Full time'),
                      //           Text('Mar 2020 - Present 1yr 7 mos'),
                      //         ]),
                      //   ]),
                      //   const SizedBox(height: 20),
                      //   //===============================================//
                      //   Row(children: [
                      //     SizedBox(
                      //         height: 40, child: Image.asset('assets/picBack.png')),
                      //     const SizedBox(width: 20),
                      //     Expanded(
                      //       flex: 1,
                      //       child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: const [
                      //             Text(
                      //               'Web UI & UX Designer at Technology Wisdom',
                      //               style: TextStyle(fontWeight: FontWeight.bold),
                      //             ),
                      //             const SizedBox(height: 2),
                      //             Text('Technology Wisdom - Full time'),
                      //             Text('Feb 2018 – Feb 2020 2 yrs 1 mos'),
                      //           ]),
                      //     ),
                      //   ]),
                      //   const SizedBox(height: 20),
                      //   //==================================================//
                      //   Row(children: [
                      //     SizedBox(
                      //         height: 40, child: Image.asset('assets/picBack.png')),
                      //     const SizedBox(width: 20),
                      //     Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: const [
                      //           Text(
                      //             'Graphic Web Designer',
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //           Text('Computer Xperts - Full time'),
                      //           Text('Mar 2016 – Feb 20182 yrs'),
                      //         ]),
                      //   ]),
                      // ]),
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: skills != null ? skills.length : 0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      skills == null
                                          ? "No Skills added Yet"
                                          : skills[index],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),

              // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //   Text('Adobe Illustrator'),
              //   Text('Rectangle'),
              // ]),
              // const SizedBox(height: 6),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //   Text('Adobe Photoshop'),
              //   Text('Graphic Design'),
              // ]),
              // const SizedBox(height: 6),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //   Text('Page Layout'),
              //   Text('Branding'),
              // ]),
              // const SizedBox(height: 6),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //   Text('Figma'),
              //   Text(''),
              // ]),
              // const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
