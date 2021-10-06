// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_declarations, unnecessary_string_escapes, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hr_app/mainApp/settings/main_settings.dart';
import 'package:hr_app/mainUtility/text_input_design.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../colors.dart';

enum Gender { male, female }

class FormTwo extends StatefulWidget {
  const FormTwo({Key? key}) : super(key: key);

  @override
  _FormTwoState createState() => _FormTwoState();
}

final TextEditingController textController = TextEditingController();

    final maskFormatter = MaskTextInputFormatter(mask: '+92 ### ### ####');
    final maskCNICFormatter = MaskTextInputFormatter(mask: '#####-#######-#');

class _FormTwoState extends State<FormTwo> {
  // bool value = false;
  bool checkedValue = false;
  var gender;
  var dropGenderValue;
  var dropCityValue;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                    //using stack to lap edit icon over Picture
                    children: const [
                      ClipRRect(
                        child: Image(
                          height: 100,
                          image: AssetImage('assets/user_image.png'),
                        ),
                      ),
                      Positioned(
                          bottom: 10,
                          right: 0,
                          child: Image(
                            image: AssetImage('assets/custom/Vector.png'),
                            width: 30,
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
              const SizedBox(height: 35),
              //--------------name-------------------//
              TextFormField(
                decoration: MyInputStyle('Name'),
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
              //--------------email-------------------//
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
              //--------------phone-------------------//
              TextFormField(
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
              //--------------City-------------------//
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
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      hintText: "City",
                      fillColor: Theme.of(context).scaffoldBackgroundColor),
                  value: dropCityValue,
                  items: <String>['Lahore', 'Karachi', 'Islamabad']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropCityValue = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              //----------------gender-------------------//
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
              const SizedBox(height: 20),
              //--------------marital-status-------------------//
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
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      hintText: "Gender",
                      fillColor: Theme.of(context).scaffoldBackgroundColor),
                  value: dropGenderValue,
                  items: <String>['Male', 'Female', 'Other']
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
              const SizedBox(height: 15),
              //--------------blood-group-------------------//
              TextFormField(
                decoration: MyInputStyle('Blood Group'),
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
              //--------------CheckBox-------------------//
              Row(children: [
                Checkbox(
                  value: checkedValue,
                  activeColor: const Color(0xff6036D8),
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue = newValue!;
                    });
                  },
                ),
                 Text('Vaccinated against COVID'),
              ]),
              const SizedBox(height: 15),
              //--------------buttons-------------------//
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                      onPressed: () {},
                      child: const Text('BROWSE')),
                  const SizedBox(width: 25),
                  GestureDetector(
                      child: const Text("JPG Attachment",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue)),
                      onTap: () {
                        // do what you need to do when "Click here" gets clicked
                      })
                ],
              ),
              const SizedBox(height: 15),
              //--------------CNIC-------------------//
              TextFormField(
                controller: textController,
                inputFormatters: [maskCNICFormatter],
                decoration: MyInputStyle('CNIC No.'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final regExp = RegExp('/^[0-9]{5}-[0-9]{7}-[0-9]{1}/g');
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
                              builder: (context) => const MainSettings()));
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
