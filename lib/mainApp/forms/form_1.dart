// ignore_for_file: prefer_const_declarations, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:hr_app/mainApp/bottom_navigation/bottom_nav_bar.dart';
import 'package:hr_app/mainUtility/text_input_design.dart';

import '../../colors.dart';

enum Gender { male, female }

class FormOne extends StatefulWidget {
  const FormOne({Key? key}) : super(key: key);

  @override
  _FormOneState createState() => _FormOneState();
}

class _FormOneState extends State<FormOne> {
  // ignore: prefer_typing_uninitialized_variables
  var gender;
  var dateOfBirth;
  var dropdownValue;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset("assets/Logo.png"),
                ),
              ),
              //-------------------------------------------------//
              const SizedBox(height: 25),
              TextFormField(
                decoration: MyInputStyle('Your Name'),
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
                decoration: MyInputStyle('Father Name'),
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
                decoration: MyInputStyle('Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  final pattern =
                      (r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
                  final regExp = RegExp(pattern);

                  if (value!.isEmpty) {
                    return null;
                  } else if (value.contains(' ')) {
                    return 'can not have blank spaces';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Enter a valid email';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),
              //-------------------------------------------------//
              TextFormField(
                decoration: MyInputStyle('Phone'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final regExp = RegExp('[0-9]');
                  if (value!.isEmpty) {
                    return null;
                  } else if (!regExp.hasMatch(value)) {
                    return 'Enter only number';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),
              //-------------------------------------------------//
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 0,
                    isExpanded: true,
                    hint: const Text('Marital status',
                        style: TextStyle(color: Colors.grey)),
                    onChanged: (String? newValue) {
                      //   setState(() {
                      //     dropdownValue = newValue;
                      //   });
                    },
                    items: <String>['Single', 'Married']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //-------------------------------------------------//
              Container(
              height: 60,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300.withOpacity(0.8),
                    width: 2,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateOfBirth == null
                        ? 'Date of Birth'
                        : '${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}'
                            .toString(),
                            style: const TextStyle(color: Colors.grey),
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
                            dateOfBirth = value;
                          });
                        });
                      }),
                ],
              ),
            ),
              //-------------------------------------------------//
              Row(
                children: [
                  Row(
                    children: [
                      Radio<Gender>(
                        activeColor: darkRed,
                        value: Gender.male,
                        groupValue: gender,
                        onChanged: (Gender? value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      const Text('Male'),
                    ],
                  ),
                  //===================//
                  Row(
                    children: [
                      Radio<Gender>(
                        activeColor: darkRed,
                        value: Gender.female,
                        groupValue: gender,
                        onChanged: (Gender? value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      const Text('Female'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              //=============================//
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        child: const Text('Done'), //next button
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          primary: darkRed,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NavBar(0)));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//===================================================//
