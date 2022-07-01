// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_string_escapes, prefer_const_declarations, prefer_const_constructors
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'dart:io';

class AddTrainings extends StatefulWidget {
  final data, editable, uid;
  const AddTrainings({Key? key, this.data, this.editable, this.uid})
      : super(key: key);

  @override
  _AddTrainingsState createState() => _AddTrainingsState();
}

class _AddTrainingsState extends State<AddTrainings> {
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;
  var fileName;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? type;
  TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;
  String? path;

  var dateFormat;
  DateTime? toselectedDate;
  var todateFormat;
  static var downloadUrl2;
  static Reference storage = FirebaseStorage.instance.ref();

  static Future<String> uploadTrainingsImage(image, uid) async {
    Reference upload = storage.child("Trainings/$uid.png");
    UploadTask uploadTask = upload.putFile(image);
    downloadUrl2 =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl2.toString();
  }

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
      if (widget.data["type"] != "null") {
        type = widget.data["type"];
      }
      fileName =
          widget.data['fileName'] == null || widget.data['fileName'] == ""
              ? ""
              : widget.data['fileName'];
      dateFormat = widget.data['startDate'];
      todateFormat = widget.data['endDate'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildMyAppBar(context, 'Trainings', false),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(15),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 15),
                        Text("  Training Type", style: TextFieldHeadingStyle()),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.white, width: 0)),
                          child: DropdownButtonFormField<String>(
                            decoration: TextFieldDecoration("Training Type"),
                            value: type,
                            items: <String>[
                              "Lecture",
                              "Online",
                              "Seminar",
                              "Webinar",
                              "Workshop"
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
                                FocusManager.instance.primaryFocus?.unfocus();
                                type = newValue!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text("  Training Dates",
                            style: TextFieldHeadingStyle()),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(children: [
                            Expanded(
                                child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(10)),
                              child: InkWell(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          dateFormat ?? "Start Date",
                                          style: TextStyle(
                                              color: Color(0xFF737373),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              fontFamily: "Poppins"),
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Icon(Icons.date_range,
                                            size: 22, color: purpleDark))
                                  ],
                                ),
                              ),
                            )),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                                child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(10)),
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
                                            todateFormat =
                                                DateFormat("MMMM yyyy")
                                                    .format(toselectedDate!);
                                          }));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          todateFormat ?? " End Date",
                                          style: TextStyle(
                                              color: Color(0xFF737373),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              fontFamily: "Poppins"),
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Icon(Icons.date_range,
                                            size: 22, color: purpleDark))
                                  ],
                                ),
                              ),
                            )),
                          ]),
                        ),
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
                                          decoration: TextDecoration.underline,
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
                                margin:
                                    const EdgeInsets.only(left: 20, bottom: 10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(fileName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: const TextStyle()),
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
                      ],
                    )))));
  }

  onpress() {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text('Name is empty', style: TextStyle(color: Colors.black)),
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

  validateAndSave() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      showLoadingDialog(context);
      DocumentReference trainings = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(uid)
          : FirebaseFirestore.instance.collection("employees").doc(uid);
      Map<String, dynamic> serializedMessage = {
        "name": nameController.text.isEmpty
            ? ""
            : nameController.text[0].toUpperCase() +
                nameController.text.substring(1).toString(),
        "type": type.toString(),
        "expstartDate": dateFormat,
        "expLastDate": todateFormat,
        "fileName":
            fileName == "" || fileName == null ? fileName : downloadUrl2,
      };
      trainings.update({
        "trainings": FieldValue.arrayUnion([serializedMessage])
      });
      Future.delayed(Duration(milliseconds: 1050), () {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Training is added successfully");
      });
      Navigator.of(context).pop();
      Future.delayed(Duration(milliseconds: 1150), () {});
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
      DocumentReference trainings = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(uid)
          : FirebaseFirestore.instance.collection("employees").doc(uid);
      trainings.update({
        "trainings": FieldValue.arrayRemove([widget.data])
      });
      Map<String, dynamic> serializedMessage = {
        "name": nameController.text.isEmpty
            ? ""
            : nameController.text[0].toUpperCase() +
                nameController.text.substring(1).toString(),
        "type": type.toString(),
        "expstartDate": dateFormat,
        "expLastDate": todateFormat,
        "fileName":
            fileName == "" || fileName == null ? fileName : downloadUrl2,
      };
      trainings.update({
        "trainings": FieldValue.arrayUnion([serializedMessage])
      });
      Future.delayed(Duration(milliseconds: 1050), () {
        setState(() {});
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Training is updated successfully");
      });
      Future.delayed(Duration(milliseconds: 1150), () {
        Navigator.of(context).pop();
      });
    } else {
      return ('form is valid');
    }
  }
}
