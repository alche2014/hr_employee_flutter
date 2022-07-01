import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/main.dart';

class AddAboutScreen extends StatefulWidget {
  const AddAboutScreen({Key? key, this.title}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final title;
  @override
  _AddAboutScreenState createState() => _AddAboutScreenState();
}

class _AddAboutScreenState extends State<AddAboutScreen> {
  TextEditingController descriptionController = TextEditingController();
  String? description;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    descriptionController =
        TextEditingController(text: widget.title["aboutYou"] ?? null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildMyAppBar(context, 'About Me', true),
        body: Container(
          margin: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("  About Yourself", style: TextFieldHeadingStyle()),
                  const SizedBox(height: 10),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: descriptionController,
                    maxLines: 10,
                    style: TextFieldTextStyle(),
                    decoration: TextFieldDecoration('Write about yourself'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 15),
                  saveButton(context, onpress)
                ],
              ),
            ),
          ),
        ));
  }

  onpress() {
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text('Write about yourself',
              style: TextStyle(color: Colors.black)),
        ),
      );
    } else {
      validateAndSave();
    }
  }

  validateAndSave() async {
    setState(() {});
    final form = formKey.currentState;
    if (form!.validate()) {
      showLoadingDialog(context);
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        DocumentReference reference = guest == 0
            ? FirebaseFirestore.instance.collection("guests").doc(uid)
            : FirebaseFirestore.instance.collection("employees").doc(uid);
        await reference.update({
          "aboutYou": descriptionController.text,
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
