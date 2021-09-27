import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/dependent/main_dependent.dart';
import 'package:hr_app/mainApp/skills/utility/chips.dart';

class MainSkills extends StatefulWidget {
  const MainSkills({Key? key}) : super(key: key);

  @override
  State<MainSkills> createState() => _MainSkillsState();
}

class _MainSkillsState extends State<MainSkills> {
  @override
  Widget build(BuildContext context) {
    var dropdownValue;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Skills', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.4), width: 1),
                        borderRadius: BorderRadius.circular(10),
                        // color: MediaQuery.of(context).platformBrightness ==
                        //         Brightness.light
                        //     ? Colors.grey[100]
                        //     : Color(0xff34354A),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            elevation: 0,
                            isExpanded: true,
                            hint: const Text('Skills'
                                // style: TextStyle(color: Colors.grey),
                                ),
                            onChanged: (String? newValue) {
                              setState(() {
                                if (Chips.chipList.length <= 6) {
                                  Chips.chipList.add(newValue.toString());
                                }
                                // dropdownValue = newValue;
                              });
                            },
                            items: <String>[
                              'Adobe PhotoShop',
                              'Adobe XD',
                              'Figma'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Chips.chipList.isNotEmpty ? Chips() : null,
                  ),
                  const SizedBox(height: 20),
                ]),
                //===========================================//
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            child: const Text('SAVE'), //next button
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              primary: Color(0xffC53B4B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainDependent()));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
