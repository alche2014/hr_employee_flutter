// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_string_escapes, prefer_const_declarations, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/work_info/utility/build_my_input_decoration.dart';

import '../../colors.dart';

class AddExperience extends StatelessWidget {
  const AddExperience({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: buildMyAppBar(context, 'Add Experience', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              buildMyNewAppBar(context, 'Add Experience', true),
            ],
          body: SingleChildScrollView(
            child: Column(
              children: const [
                AddExperienceBody(),
              ],
            ),
          ),),
        ],
      ),
    );
  }
}

class AddExperienceBody extends StatefulWidget {
  const AddExperienceBody({Key? key}) : super(key: key);

  @override
  _AddExperienceBodyState createState() => _AddExperienceBodyState();
}

class _AddExperienceBodyState extends State<AddExperienceBody> {
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
            decoration: buildMyInputDecoration(context, 'Title'),
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
          Container(
            height: 60,
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
                    hintText: "Employment Status",
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
            decoration: buildMyInputDecoration(context, 'Company Name'),
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
            decoration: buildMyInputDecoration(context, 'Location'),
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
          const SizedBox(height: 8),
          //-------------------------------------------------//
          Row(children: [
         Checkbox(
              value: checkedValue,
              activeColor: const Color(0xff61C1D1),
              onChanged: (newValue) {
                setState(() {
                  checkedValue = newValue!;
                });
              },
            ),
            Text('I am currently working in this role'),
          ]),
          //--------------------------------------------------//
          Padding(
            padding: const EdgeInsets.symmetric(vertical:10 ),
            child: Row(children: [
              Expanded(
                  child: Container(
                height: 60,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade300.withOpacity(0.8), width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text('Start Birth',
                          style: TextStyle(color: Colors.grey)),
                    ),
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
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade300.withOpacity(0.8), width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('End Birth', style: TextStyle(color: Colors.grey)),
                    ),
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
          ),
          const SizedBox(height: 5),
          //--------------------------------------------------//
          TextFormField(
            decoration: buildMyInputDecoration(context, 'Headline'),
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
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.grey.shade300.withOpacity(0.8),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                      ),
                      hintText: "Industry",
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
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => NavBar(0)));
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
