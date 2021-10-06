// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_declarations, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/skills/main_skill.dart';
import 'package:hr_app/mainApp/work_info/utility/build_my_input_decoration.dart';

import '../../colors.dart';

class AddEducation extends StatelessWidget {
  const AddEducation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: buildMyAppBar(context, 'Add Education', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              buildMyNewAppBar(context, 'Add Education', true),
            ],
          body: SingleChildScrollView(
            child: Column(
              children: const [
                AddEducationBody(),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddEducationBody extends StatefulWidget {
  const AddEducationBody({Key? key}) : super(key: key);

  @override
  _AddEducationBodyState createState() => _AddEducationBodyState();
}

class _AddEducationBodyState extends State<AddEducationBody> {
  var dropGenderValue;
  var checkedValue = false;
  var startDate;
  var endDate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Form(
          child: Column(
        children: [
          TextFormField(
            decoration: buildMyInputDecoration(context, 'School'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              final pattern = ('[a-zA-Z]+([\s][a-zA-Z]+)*');
              final regExp = RegExp(pattern);
              if (value!.isEmpty) {
                return null;
              } else if (!regExp.hasMatch(value)) {
                return 'Enter only Alphabets';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 15),
          //-------------------------------------------------//
          SizedBox(
            height: 62,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.grey.shade300.withOpacity(0.8),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                      ),
                      hintText: "Degree",
                      fillColor: Theme.of(context).scaffoldBackgroundColor),
                  value: dropGenderValue,
                  items: <String>['Permanent', 'Temporary']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropGenderValue = value;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          //-------------------------------------------------//
          TextFormField(
            decoration: buildMyInputDecoration(context, 'Field of study'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              final pattern = ('[a-zA-Z]+([\s][a-zA-Z]+)*');
              final regExp = RegExp(pattern);
              if (value!.isEmpty) {
                return null;
              } else if (!regExp.hasMatch(value)) {
                return 'Enter only Alphabets';
              } else {
                return null;
              }
            },
          ),
          //-------------------------------------------------//
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(children: [
              Expanded(
                  child: Container(
                height: 60,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade300.withOpacity(0.8), width: 2),
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(startDate == null
                            ? 'Start Birth'
                            : '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                                .toString(),
                                style: TextStyle(color: Colors.grey),),
                    ),
                    IconButton(
                        icon: Icon(Icons.today, color: Colors.grey),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2022))
                              .then((value) {
                            setState(() {
                              startDate = value;
                            });
                          });
                        })
                  ],
                ),
              )),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                height: 60,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade300.withOpacity(0.8), width: 2),
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(endDate == null
                            ? 'End Birth'
                            : '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                                .toString(),
                                style: TextStyle(color: Colors.grey),),
                    ),
                    IconButton(
                        icon: Icon(Icons.today, color: Colors.grey),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2022))
                              .then((value) {
                            setState(() {
                              endDate = value;
                            });
                          });
                        })
                  ],
                ),
              )),
            ]),
          ),
          const SizedBox(height: 5),
          //--------------------------------------------------//
          TextFormField(
            decoration: buildMyInputDecoration(context, 'Grade'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              final pattern = ('[a-zA-Z]+([\s][a-zA-Z]+)*');
              final regExp = RegExp(pattern);
              if (value!.isEmpty) {
                return null;
              } else if (!regExp.hasMatch(value)) {
                return 'Enter only Alphabets';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 15),
          //-------------------------------------------------//
          TextFormField(
            decoration:
                buildMyInputDecoration(context, 'Activities & Societies'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              final pattern = ('[a-zA-Z]+([\s][a-zA-Z]+)*');
              final regExp = RegExp(pattern);
              if (value!.isEmpty) {
                return null;
              } else if (!regExp.hasMatch(value)) {
                return 'Enter only Alphabets';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 15),
          //-------------------------------------------------//
          TextFormField(
            maxLines: 5,
            decoration: buildMyInputDecoration(context, 'Description'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              final pattern = ('[a-zA-Z]+([\s][a-zA-Z]+)*');
              final regExp = RegExp(pattern);
              if (value!.isEmpty) {
                return null;
              } else if (!regExp.hasMatch(value)) {
                return 'Enter only Alphabets';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 30),
          //===============================================//
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    child: const Text('SAVE'), //next button
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      primary: darkRed,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MainSkills()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
