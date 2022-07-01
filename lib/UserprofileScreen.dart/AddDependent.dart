// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_string_escapes, prefer_const_declarations, prefer_const_constructors
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/loadingDailog.dart';

import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:hr_app/main.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:intl/intl.dart';

class AddDependentsInfo extends StatefulWidget {
  final data, editable, uid;
  const AddDependentsInfo({Key? key, this.data, this.editable, this.uid})
      : super(key: key);

  @override
  _AddDependentsInfoState createState() => _AddDependentsInfoState();
}

class _AddDependentsInfoState extends State<AddDependentsInfo> {
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;
  var dobFormat;
  var relation;
  DateTime? dob;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ageController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //check internet connection
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isNetwork = false;
        });
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          isNetwork = true;
        });
      }
    });
    if (widget.editable == true) {
      nameController = TextEditingController(text: widget.data["name"]);
      ageController = TextEditingController(text: widget.data["dob"]);
      relation = widget.data['relation'];
      dobFormat = widget.data["age"] == null || widget.data["age"] == ""
          ? ""
          : widget.data["age"];
    }
  }

  _selectDate(BuildContext context) {
    Picker(
        containerColor: isdarkmode.value ? Colors.transparent : Colors.white,
        backgroundColor: isdarkmode.value ? Colors.transparent : Colors.white,
        hideHeader: true,
        adapter: DateTimePickerAdapter(yearEnd: DateTime.now().year),
        title: Text(
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
            dob = (picker.adapter as DateTimePickerAdapter).value;
            dobFormat = DateFormat('dd-MMM-yyyy').format(dob!);
          });
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildMyAppBar(context, 'Dependent', false),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(15),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("  Name", style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: nameController,
                            style: TextFieldTextStyle(),
                            textInputAction: TextInputAction.next,
                            decoration: TextFieldDecoration('Name'),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 15),
                          Text("  Date of Birth",
                              style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              _selectDate(context);
                              setState(() {});
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.transparent, width: 0)),
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(dobFormat == null || dobFormat == ""
                                      ? ""
                                      : "DOB: "),
                                  Text(
                                    dobFormat == null || dobFormat == ""
                                        ? "Date of Birth"
                                        : dobFormat,
                                    style: TextStyle(
                                        color:
                                            dobFormat == null || dobFormat == ""
                                                ? Color(0xFF737373)
                                                : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        fontFamily: "Poppins"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text("  Relation", style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.transparent, width: 0)),
                            child: DropdownButtonFormField<String>(
                              decoration: TextFieldDecoration('Relation'),
                              value: relation,
                              items: <String>[
                                'Mother',
                                'Father',
                                'Sister',
                                'Brother',
                                'Spouse',
                                'Son',
                                'Daughter'
                              ].map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  relation = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          saveButton(context, onpress)
                        ])))));
  }

  onpress() {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name is empty'),
        ),
      );
    } else {
      widget.editable == true ? validateAndUpdate() : validateAndSave();
    }
  }

  validateAndSave() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      showLoadingDialog(context);
      DocumentReference dependents = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(uid)
          : FirebaseFirestore.instance.collection("employees").doc(uid);
      Map<String, dynamic> serializedMessage = {
        "dob": dobFormat,
        "name": nameController.text.isEmpty
            ? ""
            : nameController.text[0].toUpperCase() +
                nameController.text.substring(1).toString(),
        "relation": relation,
      };
      dependents.update({
        "dependentsInfo": FieldValue.arrayUnion([serializedMessage])
      });
      Future.delayed(Duration(milliseconds: 1050), () {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Dependent is added successfully");
      });
      Navigator.of(context).pop();
      Future.delayed(Duration(milliseconds: 1150), () {
        setState(() {});
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => MainExperiences(
        //             // compId: compId,
        //             // profileData: widget.data,
        //             // adminEmail: null,
        //             )));
        // Navigator.of(context).pop();
      });
    } else {
      return ('form is valid');
    }
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            LoadingDialog(value: "Loading")));
  }

  validateAndUpdate() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      showLoadingDialog(context);
      DocumentReference dependents = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(uid)
          : FirebaseFirestore.instance.collection("employees").doc(uid);
      dependents.update({
        "dependentsInfo": FieldValue.arrayRemove([widget.data])
      });
      Map<String, dynamic> serializedMessage = {
        "dob": dobFormat,
        "name": nameController.text.isEmpty
            ? ""
            : nameController.text[0].toUpperCase() +
                nameController.text.substring(1).toString(),
        "relation": relation,
      };
      dependents.update({
        "dependentsInfo": FieldValue.arrayUnion([serializedMessage])
      });
      Future.delayed(Duration(milliseconds: 1050), () {
        setState(() {});
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Dependent is updated successfully");
      });
      Future.delayed(Duration(milliseconds: 1150), () {
        Navigator.of(context).pop();
      });
    } else {
      return ('form is valid');
    }
  }
}
