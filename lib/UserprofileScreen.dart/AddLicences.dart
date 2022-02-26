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
import 'package:intl/intl.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'dart:io';

class AddLicencesInfo extends StatelessWidget {
  final data, uid, editable;
  const AddLicencesInfo({Key? key, this.data, this.uid, this.editable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMyAppBar(context, 'Licences & Certificates', true),
      body: Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.only(bottom: 15, top: 15, left: 10, right: 10),
            child: SingleChildScrollView(
              child: AddKinBody(userData: data, editExp: editable, uid: uid),
            ),
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
  var fileName;
  String? path;

  late String userId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? type;
  DateTime? selectedDate;
  var dateFormat;
  DateTime? toselectedDate;
  var todateFormat;
  TextEditingController nameController = TextEditingController();
  static var downloadUrl2;
  static Reference storage = FirebaseStorage.instance.ref();

  static Future<String> uploadLicensesImage(image, userID) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child("Licenses/$userID.png");
    // UploadTask uploadTask = upload.putFile(image);
    final UploadTask uploadTask = storageRef.putFile(image);
    downloadUrl2 =
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
      nameController = TextEditingController(text: widget.userData["name"]);
      if (widget.userData["type"] != "null") {
        type = widget.userData["type"];
      }
      fileName = widget.userData['fileName'] == null ||
              widget.userData['fileName'] == ""
          ? ""
          : widget.userData['fileName'];
      dateFormat = widget.userData['startDate'];
      todateFormat = widget.userData['endDate'];
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
              controller: nameController,
              style: TextFieldTextStyle(),
              textInputAction: TextInputAction.next,
              decoration: TextFieldDecoration('Institute Name'),
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
                    labelText: "Certificate Type",
                    labelStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.transparent),
                value: type,
                items: <String>["Technical", "Business"]
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
                    type = newValue!;
                  });
                },
              ),
            ),
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
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(4)),
                  child: InkWell(
                    onTap: () {
                      showMonthPicker(
                              context: context,
                              firstDate: selectedDate,
                              lastDate:
                                  (DateTime.now()).add(Duration(days: 500000)),
                              initialDate: DateTime.now())
                          .then((date) => setState(() {
                                toselectedDate = date;
                                todateFormat = DateFormat("MMMM yyyy")
                                    .format(toselectedDate!);
                              }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              todateFormat ?? " End Date",
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
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15, bottom: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: purpleLight),
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
      DocumentReference dependents = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(userId)
          : FirebaseFirestore.instance.collection("employees").doc(userId);
      Map<String, dynamic> serializedMessage = {
        "name": nameController.text.isEmpty
            ? ""
            : nameController.text[0].toUpperCase() +
                nameController.text.substring(1).toString(),
        "type": type.toString(),
        "startDate": dateFormat,
        "endDate": todateFormat,
        "fileName":
            fileName == "" || fileName == null ? fileName : downloadUrl2,
      };
      dependents.update({
        "licenses": FieldValue.arrayUnion([serializedMessage])
      });
      Future.delayed(Duration(milliseconds: 1050), () {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "License is added successfully");
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
        "licenses": FieldValue.arrayRemove([widget.userData])
      });
      Map<String, dynamic> serializedMessage = {
        "name": nameController.text.isEmpty
            ? ""
            : nameController.text[0].toUpperCase() +
                nameController.text.substring(1).toString(),
        "type": type.toString(),
        "startDate": dateFormat,
        "endDate": todateFormat,
        "fileName":
            fileName == "" || fileName == null ? fileName : downloadUrl2,
      };
      dependents.update({
        "licenses": FieldValue.arrayUnion([serializedMessage])
      });
      Future.delayed(Duration(milliseconds: 1050), () {
        setState(() {});
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "License is updated successfully");
      });
      Future.delayed(Duration(milliseconds: 1150), () {
        Navigator.of(context).pop();
      });
    } else {
      return ('form is valid');
    }
  }
}
