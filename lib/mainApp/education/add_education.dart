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
      appBar: buildMyAppBar(context, 'Add Education', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          SingleChildScrollView(
            child: Column(
              children: const [
                SizedBox(height: 50),
                AddEducationBody(),
              ],
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
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade300.withOpacity(0.8),
                  width: 2,
                ),
              ),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
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
          const SizedBox(height: 15),
          //-------------------------------------------------//
          Row(children: [
            Expanded(
                child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.shade300.withOpacity(0.8), width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Start Birth',
                      style: TextStyle(color: Colors.grey)),
                  IconButton(
                      icon: const Icon(Icons.today, color: Colors.grey),
                      onPressed: () {
                        showDatePicker(
                            context: context,
                            initialDate: DateTime(2005),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now());
                      })
                ],
              ),
            )),
            SizedBox(width: 10),
            Expanded(
                child: Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.shade300.withOpacity(0.8), width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('End Birth', style: TextStyle(color: Colors.grey)),
                  IconButton(
                      icon: Icon(Icons.today, color: Colors.grey),
                      onPressed: () {
                        showDatePicker(
                            context: context,
                            initialDate: DateTime(2005),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now());
                      }),
                ],
              ),
            )),
          ]),
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
