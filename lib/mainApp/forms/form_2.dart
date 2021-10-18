// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_declarations, unnecessary_string_escapes, prefer_const_constructors, unnecessary_new

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr_app/mainApp/forms/utility/file_picker.dart';
import 'package:hr_app/mainApp/settings/main_settings.dart';
import 'package:hr_app/mainUtility/share_preference.dart';
import 'package:hr_app/mainUtility/text_input_design.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();
  final TextEditingController _controller3 = new TextEditingController();
  final TextEditingController _controller = new TextEditingController();

  // bool value = false;
  bool checkedValue = false;
  var gender;
  var dropGenderValue;
  var dropCityValue;
  var dropBloodGroup;
  String? path;
  String? fileName;

   File? image;
  String? imagePath;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      

      setState(() {
        imagePath= image.path;
        // this.image = imageTemp;
        // saveImage(this.image);
      });
      saveImage('SaveImage',image.path);
    } on PlatformException catch (e) {
      print('Access Rejected: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadImage('SaveImage').then((value) {
      setState(() {
        imagePath = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return Container(
                        child: new Wrap(
                          children: <Widget>[
                            new ListTile(
                              leading: new Icon(Icons.image),
                              title: new Text('Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                pickImage();
                              },
                            ),
                          ],
                        ),
                      );
                    });
                },
                child: Stack(
                  //using stack to lap edit icon over Picture
                  children: [
                    imagePath != null
                      ? CircleAvatar(
                          radius: 50,
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              image: FileImage(File(imagePath!)),
                              height: 114,
                              width: 115,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 50,
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(100),
                            child: image != null
                                ? Image.file(image!)
                                : Image.asset(
                                    "assets/user_image.png",
                                    height: 114,
                                    width: 115,
                                    fit: BoxFit.cover,
                                  ),
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
              ),
              const SizedBox(height: 35),
              //--------------name-------------------//
              TextFormField(
                controller: _controller1,
                textInputAction: TextInputAction.next,
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
                controller: _controller2,
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
              //--------------phone-------------------//
              TextFormField(
                controller: _controller3,
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
                      hintText: "Blood Group",
                      fillColor: Theme.of(context).scaffoldBackgroundColor),
                  value: dropBloodGroup,
                  items: <String>[
                    'A+',
                    'A-',
                    'B+',
                    'B-',
                    'O+',
                    'O-',
                    'AB+',
                    'AB-',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropBloodGroup = value;
                    });
                  },
                ),
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
                      style: ElevatedButton.styleFrom(
                          primary: checkedValue == false
                              ? Colors.grey
                              : kPrimaryRed),
                      onPressed: checkedValue == false
                          ? null
                          : () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                              )
                              .then((value){
                                if(value == null){
                                print('-------------------value is null so it nothing---------------------------')
                                }else if(value != null){
                                  setState(() {
                                  path = value.toString();
                                  print('---------------------value is not-null it something--------------------')
                                })
                                }
                              });
                              File file = new File(path!);
                              fileName = file.path.split('/').last;
                            },
                      child: const Text('BROWSE')),
                  const SizedBox(width: 25),
                  if (checkedValue != false)
                    SizedBox(
                      height: 30,
                      child: InkWell(
                          child: const Text("JPG Attachment",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue)),
                          onTap: () async{
                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['jpg'],
                              )
                              .then((value){
                                if(value == null){
                                print('-------------------value is null so it nothing---------------------------')
                                }else if(value != null){
                                  setState(() {
                                  path = value.toString();
                                  print('---------------------value is not-null it something--------------------')
                                })
                                }
                              });
                              File file = new File(path!);
                              fileName = file.path.split('/').last;
                          }),
                    ),
                  if (checkedValue == true) SizedBox(),
                ],
              ),
              if (path != null) 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(fileName!,
                      maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      style: TextStyle()),
                    ),
                    IconButton(onPressed: (){
                      setState(() {
                        path = null;
                        FilePicker.platform.clearTemporaryFiles().then((result) {
                          }); 
                      });
                    }, icon: Icon(Icons.close)),
                  ],
                ),
              if(path == null)
              SizedBox(),
              const SizedBox(height: 15),
              //--------------CNIC-------------------//
              TextFormField(
                textInputAction: TextInputAction.done,
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