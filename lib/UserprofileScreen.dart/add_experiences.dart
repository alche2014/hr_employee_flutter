// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_string_escapes, prefer_const_declarations, prefer_const_constructors
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';

import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/constants.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class AddExperience extends StatelessWidget {
  final data, uid, editable;
  AddExperience({Key? key, this.data, this.uid, this.editable})
      : super(key: key);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: buildMyAppBar(context, 'Experience', true),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 15, right: 12, bottom: 15, top: 15),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  child: AddExperienceBody(
                      userData: data, editExp: editable, uid: uid),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddExperienceBody extends StatefulWidget {
  final userData, editExp, uid;
  const AddExperienceBody({Key? key, this.userData, this.editExp, this.uid})
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
  String? path;

  var todateFormat;
  var fileName;

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
  static var downloadUrl2;
  static Future<String> uploadExperienceImage(image, userID) async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child("Experience/$userID.png");
    // UploadTask uploadTask = upload.putFile(image);
    final UploadTask uploadTask = storageRef.putFile(image);
    await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl2.toString();
  }

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
      companyNameController = TextEditingController(
        text: widget.userData["companyName"],
      );
      titlesController = TextEditingController(
        text: widget.userData["title"],
      );
      descriptionController = TextEditingController(
        text: widget.userData["jobDescription"],
      );
      fileName = widget.userData['fileName'] == null ||
              widget.userData['fileName'] == ""
          ? ""
          : widget.userData['fileName'];
      dateFormat = widget.userData['expstartDate'];
      todateFormat = widget.userData['expLastDate'];
      headlineController =
          TextEditingController(text: widget.userData["expHeadline"]);
      empStatus = widget.userData['empStatus'];

      locationController = TextEditingController(
        text: widget.userData["expLocation"],
      );
      checkedValue = widget.userData['currentyWorkingCheck'];

      industryValue = widget.userData['industry'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: titlesController,
              style: TextFieldTextStyle(),
              textInputAction: TextInputAction.next,
              decoration: TextFieldDecoration('Title'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    labelText: "Employement Status",
                    labelStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
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
                    FocusManager.instance.primaryFocus?.unfocus();
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
              textInputAction: TextInputAction.next,
              decoration: TextFieldDecoration('Company Name'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextFieldTextStyle(),
            ),
            const SizedBox(height: 10),
            //-------------------------------------------------//
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: locationController,
              textInputAction: TextInputAction.next,
              decoration: TextFieldDecoration('Location'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextFieldTextStyle(),
            ),
            const SizedBox(height: 8),
            //-------------------------------------------------//
            Row(children: [
              Checkbox(
                value: checkedValue,
                activeColor: purpleDark,
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
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(4)),
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
                    child: checkedValue == false
                        ? Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1),
                                borderRadius: BorderRadius.circular(4)),
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
                                            toselectedDate = date;
                                            todateFormat =
                                                DateFormat("MMMM yyyy")
                                                    .format(toselectedDate!);
                                          }));
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        todateFormat ?? " End Date",
                                      )),
                                ],
                              ),
                            ),
                          )
                        : Container()),
              ]),
            ),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: headlineController,
              textInputAction: TextInputAction.next,
              decoration: TextFieldDecoration('Headline'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextFieldTextStyle(),
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
                    labelText: "Industry",
                    labelStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
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
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              controller: descriptionController,
              textInputAction: TextInputAction.done,
              maxLines: 5,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                labelText: "Description",
                isDense: true,
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextFieldTextStyle(),
            ),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15, bottom: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: checkedValue == false
                              ? Colors.grey
                              : purpleLight),
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
                checkedValue != false
                    ? SizedBox(
                        height: 30,
                        child: InkWell(
                            child: const Text("JPG Attachment",
                                style: const TextStyle(
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
                    : const SizedBox(),
              ],
            ),
            if (path != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, bottom: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
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
            const SizedBox(height: 20),
            SizedBox(
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
        ));
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
        "title": titlesController.text.isEmpty
            ? ""
            : titlesController.text[0].toUpperCase() +
                titlesController.text.substring(1).toString(),
        "companyName": companyNameController.text.isEmpty
            ? ""
            : companyNameController.text[0].toUpperCase() +
                companyNameController.text.substring(1).toString(),
        "expstartDate": dateFormat,
        "expLastDate": todateFormat,
        "jobDescription": descriptionController.text.isEmpty
            ? ""
            : descriptionController.text[0].toUpperCase() +
                descriptionController.text.substring(1).toString(),
        "empStatus": empStatus,
        "expHeadline": headlineController.text.isEmpty
            ? ""
            : headlineController.text[0].toUpperCase() +
                headlineController.text.substring(1).toString(),
        "industry": industryValue,
        "expLocation": locationController.text.isEmpty
            ? ""
            : locationController.text[0].toUpperCase() +
                locationController.text.substring(1).toString(),
        "currentyWorkingCheck": checkedValue,
        "fileName":
            fileName == "" || fileName == null ? fileName : downloadUrl2,
      };
      chatroomRef.update({
        "workExperience": FieldValue.arrayUnion([serializedMessage])
      });
      Future.delayed(Duration(milliseconds: 1050), () {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Experience is added successfully");
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
      DocumentReference qualifications = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(userId)
          : FirebaseFirestore.instance.collection("employees").doc(userId);

      qualifications.update({
        "workExperience": FieldValue.arrayRemove([widget.userData])
      });
      Map<String, dynamic> serializedMessage = {
        "fileName":
            fileName == "" || fileName == null ? fileName : downloadUrl2,
        "title": titlesController.text.isEmpty
            ? ""
            : titlesController.text[0].toUpperCase() +
                titlesController.text.substring(1).toString(),
        "companyName": companyNameController.text.isEmpty
            ? ""
            : companyNameController.text[0].toUpperCase() +
                companyNameController.text.substring(1).toString(),
        "expstartDate": dateFormat,
        "expLastDate": todateFormat,
        "jobDescription": descriptionController.text.isEmpty
            ? ""
            : descriptionController.text[0].toUpperCase() +
                descriptionController.text.substring(1).toString(),
        "empStatus": empStatus,
        "expHeadline": headlineController.text.isEmpty
            ? ""
            : headlineController.text[0].toUpperCase() +
                headlineController.text.substring(1).toString(),
        "industry": industryValue,
        "expLocation": locationController.text.isEmpty
            ? ""
            : locationController.text[0].toUpperCase() +
                locationController.text.substring(1).toString(),
        "currentyWorkingCheck": checkedValue,
      };
      qualifications.update({
        "workExperience": FieldValue.arrayUnion([serializedMessage])
      });
      Future.delayed(Duration(milliseconds: 1050), () {
        setState(() {});
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Experience is added successfully");
      });
      Future.delayed(Duration(milliseconds: 1150), () {
        Navigator.of(context).pop();
      });
    } else {
      return ('form is valid');
    }
  }
}
