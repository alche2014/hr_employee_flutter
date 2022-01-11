// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_string_escapes, prefer_const_declarations, prefer_const_constructors
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class AddExperience extends StatelessWidget {
  final data, uid, editable;
  const AddExperience({Key? key, this.data, this.uid, this.editable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Add Experience', true),
      body: Stack(
        children: [
          BackgroundCircle(),
          SingleChildScrollView(
            child: AddExperienceBody(userData: data, editExp: editable),
          ),
        ],
      ),
    );
  }
}

class AddExperienceBody extends StatefulWidget {
  final userData, editExp;
  const AddExperienceBody({Key? key, this.userData, this.editExp})
      : super(key: key);

  @override
  _AddExperienceBodyState createState() => _AddExperienceBodyState();
}

class _AddExperienceBodyState extends State<AddExperienceBody> {
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;
  DateTime? selectedDate;
  var dateFormat;
  DateTime? toselectedDate;
  var todateFormat;
  late String userId;
  var industryValue;
  bool checkedValue = false;
  String? empStatus;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController titlesController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController headlineController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userId = widget.userData["uid"];

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
      companyNameController = TextEditingController(
        text: widget.userData["companyName"],
      );
      titlesController = TextEditingController(
        text: widget.userData["title"],
      );
      descriptionController = TextEditingController(
        text: widget.userData["jobDescription"],
      );
      dateFormat = widget.userData['expstartDate'];
      todateFormat = widget.userData['expLastDate'];
      headlineController =
          TextEditingController(text: widget.userData["expHeadline"]);
      empStatus = widget.userData['empStatus'];

      locationController = TextEditingController(
        text: widget.userData["expLocation"],
      );
      checkedValue =
          widget.userData['currentyWorkingCheck'] == null ? false : true;

      industryValue = widget.userData['industry'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Form(
          key: _formKey,
          child: Container(
            margin: Platform.isIOS
                ? const EdgeInsets.only(top: 20)
                : const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
            child: Column(
              children: [
                SizedBox(height: 50),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: titlesController,
                  style: TextFieldTextStyle(),
                  decoration: TextFieldDecoration('Title'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),
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
                        labelText: "Employement Status",
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.transparent),
                    value: empStatus,
                    items: <String>['Full Time', 'Half Time']
                        .map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        empStatus = newValue!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),
                //-------------------------------------------------//
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: companyNameController,
                  decoration: TextFieldDecoration('Company Name'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextFieldTextStyle(),
                ),
                const SizedBox(height: 10),
                //-------------------------------------------------//
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: locationController,
                  decoration: TextFieldDecoration('Location'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextFieldTextStyle(),
                ),
                const SizedBox(height: 8),
                //-------------------------------------------------//
                Row(children: [
                  Checkbox(
                    value: checkedValue,
                    activeColor: Colors.redAccent,
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    Expanded(
                        child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: () {
                          showMonthPicker(
                                  context: context,
                                  firstDate: (DateTime.now())
                                      .subtract(Duration(days: 500000)),
                                  lastDate: toselectedDate,
                                  initialDate: DateTime.now())
                              .then((date) => setState(() {
                                    selectedDate = date;
                                    dateFormat = DateFormat("MMMM yyyy")
                                        .format(selectedDate!);
                                  }));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  dateFormat ?? "Start Date",
                                )),
                          ],
                        ),
                      ),
                    )),
                    SizedBox(width: 10),
                    Expanded(
                        child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: () {
                          if (!checkedValue) {
                            showMonthPicker(
                                    context: context,
                                    firstDate: selectedDate,
                                    lastDate: (DateTime.now())
                                        .add(Duration(days: 500000)),
                                    initialDate: DateTime.now())
                                .then((date) => setState(() {
                                      toselectedDate = date!;
                                      todateFormat = DateFormat("MMMM yyyy")
                                          .format(toselectedDate!);
                                    }));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  todateFormat ?? " End Date",
                                )),
                          ],
                        ),
                      ),
                    )),
                  ]),
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: headlineController,
                  decoration: TextFieldDecoration('Headline'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextFieldTextStyle(),
                ),
                SizedBox(height: 10),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),
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
                        labelText: "Industry",
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.transparent),
                    value: industryValue,
                    items: <String>['E-commerce', 'Business', 'Software ']
                        .map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        industryValue = newValue!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: descriptionController,
                  maxLines: null,
                  decoration: TextFieldDecoration('Description'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextFieldTextStyle(),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    child: const Text('SAVE'),
                    onPressed: () {
                      widget.editExp == true
                          ? validateAndUpdate()
                          : validateAndSave();
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  validateAndSave() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      int guest = 0;
      if (dateFormat == "Start Date" || dateFormat == null) {
        Flushbar(
          messageText: Text(
            "Kindly select date",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          duration: Duration(seconds: 3),
          isDismissible: true,
          backgroundColor: Color(0xFFBF2B38),
          margin: EdgeInsets.all(8),
          borderRadius: 8,
        ).show(context);
      } else {
        showLoadingDialog(context);

        final user = FirebaseAuth.instance.currentUser!;
        await FirebaseFirestore.instance
            .collection("employees") //your collectionref
            .where('uid', isEqualTo: user.uid)
            .get()
            .then((value) {
          // var count = 0;
          guest = value.docs.length;
        });
        if (guest == 0) {
          DocumentReference guestExp =
              FirebaseFirestore.instance.collection("guests").doc(user.uid);
          Map<String, dynamic> serializedMessage = {
            "title": titlesController.text[0].toUpperCase() +
                titlesController.text.substring(1).toString(),
            "companyName": companyNameController.text[0].toUpperCase() +
                companyNameController.text.substring(1).toString(),
            "expstartDate": dateFormat,
            "expLastDate": todateFormat,
            "jobDescription": descriptionController.text[0].toUpperCase() +
                descriptionController.text.substring(1).toString(),
            "empStatus": empStatus ?? "Full Time",
            "expHeadline": headlineController.text == null
                ? ''
                : headlineController.text[0].toUpperCase() +
                    headlineController.text.substring(1).toString(),
            "industry": industryValue,
            "expLocation": locationController.text[0].toUpperCase() +
                locationController.text.substring(1).toString(),
            "currentyWorkingCheck": checkedValue,
          };
          guestExp.update({
            "workExperience": FieldValue.arrayUnion([serializedMessage])
          });
          Future.delayed(Duration(milliseconds: 1050), () {
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: "Experience is added successfully");
          });
          Future.delayed(Duration(milliseconds: 1150), () {
            Navigator.of(context).pop();
          });
        } else {
          DocumentReference empExpData =
              FirebaseFirestore.instance.collection("employees").doc(user.uid);
          Map<String, dynamic> serializedMessage = {
            "title": titlesController.text[0].toUpperCase() +
                titlesController.text.substring(1).toString(),
            "companyName": companyNameController.text[0].toUpperCase() +
                companyNameController.text.substring(1).toString(),
            "expstartDate": dateFormat,
            "expLastDate": todateFormat,
            "jobDescription": descriptionController.text.isEmpty
                ? ''
                : descriptionController.text[0].toUpperCase() +
                    descriptionController.text.substring(1).toString(),
            "empStatus": empStatus ?? "Full Time",
            "expHeadline": headlineController.text.isEmpty
                ? ''
                : headlineController.text[0].toUpperCase() +
                    headlineController.text.substring(1).toString(),
            "industry": industryValue,
            "expLocation": locationController.text.isEmpty
                ? ''
                : locationController.text[0].toUpperCase() +
                    locationController.text.substring(1).toString(),
            "currentyWorkingCheck": checkedValue == false ? false : true,
          };
          empExpData.update({
            "workExperience": FieldValue.arrayUnion([serializedMessage])
          });
          Future.delayed(Duration(milliseconds: 1050), () {
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: "Experience is added successfully");
          });
          Future.delayed(Duration(milliseconds: 1150), () {
            Navigator.of(context).pop();
          });
        }
      }
    } else {
      return ('form is valid');
    }
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingDialog()));
  }

  validateAndUpdate() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (dateFormat == "Start Date" || dateFormat == null) {
        Flushbar(
          messageText: Text(
            "Kindly select date",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          duration: Duration(seconds: 3),
          isDismissible: true,
          icon: Icon(
            Icons.close,
            size: 30,
          ),
          backgroundColor: Color(0xFFBF2B38),
          margin: EdgeInsets.all(8),
          borderRadius: 8,
        ).show(context);
      } else {
        showLoadingDialog(context);
        int guest = 0;

        final user = FirebaseAuth.instance.currentUser!;
        await FirebaseFirestore.instance
            .collection("employees") //your collectionref
            .where('uid', isEqualTo: user.uid)
            .get()
            .then((value) {
          guest = value.docs.length;
        });
        if (guest == 0) {
          DocumentReference addExpinGuest =
              FirebaseFirestore.instance.collection("guests").doc(user.uid);
          addExpinGuest.update({
            "workExperience": FieldValue.arrayRemove([widget.userData])
          });
          print("UserId::::::::::::$userId");
          Map<String, dynamic> serializedMessage = {
            "title": titlesController.text[0].toUpperCase() +
                titlesController.text.substring(1).toString(),
            "companyName": companyNameController.text[0].toUpperCase() +
                companyNameController.text.substring(1).toString(),
            "expstartDate": dateFormat,
            "expLastDate": todateFormat,
            "jobDescription": descriptionController.text[0].toUpperCase() +
                descriptionController.text.substring(1).toString(),
            "empStatus": empStatus ?? "Full Time",
            "expHeadline": headlineController.text[0].toUpperCase() +
                headlineController.text.substring(1).toString(),
            "industry": industryValue,
            "expLocation": locationController.text[0].toUpperCase() +
                locationController.text.substring(1).toString(),
            "currentyWorkingCheck":
                checkedValue == null || checkedValue == false ? false : true,
          };
          addExpinGuest.update({
            "workExperience": FieldValue.arrayUnion([serializedMessage])
          });
          Future.delayed(Duration(milliseconds: 1050), () {
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: "Experience is added successfully");
          });
          Navigator.of(context).pop();
          //  });
        } else {
          DocumentReference qualifications =
              FirebaseFirestore.instance.collection("employees").doc(user.uid);
          qualifications.update({
            "workExperience": FieldValue.arrayRemove([widget.userData])
          });
          print("UserId::::::::::::$userId");
          Map<String, dynamic> serializedMessage = {
            "title": titlesController.text[0].toUpperCase() +
                titlesController.text.substring(1).toString(),
            "companyName": companyNameController.text[0].toUpperCase() +
                companyNameController.text.substring(1).toString(),
            "expstartDate": dateFormat,
            "expLastDate": todateFormat,
            "jobDescription": descriptionController.text.isEmpty
                ? ''
                : descriptionController.text[0].toUpperCase() +
                    descriptionController.text.substring(1).toString(),
            "empStatus": empStatus ?? "Full Time",
            "expHeadline": headlineController.text.isEmpty
                ? ''
                : headlineController.text[0].toUpperCase() +
                    headlineController.text.substring(1).toString(),
            "industry": industryValue,
            "expLocation": locationController.text[0].toUpperCase() +
                locationController.text.substring(1).toString(),
            "currentyWorkingCheck": checkedValue,
          };
          qualifications.update({
            "workExperience": FieldValue.arrayUnion([serializedMessage])
          });
          Future.delayed(Duration(milliseconds: 1050), () {
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: "Experience is added successfully");
          });
          Future.delayed(Duration(milliseconds: 1150), () {
            Navigator.of(context).pop();
          });
        }
      }

      print('form is valid');
    } else {
      print('form is invalid');
    }
  }
}
