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

class AddDependentsInfo extends StatelessWidget {
  final data, uid, editable;
  const AddDependentsInfo({Key? key, this.data, this.uid, this.editable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMyAppBar(context, 'Dependent', true),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(bottom: 15, top: 15),
                child: AddKinBody(userData: data, editExp: editable, uid: uid)),
          ),
        ],
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
  var dobFormat;
  late String userId;
  var relation;
  DateTime? dob;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ageController = TextEditingController();
  TextEditingController nameController = TextEditingController();

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
      ageController = TextEditingController(text: widget.userData["dob"]);
      relation = widget.userData['relation'];
      dobFormat = widget.userData["age"] == null || widget.userData["age"] == ""
          ? ""
          : widget.userData["age"];
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
              InkWell(
                onTap: () {
                  _selectDate(context);
                  setState(() {});
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(dobFormat == null || dobFormat == "" ? "" : "DOB: "),
                      Text(
                        dobFormat == null || dobFormat == ""
                            ? "Date of Birth"
                            : dobFormat,
                        style: TextStyle(
                            color: dobFormat == null || dobFormat == ""
                                ? Colors.grey.shade500
                                : isdarkmode.value
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 14,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade300, width: 1)),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
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
              SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  child: const Text('SAVE'),
                  onPressed: () {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Name is empty'),
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
      DocumentReference dependents = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(userId)
          : FirebaseFirestore.instance.collection("employees").doc(userId);
      Map<String, dynamic> serializedMessage = {
        "dob": ageController.text.isEmpty
            ? ""
            : ageController.text[0].toUpperCase() +
                ageController.text.substring(1).toString(),
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
        //             // profileData: widget.userData,
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
      DocumentReference dependents = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(userId)
          : FirebaseFirestore.instance.collection("employees").doc(userId);
      dependents.update({
        "dependentsInfo": FieldValue.arrayRemove([widget.userData])
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
