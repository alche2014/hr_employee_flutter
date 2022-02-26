// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_string_escapes, prefer_const_declarations, prefer_const_constructors
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';

import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:hr_app/Constants/constants.dart';

class AddKinInfo extends StatelessWidget {
  final data, uid, editable;
  const AddKinInfo({Key? key, this.data, this.uid, this.editable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMyAppBar(context, 'Next of Kin', true),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(bottom: 15, top: 10),
            child: AddKinBody(userData: data, editExp: editable, uid: uid)),
      ),
    );
  }
}

class AddKinBody extends StatefulWidget {
  final userData, editExp, uid;
  const AddKinBody({Key? key, this.userData, this.editExp, this.uid})
      : super(key: key);

  @override
  _AddKinBodyState createState() => _AddKinBodyState();
}

class _AddKinBodyState extends State<AddKinBody> {
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;
  DateTime? selectedDate;
  var dateFormat;
  DateTime? toselectedDate;
  var todateFormat;
  late String userId;
  var relation;

  bool checkedValue = false;
  String? empStatus;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController ageController = TextEditingController();
  var cnicController = MaskedTextController(mask: '00000-0000000-0');
  TextEditingController nameController = TextEditingController();
  TextEditingController percentageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userId = widget.uid;

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
    if (widget.editExp == true) {
      nameController = TextEditingController(text: widget.userData["name"]);
      ageController = TextEditingController(text: widget.userData["age"]);
      percentageController =
          TextEditingController(text: widget.userData["percentage"]);
      relation = widget.userData['relation'];
      cnicController = MaskedTextController(
          text: widget.userData["cnic"], mask: '00000-0000000-0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: nameController,
                style: TextFieldTextStyle(),
                textInputAction: TextInputAction.next,
                decoration: TextFieldDecoration('Name'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: ageController,
                validator: validateAge,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    labelText: "Age",
                    labelStyle: TextStyle(color: Colors.grey),
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
                    suffix: Text("Years")),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: TextFieldTextStyle(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: validateper,
                controller: percentageController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    labelText: "Percentage",
                    labelStyle: TextStyle(color: Colors.grey),
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
                    suffix: Text("%")),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: TextFieldTextStyle(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: cnicController,
                keyboardType: TextInputType.number,
                style: TextFieldTextStyle(),
                textInputAction: TextInputAction.next,
                decoration: TextFieldDecoration('CNIC'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 10),
              Container(
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade300, width: 1)),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      labelText: "Relation",
                      labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.transparent),
                  value: relation,
                  items: <String>[
                    'Mother',
                    'Father',
                    'Sister',
                    'Brother',
                    'Spouse'
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
              const SizedBox(height: 20),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  child: const Text('SAVE'),
                  onPressed: () {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Name  is empty'),
                        ),
                      );
                    } else {
                      widget.editExp == true
                          ? validateAndUpdate()
                          : validateAndSave();
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }

  validateAndSave() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
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
      DocumentReference chatroomRef = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(userId)
          : FirebaseFirestore.instance.collection("employees").doc(userId);
      Map<String, dynamic> serializedMessage = {
        "age": ageController.text.isEmpty
            ? ""
            : ageController.text[0].toUpperCase() +
                ageController.text.substring(1).toString(),
        "name": nameController.text.isEmpty
            ? ""
            : nameController.text[0].toUpperCase() +
                nameController.text.substring(1).toString(),
        "percentage":
            percentageController.text.isEmpty ? "" : percentageController.text,
        "relation": relation,
        "cnic": cnicController.text.isEmpty ? "" : cnicController.text,
      };
      chatroomRef.update({
        "kinInfo": FieldValue.arrayUnion([serializedMessage])
      });
      Future.delayed(Duration(milliseconds: 1050), () {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Information is added successfully");
      });
      Navigator.of(context).pop();
      Future.delayed(Duration(milliseconds: 1150), () {
        setState(() {});
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
      DocumentReference kins = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(userId)
          : FirebaseFirestore.instance.collection("employees").doc(userId);
      kins.update({
        "kinInfo": FieldValue.arrayRemove([widget.userData])
      });
      Map<String, dynamic> serializedMessage = {
        "age": ageController.text.isEmpty
            ? ""
            : ageController.text[0].toUpperCase() +
                ageController.text.substring(1).toString(),
        "name": nameController.text.isEmpty
            ? ""
            : nameController.text[0].toUpperCase() +
                nameController.text.substring(1).toString(),
        "percentage":
            percentageController.text.isEmpty ? "" : percentageController.text,
        "relation": relation,
        "cnic": cnicController.text.isEmpty ? "" : cnicController.text,
      };
      kins.update({
        "kinInfo": FieldValue.arrayUnion([serializedMessage])
      });
      Future.delayed(Duration(milliseconds: 1050), () {
        setState(() {});
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Information is updated successfully");
      });
      Future.delayed(Duration(milliseconds: 1150), () {
        Navigator.of(context).pop();
      });
    } else {
      return ('form is valid');
    }
  }

  String? validateAge(String? value) {
    if (value!.length != 0) {
      if (int.parse(value) > 120) {
        return "Kindly add correct age";
      }
    } else {
      return null;
    }
  }

  String? validateper(String? value) {
    if (value!.length != 0) {
      if (int.parse(value) > 101) {
        return "Kindly add correct percentage";
      }
    } else {
      return null;
    }
  }
}
