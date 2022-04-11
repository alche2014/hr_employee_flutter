import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';

import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:hr_app/Constants/colors.dart';
import 'dart:io';
import 'package:hr_app/Constants/constants.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

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
  var fileName;

  TextEditingController schoolController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController fieldController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController interestController = TextEditingController();

  DateTime? selectedDate;
  var dateFormat;
  DateTime? toselectedDate;
  var todateFormat;
  String? path;
  static var downloadUrl2;

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
    userId = widget.uid;

    if (widget.editable == true) {
      schoolController = TextEditingController(text: widget.data["school"]);
      notesController = TextEditingController(text: widget.data["notes"]);
      fileName =
          widget.data['fileName'] == null || widget.data['fileName'] == ""
              ? ""
              : widget.data['fileName'];
      dateFormat = widget.data['expstartDate'];
      todateFormat = widget.data['expLastDate'];
      fieldController = TextEditingController(text: widget.data['studyField']);
      interestController =
          TextEditingController(text: widget.data["interests"]);
      degreeController = TextEditingController(text: widget.data["degree"]);
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildMyAppBar(context, 'Education', false),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(15),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("  School", style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: schoolController,
                            style: TextFieldTextStyle(),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onSaved: (String? value) => school = value!,
                            decoration: TextFieldDecoration('School'),
                          ),
                          const SizedBox(height: 15),
                          Text("  Degree", style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: degreeController,
                            textInputAction: TextInputAction.done,
                            style: TextFieldTextStyle(),
                            decoration: TextFieldDecoration('Degree'),
                            onSaved: (String? value) => degree = value!,
                          ),
                          const SizedBox(height: 15),
                          Text("  Field of Study",
                              style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: TextFieldDecoration('Field of Study'),
                            controller: fieldController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onSaved: (String? value) => field = value!,
                            maxLines: null,
                          ),
                          const SizedBox(height: 15),
                          Text("  Year of Study",
                              style: TextFieldHeadingStyle()),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    showMonthPicker(
                                            context: context,
                                            firstDate: (DateTime.now())
                                                .subtract(const Duration(
                                                    days: 500000)),
                                            lastDate: toselectedDate,
                                            initialDate: DateTime.now())
                                        .then((date) => setState(() {
                                              selectedDate = date;
                                              dateFormat =
                                                  DateFormat("MMMM yyyy")
                                                      .format(selectedDate!);
                                            }));
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.white, width: 0),
                                    ),
                                    margin: const EdgeInsets.only(
                                        right: 5, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            alignment: Alignment.centerLeft,
                                            child: const Icon(
                                              Icons.date_range,
                                              color: purpleDark,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Text(
                                            dateFormat ?? "From",
                                            style: const TextStyle(
                                                color: Color(0xFF737373),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                fontFamily: "Poppins"),
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
                                            lastDate: (DateTime.now()).add(
                                                const Duration(days: 500000)),
                                            initialDate: DateTime.now())
                                        .then((date) => setState(() {
                                              toselectedDate = date;
                                              todateFormat =
                                                  DateFormat("MMMM yyyy")
                                                      .format(toselectedDate!);
                                            }));
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.white, width: 0),
                                    ),
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            alignment: Alignment.centerLeft,
                                            child: const Icon(
                                              Icons.date_range,
                                              color: purpleDark,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Text(
                                            todateFormat ?? "To",
                                            style: const TextStyle(
                                                color: Color(0xFF737373),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                fontFamily: "Poppins"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text("  Notes", style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            style: TextFieldTextStyle(),
                            decoration: TextFieldDecoration("Notes"),
                            controller: notesController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onSaved: (String? value) => notes = value!,
                            maxLines: null,
                          ),
                          const SizedBox(height: 15),
                          Text("  Interests", style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: interestController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            decoration: TextFieldDecoration("Interests"),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 15, bottom: 10),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: purpleLight),
                                    onPressed: () async {
                                      await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf', 'jpg'],
                                      ).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            path = value.toString();
                                          });
                                        }
                                      });
                                      File file = File(path!);
                                      fileName = file.path.split('/').last;
                                    },
                                    child: const Text('BROWSE')),
                              ),
                              const SizedBox(width: 25),
                              SizedBox(
                                height: 30,
                                child: InkWell(
                                    child: const Text("JPG Attachment",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue)),
                                    onTap: () async {
                                      await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['jpg'],
                                      ).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            path = value.toString();
                                          });
                                        }
                                      });
                                      File file = File(path!);
                                      fileName = file.path.split('/').last;
                                    }),
                              )
                            ],
                          ),
                          if (path != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, bottom: 10),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Text(fileName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        path = null;
                                        FilePicker.platform
                                            .clearTemporaryFiles()
                                            .then((result) {});
                                      });
                                    },
                                    icon: const Icon(Icons.close)),
                              ],
                            ),
                          if (path == null) const SizedBox(),
                          const SizedBox(height: 15),
                          saveButton(context, onpress)
                        ])))));
  }

  onpress() {
    if (schoolController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text('School name is empty',
              style: TextStyle(color: Colors.black)),
        ),
      );
    } else {
      if (widget.editable == true) {
        validateAndUpdate();
      } else {
        validateAndSave();
      }
    }
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            const LoadingDialog(value: "Loading")));
  }

  validateAndUpdate() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (dateFormat == "From" || dateFormat == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.white,
            content: Text("Kindly select date",
                style: TextStyle(color: Colors.black))));
      }
      if (todateFormat == "To" || todateFormat == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.white,
            content: Text("Kindly select date",
                style: TextStyle(color: Colors.black))));
      } else {
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
        DocumentReference qualifications = guest == 0
            ? FirebaseFirestore.instance.collection("guests").doc(userId)
            : FirebaseFirestore.instance.collection("employees").doc(userId);
        qualifications.update({
          "education": FieldValue.arrayRemove([widget.data])
        });
        Map<String, dynamic> serializedMessage = {
          "school": schoolController.text.isEmpty
              ? ""
              : schoolController.text[0].toUpperCase() +
                  schoolController.text.substring(1).toString(),
          "fileName":
              fileName == "" || fileName == null ? fileName : downloadUrl2,
          "degree": degreeController.text.isEmpty
              ? ""
              : degreeController.text[0].toUpperCase() +
                  degreeController.text.substring(1).toString(),
          "expstartDate": dateFormat ?? widget.data["expstartDate"],
          "expLastDate": todateFormat ?? widget.data["expLastDate"],
          "notes": notesController.text.isEmpty
              ? ""
              : notesController.text[0].toUpperCase() +
                  notesController.text.substring(1).toString(),
          "studyField": fieldController.text.isEmpty
              ? ""
              : fieldController.text[0].toUpperCase() +
                  fieldController.text.substring(1).toString(),
          "interests": interestController.text.isEmpty
              ? ""
              : interestController.text[0].toUpperCase() +
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

  validateAndSave() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (dateFormat == "From" || dateFormat == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.white,
            content: Text("Kindly select date",
                style: TextStyle(color: Colors.black))));
      } else if (todateFormat == "To" || todateFormat == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.white,
            content: Text("Kindly select date",
                style: TextStyle(color: Colors.black))));
      } else {
        int guest = 0;
        final user = FirebaseAuth.instance.currentUser!;

        await FirebaseFirestore.instance
            .collection("employees") //your collectionref
            .where('uid', isEqualTo: user.uid)
            .get()
            .then((value) {
          // var count = 0;
          guest = value.docs.length;
        });
        showLoadingDialog(context);
        DocumentReference chatroomRef = guest == 0
            ? FirebaseFirestore.instance.collection("guests").doc(userId)
            : FirebaseFirestore.instance.collection("employees").doc(userId);
        Map<String, dynamic> serializedMessage = {
          "school": schoolController.text.isEmpty
              ? ""
              : schoolController.text[0].toUpperCase() +
                  schoolController.text.substring(1).toString(),
          "degree": degreeController.text.isEmpty
              ? ""
              : degreeController.text[0].toUpperCase() +
                  degreeController.text.substring(1).toString(),
          "expstartDate": dateFormat,
          "expLastDate": todateFormat,
          "fileName":
              fileName == "" || fileName == null ? fileName : downloadUrl2,
          "notes": notesController.text.isEmpty
              ? ""
              : notesController.text[0].toUpperCase() +
                  notesController.text.substring(1).toString(),
          "studyField": fieldController.text.isEmpty
              ? ""
              : fieldController.text[0].toUpperCase() +
                  fieldController.text.substring(1).toString(),
          "interests": interestController.text.isEmpty
              ? ""
              : interestController.text[0].toUpperCase() +
                  interestController.text.substring(1).toString(),
        };

        chatroomRef.update({
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
