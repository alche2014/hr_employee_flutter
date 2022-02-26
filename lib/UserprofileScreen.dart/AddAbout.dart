import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/loadingDailog.dart';

import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:hr_app/Constants/constants.dart';

class AddAboutScreen extends StatefulWidget {
  const AddAboutScreen({Key? key, this.title}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final title;
  @override
  _AddAboutScreenState createState() => _AddAboutScreenState();
}

class _AddAboutScreenState extends State<AddAboutScreen> {
  TextEditingController descriptionController = TextEditingController();
  String? userId;
  String? description;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userId = widget.title["uid"];

    descriptionController =
        TextEditingController(text: widget.title["aboutYou"] ?? null);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
          appBar: buildMyAppBar(context, 'About', true),
          body: Stack(children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 15, top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: descriptionController,
                        maxLines: 10,
                        style: TextFieldTextStyle(),
                        decoration: TextFieldDecoration('Write about yourself'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 12, bottom: 15),
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  child: const Text('SAVE'), //next button
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    primary: purpleDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  onPressed: () {
                    validateAndSave();
                  },
                ),
              ),
            )
          ])),
    );
  }

  validateAndSave() async {
    setState(() {});
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

      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        DocumentReference reference = guest == 0
            ? FirebaseFirestore.instance.collection("guests").doc(userId)
            : FirebaseFirestore.instance.collection("employees").doc(userId);
        await reference.update({
          "aboutYou": descriptionController.text == ""
              ? null
              : descriptionController.text,
        });
      }).whenComplete(() {
        Navigator.pop(context);

        Fluttertoast.showToast(msg: "Data is updated Successfully");
      }).catchError((e) {});
      Future.delayed(const Duration(milliseconds: 1150), () {
        Navigator.of(context).pop();
      });
      // }
    } else {}
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            const LoadingDialog(value: "Loading")));
  }
}
