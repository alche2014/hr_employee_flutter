// ignore_for_file: prefer_const_declarations, duplicate_ignore, prefer_typing_uninitialized_variables, prefer_const_constructors, unnecessary_new, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:hr_app/mainApp/bottom_navigation/bottom_nav_bar.dart';
import 'package:hr_app/mainUtility/text_input_design.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../colors.dart';

enum Gender { male, female }

class FormOne extends StatefulWidget {
  const FormOne({Key? key}) : super(key: key);

  @override
  _FormOneState createState() => _FormOneState();
}

class _FormOneState extends State<FormOne> {
  // ignore: prefer_typing_uninitialized_variables
  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();
  TextEditingController _controller3 = new TextEditingController();
  TextEditingController _controller4 = new TextEditingController();
  TextEditingController _controller5 = new TextEditingController();

  final maskFormatter = MaskTextInputFormatter(mask: '+92 ### ### ####');
  var gender;
  var dateOfBirth;
  var _dropdownValue;
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
                controller: _controller1,
                textInputAction: TextInputAction.next,
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
                controller: _controller2,
                textInputAction: TextInputAction.next,
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
                                controller: _controller3,
                textInputAction: TextInputAction.next,
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
                controller: _controller4,
                textInputAction: TextInputAction.next,
                decoration: MyInputStyle('Phone'),
                keyboardType: TextInputType.number,
                inputFormatters: [maskFormatter],
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
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.4), 
                    width: 1,
                  ),
                ),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                      ),
                      hintText: "Material Status",
                      prefixStyle: TextStyle(color: Colors.grey),
                      fillColor: Theme.of(context).scaffoldBackgroundColor),
                  value: _dropdownValue,
                  items: <String>['Single', 'Married']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _dropdownValue = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              //-------------------------------------------------//
              Container(
                height: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.4), width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        dateOfBirth == null
                            ? 'Date of Birth'
                            : '${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}'
                                .toString(),
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.today, color: Colors.grey),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2010),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2021))
                              .then((value) {
                            setState(() {
                              dateOfBirth = value;
                            });
                          });
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 25),
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
