// ignore: file_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_quill/models/documents/document.dart';
// import 'package:flutter_quill/widgets/controller.dart';
// import 'package:flutter_quill/widgets/default_styles.dart';
// import 'package:flutter_quill/widgets/editor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';
import 'package:hr_app/background/background.dart';
import '../../colors.dart';
// import 'package:tuple/tuple.dart';

import 'Announcemets/constants.dart';

class AddAboutScreen extends StatefulWidget {
  const AddAboutScreen({Key? key, required this.title}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final title;
  @override
  _AddAboutScreenState createState() => _AddAboutScreenState();
}

class _AddAboutScreenState extends State<AddAboutScreen> {
  TextEditingController descriptionController = TextEditingController();
  late String userId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Future<void> _loadFromAssets() async {
  //   try {
  //     final result = await rootBundle.loadString('assets/sample_data.json');
  //     final doc = Document.fromJson(jsonDecode(result));
  //     setState(() {
  //       _controller = QuillController(
  //           document: doc, selection: const TextSelection.collapsed(offset: 0));
  //     });
  //   } catch (error) {
  //     final doc = Document()..insert(0, 'Empty asset');
  //     setState(() {
  //       _controller = QuillController(
  //           document: doc, selection: const TextSelection.collapsed(offset: 0));
  //     });
  //   }
  // }

  // final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // _loadFromAssets();

    descriptionController = TextEditingController(
      text: widget.title["aboutYou"],
    );
  }

  // QuillController? _controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: buildMyAppBar(context, 'About', true),
          body: Stack(children: [
            const BackgroundCircle(),
            SingleChildScrollView(
                child: Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 15, top: 90),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: descriptionController,
                      maxLines: null,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('Write about yourself'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 60),
                  ],
                ),

                //     Column(
                //   children: [
                //     QuillEditor(
                //         controller: _controller!,
                //         scrollController: ScrollController(),
                //         scrollable: true,
                //         focusNode: _focusNode,
                //         autoFocus: false,
                //         readOnly: false,
                //         placeholder: 'Add content',
                //         expands: false,
                //         padding: EdgeInsets.zero,
                //         customStyles: DefaultStyles(
                //           h1: DefaultTextBlockStyle(
                //               const TextStyle(
                //                 fontSize: 32,
                //                 color: Colors.black,
                //                 height: 1.15,
                //                 fontWeight: FontWeight.w300,
                //               ),
                //               const Tuple2(16, 0),
                //               const Tuple2(0, 0),
                //               null),
                //           sizeSmall: const TextStyle(fontSize: 9),
                //         )),
                //     const SizedBox(height: 60),
                //   ],
                // )),
              ),
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 12, bottom: 15),
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  child: Text('SAVE'), //next button
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    primary: darkRed,
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
    final form = _formKey.currentState;
    if (form!.validate()) {
      int guest = 0;
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
        FirebaseFirestore.instance
            .runTransaction((Transaction transaction) async {
          DocumentReference guestReference =
              FirebaseFirestore.instance.collection("guests").doc(user.uid);

          await guestReference.update({
            "aboutYou": descriptionController.text == ""
                ? null
                : descriptionController.text,
          });
        }).whenComplete(() {
          Navigator.pop(context);

          Fluttertoast.showToast(msg: "About  info is updated successfully");
        }).catchError((e) {
          print('======Error====$e==== ');
        });
        Future.delayed(const Duration(milliseconds: 1150), () {
          Navigator.of(context).pop();
        });
      } else {
        FirebaseFirestore.instance
            .runTransaction((Transaction transaction) async {
          DocumentReference reference =
              FirebaseFirestore.instance.collection("employees").doc(user.uid);

          await reference.update({
            "aboutYou": descriptionController.text == ""
                ? null
                : descriptionController.text,
          }).whenComplete(() {
            Navigator.pop(context);

            Fluttertoast.showToast(msg: "About  info is updated successfully");
          }).catchError((e) {
            print('======Error====$e==== ');
          });

          Future.delayed(Duration(milliseconds: 1150), () {
            Navigator.of(context).pop();
          });
        });
      }
    }
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingDialog()));
  }
}
