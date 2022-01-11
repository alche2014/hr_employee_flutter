// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../colors.dart';

// employee can add his/her educational information in this screen

class Education extends StatefulWidget {
  final data, uid, editable;
  const Education({Key? key, this.data, this.uid, this.editable})
      : super(key: key);
  @override
  _EducationState createState() => _EducationState();
}

class _EducationState extends State<Education> {
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String school;
  late String degree;
  late String userId;
  late String field;
  late String notes;
  late String interest;

  final FocusNode _schoolFocus = FocusNode();
  final FocusNode _degreeFocus = FocusNode();
  final FocusNode _fieldFocus = FocusNode();
  final FocusNode _notesFocus = FocusNode();
  final FocusNode _interestFocus = FocusNode();

  TextEditingController schoolController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController fieldController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController interestController = TextEditingController();

  DateTime? selectedDate;
  var dateFormat;
  DateTime? toselectedDate;
  var todateFormat;

  @override
  void initState() {
    super.initState();
    //check internet connection
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      print(result.toString());
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
      schoolController = TextEditingController(
        text: widget.data["school"],
      );
      notesController = TextEditingController(
        text: widget.data["notes"],
      );
      dateFormat = widget.data['expstartDate'];
      todateFormat = widget.data['expLastDate'];
      fieldController = TextEditingController(
        text: widget.data['studyField'],
      );
      interestController = TextEditingController(
        text: widget.data["interests"],
      );
      degreeController = TextEditingController(
        text: widget.data["degree"],
      );
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: buildMyAppBar(context, 'Add Education', true),
          body: Stack(
            children: [
              const BackgroundCircle(),
              Container(
                margin: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 15, top: 90),
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 5),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: schoolController,
                        textInputAction: TextInputAction.next,
                        focusNode: _schoolFocus,
                        keyboardType: TextInputType.text,
                        onSaved: (String? value) => school = value!,
                        onFieldSubmitted: (term) {
                          _schoolFocus.unfocus();
                          FocusScope.of(context).requestFocus(_degreeFocus);
                        },
                        validator: validateSchool,
                        decoration: TextFieldDecoration('School'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: degreeController,
                        textInputAction: TextInputAction.done,
                        focusNode: _degreeFocus,
                        decoration: TextFieldDecoration('Degree'),
                        onSaved: (String? value) => degree = value!,
                        onFieldSubmitted: (term) {
                          _degreeFocus.unfocus();
                          FocusScope.of(context).requestFocus(_fieldFocus);
                        },
                        validator: validateDegree,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        decoration: TextFieldDecoration('Field of Study'),
                        controller: fieldController,
                        textInputAction: TextInputAction.next,
                        focusNode: _fieldFocus,
                        keyboardType: TextInputType.text,
                        onSaved: (String? value) => field = value!,
                        onFieldSubmitted: (term) {
                          _fieldFocus.unfocus();
                          FocusScope.of(context).requestFocus(_notesFocus);
                        },
                        validator: validateField,
                        maxLines: null,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
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
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                margin:
                                    const EdgeInsets.only(right: 5, top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        child: const Icon(
                                          Icons.date_range,
                                          color: Color(0xFFBF2B38),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Text(
                                        dateFormat ?? "From",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                showMonthPicker(
                                        context: context,
                                        firstDate: selectedDate,
                                        lastDate: (DateTime.now())
                                            .add(Duration(days: 500000)),
                                        initialDate: DateTime.now())
                                    .then((date) => setState(() {
                                          toselectedDate = date;
                                          todateFormat = DateFormat("MMMM yyyy")
                                              .format(toselectedDate!);
                                        }));
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                margin: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        child: const Icon(
                                          Icons.date_range,
                                          color: Color(0xFFBF2B38),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Text(
                                        todateFormat ?? "To",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        decoration: TextFieldDecoration("Notes"),
                        controller: notesController,
                        textInputAction: TextInputAction.next,
                        focusNode: _notesFocus,
                        keyboardType: TextInputType.text,
                        onSaved: (String? value) => notes = value!,
                        onFieldSubmitted: (term) {
                          _notesFocus.unfocus();
                          FocusScope.of(context).requestFocus(_interestFocus);
                        },
                        validator: validateNotes,
                        maxLines: null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: interestController,
                        textInputAction: TextInputAction.next,
                        focusNode: _interestFocus,
                        keyboardType: TextInputType.text,
                        onSaved: (String? value) => interest = value!,
                        onFieldSubmitted: (term) {
                          _interestFocus.unfocus();
                        },
                        validator: validateInterest,
                        maxLines: null,
                        decoration: TextFieldDecoration("Interests"),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 15, right: 12, bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  child: ElevatedButton(
                    child: const Text('SAVE'), //next button
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      primary: darkRed,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: () {
                      if (widget.editable == true) {
                        validateAndUpdate();
                      } else {
                        validateAndSave();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ));
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
      int guest = 0;

      if (dateFormat == "From" || dateFormat == null) {
        Flushbar(
          messageText: const Text(
            "Kindly select date",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
          isDismissible: true,
          icon: Image.asset(
            "assets/images/cancel.png",
            // scale: 1.0,
            height: 30,
            width: 30,
          ),
          backgroundColor: const Color(0xFFBF2B38),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        ).show(context);
      }
      if (todateFormat == "To" || todateFormat == null) {
        Flushbar(
          messageText: const Text(
            "Kindly select date",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
          isDismissible: true,
          icon: Image.asset(
            "assets/images/cancel.png",
            // scale: 1.0,
            height: 30,
            width: 30,
          ),
          backgroundColor: const Color(0xFFBF2B38),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        ).show(context);
      } else {
        //---checking guest login---//
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
          DocumentReference guestQualifications =
              FirebaseFirestore.instance.collection("guests").doc(user.uid);
          guestQualifications.update({
            "education": FieldValue.arrayRemove([widget.data])
          });
          Map<String, dynamic> serializedMessage = {
            "school": schoolController.text[0].toUpperCase() +
                schoolController.text.substring(1).toString(),
            "degree": degreeController.text[0].toUpperCase() +
                degreeController.text.substring(1).toString(),
            "expstartDate": dateFormat ?? widget.data["expstartDate"],
            "expLastDate": todateFormat ?? widget.data["expLastDate"],
            "notes": notesController.text[0].toUpperCase() +
                notesController.text.substring(1).toString(),
            "studyField": fieldController.text[0].toUpperCase() +
                fieldController.text.substring(1).toString(),
            "interests": interestController.text[0].toUpperCase() +
                interestController.text.substring(1).toString(),
          };

          guestQualifications.update({
            "education": FieldValue.arrayUnion([serializedMessage])
          });
          Future.delayed(const Duration(milliseconds: 1050), () {
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: "Education is updated successfully");
          });
          Future.delayed(const Duration(milliseconds: 1150), () {
            Navigator.of(context).pop();
          });
        } else {
          DocumentReference qualifications =
              FirebaseFirestore.instance.collection("employees").doc(user.uid);
          qualifications.update({
            "education": FieldValue.arrayRemove([widget.data])
          });
          Map<String, dynamic> serializedMessage = {
            "school": schoolController.text[0].toUpperCase() +
                schoolController.text.substring(1).toString(),
            "degree": degreeController.text[0].toUpperCase() +
                degreeController.text.substring(1).toString(),
            "expstartDate": dateFormat ?? widget.data["expstartDate"],
            "expLastDate": todateFormat ?? widget.data["expLastDate"],
            "notes": notesController.text[0].toUpperCase() +
                notesController.text.substring(1).toString(),
            "studyField": fieldController.text[0].toUpperCase() +
                fieldController.text.substring(1).toString(),
            "interests": interestController.text[0].toUpperCase() +
                interestController.text.substring(1).toString(),
          };

          qualifications.update({
            "education": FieldValue.arrayUnion([serializedMessage])
          });
          Future.delayed(const Duration(milliseconds: 1050), () {
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: "Education is updated successfully");
          });
          Future.delayed(const Duration(milliseconds: 1150), () {
            Navigator.of(context).pop();
          });
        }
      }
    }
  }

  // add Education for the first time
  validateAndSave() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      int guest = 0;

      if (dateFormat == "From" || dateFormat == null) {
        Flushbar(
          messageText: const Text(
            "Kindly select date",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
          isDismissible: true,
          backgroundColor: const Color(0xFFBF2B38),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        ).show(context);
      } else if (todateFormat == "To" || todateFormat == null) {
        Flushbar(
          messageText: const Text(
            "Kindly select date",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
          isDismissible: true,
          backgroundColor: const Color(0xFFBF2B38),
          margin: const EdgeInsets.all(8),
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
          DocumentReference addEducationGuest =
              FirebaseFirestore.instance.collection("guests").doc(user.uid);

          Map<String, dynamic> serializedMessage = {
            "school": schoolController.text[0].toUpperCase() +
                schoolController.text.substring(1).toString(),
            "degree": degreeController.text[0].toUpperCase() +
                degreeController.text.substring(1).toString(),
            "expstartDate": dateFormat,
            "expLastDate": todateFormat,
            "notes": notesController.text[0].toUpperCase() +
                notesController.text.substring(1).toString(),
            "studyField": fieldController.text[0].toUpperCase() +
                fieldController.text.substring(1).toString(),
            "interests": interestController.text[0].toUpperCase() +
                interestController.text.substring(1).toString(),
          };

          addEducationGuest.update({
            "education": FieldValue.arrayUnion([serializedMessage])
          });
          Future.delayed(const Duration(milliseconds: 1050), () {
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: "Education is added successfully");
          });
          Future.delayed(const Duration(milliseconds: 1150), () {
            Navigator.of(context).pop();
          });
        } else {
          DocumentReference addEducationEmp =
              FirebaseFirestore.instance.collection("employees").doc(user.uid);
          Map<String, dynamic> serializedMessage = {
            "school": schoolController.text[0].toUpperCase() +
                schoolController.text.substring(1).toString(),
            "degree": degreeController.text[0].toUpperCase() +
                degreeController.text.substring(1).toString(),
            "expstartDate": dateFormat,
            "expLastDate": todateFormat,
            "notes": notesController.text[0].toUpperCase() +
                notesController.text.substring(1).toString(),
            "studyField": fieldController.text[0].toUpperCase() +
                fieldController.text.substring(1).toString(),
            "interests": interestController.text[0].toUpperCase() +
                interestController.text.substring(1).toString(),
          };

          addEducationEmp.update({
            "education": FieldValue.arrayUnion([serializedMessage])
          });
          Future.delayed(const Duration(milliseconds: 1050), () {
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: "Education is added successfully");
          });
          Future.delayed(const Duration(milliseconds: 1150), () {
            Navigator.of(context).pop();
          });
        }
      }
    }
  }

  String? validateSchool(String? value) {
    if (value!.length < 3) {
      return "School Name can't be empty";
    } else {
      return null;
    }
  }

  String? validateDegree(String? value) {
    if (value!.isEmpty) {
      return "Degree can't be empty";
    } else {
      return null;
    }
  }

  String? validateField(String? value) {
    if (value!.isEmpty) {
      return "Field can't be empty";
    } else {
      return null;
    }
  }

  String? validateInterest(String? value) {
    if (value!.isEmpty) {
      return "Interests can't be empty";
    } else {
      return null;
    }
  }

  String? validateNotes(String? value) {
    if (value!.isEmpty) {
      return "Additional Notes can't be empty";
    } else {
      return null;
    }
  }
}
