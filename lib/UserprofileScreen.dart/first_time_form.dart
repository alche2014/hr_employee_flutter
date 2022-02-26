// ignore_for_file: prefer_const_declarations, duplicate_ignore, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/loadingDailog.dart';

import 'package:hr_app/UserprofileScreen.dart/my_profile_edit.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/widgets/text_input_design.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:country_code_picker/country_code_picker.dart';

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
  }

  @override
  void initState() {
    super.initState();
    loadFirebaseUser();
  }

  static Reference storage = FirebaseStorage.instance.ref();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static var downloadUrl;
  static Future<String> uploadUserImageToFireStorage(
      image, String userID) async {
    Reference upload = storage.child("images/$userID.png");
    UploadTask uploadTask = upload.putFile(image);
    downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      profilePicUrl = await uploadUserImageToFireStorage(fileName, userId!);
      if (image == null) return;
      setState(() {
        imagePath = image.path;
      });
    } on PlatformException catch (e) {}
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
  var defaultCode = "+92";

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
            color: purpleDark,
          ),
        ),
        selectedTextStyle: TextStyle(
          color: isdarkmode.value ? Colors.white : purpleDark,
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //----User Profile Image Uploading-----//
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, top: 12, right: 5, bottom: 8),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey.shade200,
                            child: ClipOval(
                              child: SizedBox(
                                  width: 170,
                                  height: 170,
                                  child: imagePath == null
                                      ? (_image == null
                                          ? const Icon(Icons.person,
                                              size: 100, color: purpleDark)
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
                                backgroundColor: (purpleDark),
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
                  const SizedBox(height: 10),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration: MyInputStyle('Name'),
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  //-------------------------------------------------//
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration: MyInputStyle('Email'),
                    keyboardType: TextInputType.emailAddress,
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
                  const SizedBox(height: 10),
                  //-------------------------------------------------//
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    controller: phoneController,
                    style: TextFieldTextStyle(),
                    decoration: InputDecoration(
                      prefix: CountryCodePicker(
                          initialSelection: defaultCode,
                          padding: const EdgeInsets.all(0),
                          onChanged: (CountryCode? selectedValue) {
                            defaultCode = selectedValue!.dialCode.toString();
                          },
                          hideSearch: false,
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false),
                      contentPadding:
                          const EdgeInsets.only(bottom: 15, top: -5, left: 15),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(width: 1, color: Colors.grey.shade300),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(width: 1, color: Colors.grey.shade300),
                      ),
                      labelText: 'Phone',
                      labelStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //-------------------------------------------------//
                  Container(
                    height: 50,
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
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.4), width: 1)),
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              dobFormat == null
                                  ? 'Date of Birth'
                                  : dobFormat.toString(),
                              style: TextStyle(
                                  color: dobFormat == null
                                      ? Colors.grey
                                      : Colors.black),
                            ),
                          ),
                          const Icon(Icons.today, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //-------------------------------------------------//
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio<Gender>(
                            activeColor: purpleDark,
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
                            activeColor: purpleDark,
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
                  const SizedBox(height: 10),
                  //=============================//
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                child: const Text('Done'), //next button
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  primary: purpleDark,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  if (nameController.text.isEmpty ||
                                      fatherNameController.text.isEmpty ||
                                      emailController.text.isEmpty ||
                                      phoneController.text.isEmpty ||
                                      gender == null ||
                                      dobFormat == null ||
                                      maritalStatus == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Complete the form")));
                                  } else {
                                    validateAndSave();
                                  }
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
        pageBuilder: (BuildContext context, _, __) =>
            LoadingDialog(value: "Loading")));
  }
  //---Save data to firebase---//

  validateAndSave() async {
    int guest = 0;
    final user = FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance
        .collection("employees")
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((value) {
      guest = value.docs.length;
    });
    showLoadingDialog(context);
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(userId)
          : FirebaseFirestore.instance.collection("employees").doc(userId);
      await reference.update({
        "phone": defaultCode + " " + phoneController.text,
        "email": emailController.text,
        "maritalStatus": dropdownValue,
        "name": nameController.text,
        "fatherName": fatherNameController.text,
        "dob": '$dobFormat',
        "imagePath": downloadUrl == null ? null : downloadUrl,
        "gender": gender.toString() == "Gender.female" ? "Female" : "Male",
      });
    }).whenComplete(() {
      Fluttertoast.showToast(msg: "Your  info is added successfully");
    }).catchError((e) {});

    Future.delayed(const Duration(milliseconds: 1150), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyProfileEdit()));
    });
  }
}
