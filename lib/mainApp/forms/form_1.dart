// ignore_for_file: prefer_const_declarations, duplicate_ignore, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/Login/auth.dart';
import 'package:hr_app/mainApp/mainProfile/emp_profile_without_comp.dart';
import 'package:hr_app/mainUtility/text_input_design.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rxdart/rxdart.dart';

import '../../colors.dart';

enum Gender { male, female }

class FirstTimeForm extends StatefulWidget {
  const FirstTimeForm({Key? key}) : super(key: key);

  @override
  _FirstTimeFormState createState() => _FirstTimeFormState();
}

class _FirstTimeFormState extends State<FirstTimeForm> {
  // ignore: prefer_typing_uninitialized_variables

  final maskFormatter = MaskTextInputFormatter(mask: '+92 ### ### ####');
  var gender;
  var dateOfBirth;
  var dropdownValue;
  String? userId;
  late String _extension;
  late FileType _pickType;
  bool _multiPick = true;
  late DateTime dob;
  late String email;
  late String fatherName;
  late String phone;
  late String name;
  late String maritalStatus;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String? path;
  String? fileName;
  String profilePicUrl = '';
  late FirebaseAuth firebaseUser;
  var dobFormat;

  File? _image;

  File? images;
  String? imagePath;
  final ImagePicker _imagePicker = ImagePicker();

  // List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  int selectedMaritalTile = 1;

  setSelectedMaritalTile(int val) {
    setState(() {
      selectedMaritalTile = val;
    });
  }

  loadFirebaseUser() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    userId = firebaseUser!.uid;
    print("Firebase User Id :: ${firebaseUser.uid}");
  }

  @override
  void initState() {
    super.initState();
    loadFirebaseUser();
  }

  static Reference storage = FirebaseStorage.instance.ref();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Future<String> uploadUserImageToFireStorage(
      image, String userID) async {
    Reference upload = storage.child("images/$userID.png");
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _imagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
      });
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      // if (image != null) {
      // await updateProgress('Uploading image, Please wait...');
      profilePicUrl = await uploadUserImageToFireStorage(fileName, userId!);
      if (image == null) return;
      setState(() {
        imagePath = image.path;
        print("ImgPath:::::::::::::${imagePath}");
        // this.image = imageTemp;
        // saveImage(this.image);
      });
    } on PlatformException catch (e) {
      print('Access Rejected: $e');
    }
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: const Text(
        "Add profile picture",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text("Choose from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile? image =
                await _imagePicker.getImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                _image = File(image.path);
              });
            }
          },
        ),
        CupertinoActionSheetAction(
          child: const Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile? image =
                await _imagePicker.getImage(source: ImageSource.camera);
            if (image != null) {
              setState(() {
                _image = File(image.path);
              });
            }
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  final FocusNode nameFocus = FocusNode();
  final FocusNode fatherNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  _selectDate(BuildContext context) {
    Picker(
        containerColor: isdarkmode.value ? Colors.transparent : Colors.white,
        backgroundColor: isdarkmode.value ? Colors.transparent : Colors.white,
        hideHeader: true,
        adapter: DateTimePickerAdapter(yearEnd: DateTime.now().year),
        title: const Text(
          "Date of Birth",
          style: TextStyle(
            color: Color(0xFFBF2B38),
          ),
        ),
        selectedTextStyle: TextStyle(
          color: isdarkmode.value ? Colors.white : Color(0xFFBF2B38),
        ),
        onConfirm: (Picker picker, List value) {
          setState(() {
            dob = (picker.adapter as DateTimePickerAdapter).value!;
            dobFormat = DateFormat('dd-MMM-yyyy').format(dob);
          });
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //----User Profile Image Uploading-----//
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 32, right: 8, bottom: 8),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey.shade400,
                            child: ClipOval(
                              child: SizedBox(
                                  width: 170,
                                  height: 170,
                                  child: imagePath == null
                                      ? (_image == null
                                          ? Image.asset(
                                              'assets/user_image.png',
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              _image!,
                                              fit: BoxFit.cover,
                                            ))
                                      : Image.network(imagePath!,
                                          fit: BoxFit.cover)),
                            ),
                          ),
                          Positioned(
                            left: 80,
                            right: 0,
                            child: FloatingActionButton(
                                backgroundColor: (darkRed),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                mini: true,
                                onPressed: _onCameraClick),
                          )
                        ],
                      ),
                    ),
                  ),
                  // CircleAvatar(
                  //   backgroundColor: Colors.transparent,
                  //   radius: 70,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(100),
                  //     child: Image.asset("assets/Logo.png"),
                  //   ),
                  // ),
                  //-------------------------------------------------//
                  const SizedBox(height: 25),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration: MyInputStyle('Your Name'),
                    controller: nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: nameFocus,
                    onSaved: (String? value) => name = value!,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      emailFocus.unfocus();
                      FocusScope.of(context).requestFocus(fatherNameFocus);
                    },
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
                    textCapitalization: TextCapitalization.sentences,
                    decoration: MyInputStyle('Father Name'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: fatherNameController,
                    focusNode: fatherNameFocus,
                    onSaved: (String? value) => fatherName = value!,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      fatherNameFocus.unfocus();
                      FocusScope.of(context).requestFocus(emailFocus);
                    },
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
                    textCapitalization: TextCapitalization.sentences,
                    decoration: MyInputStyle('Email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    focusNode: emailFocus,
                    onSaved: (String? value) => email = value!,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      emailFocus.unfocus();
                      FocusScope.of(context).requestFocus(phoneFocus);
                    },
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
                    textCapitalization: TextCapitalization.sentences,
                    decoration: MyInputStyle('Phone'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: phoneController,
                    focusNode: phoneFocus,
                    onSaved: (String? value) => phone = value!,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {},
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.4), width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          elevation: 0,
                          isExpanded: true,
                          hint: const Text('Marital status',
                              style: TextStyle(color: Colors.grey)),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>['Single', 'Married']
                              .map<DropdownMenuItem<String>>((String value) {
                            maritalStatus = value;
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //-------------------------------------------------//
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.today, color: Colors.grey),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  primary: darkRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  validateAndSave();
                                })),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//------ Loading Dialog-----///
  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingDialog()));
  }
  //---Save data to firebase---//

  validateAndSave() async {
    // final form = _formKey.currentState;
    // if (form!.validate()) {
    // if (dobFormat == "Date of Birth" || dobFormat == null) {
    //   const SnackBar(
    //       backgroundColor: Colors.red,
    //       content: Text("Kindly select the date of birth"));
    // }
    // else if (selectedMaritalTile == 0) {
    //   const SnackBar(
    //       backgroundColor: Colors.red,
    //       content: Text("Kindly select the Marital status"));
    // }
    //   else {
    showLoadingDialog(context);
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      print({
        "email:::::::${emailController.text}  name:::::::${nameController.text}"
            "phone :::::::${phoneController.text}"
            "gender::::::$gender "
            "userId::::::::::::$userId"
      });
      DocumentReference reference =
          FirebaseFirestore.instance.collection("guests").doc(userId);
      profilePicUrl = await uploadUserImageToFireStorage(_image, userId!);
      await reference.update({
        "phone": phoneController.text,
        "email": emailController.text,
        "maritalStatus": dropdownValue,
        "name": nameController.text,
        "dob": '${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}',
        "imagePath": profilePicUrl,
        "fileName": fileName,
        "gender": gender.toString() == "Gender.female" ? "Female" : "Male",
      });
    }).whenComplete(() {
      // Navigator.pop(context);

      Fluttertoast.showToast(msg: "Your  info is updated successfully");
    }).catchError((e) {
      print('======Error====$e==== ');
    });

    Future.delayed(const Duration(milliseconds: 1150), () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const EmpProfileWithoutComp()));
      //  },
    });
    //}
  }
  // else {
  //   print('form is invalid');
  // }
//  }
}

//===================================================//
