import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/colors.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MainSkills extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const MainSkills({Key? key, this.data}) : super(key: key);

  @override
  _MainSkillsState createState() => _MainSkillsState();
}

class _MainSkillsState extends State<MainSkills> {
  late String userId;
  late String compId;
  List<String> skillsList = [];
  List<String> userSkillList = [];
  final node = FocusNode();

  @override
  void initState() {
    super.initState();
    userId = widget.data["uid"];
    compId = widget.data["companyId"];
    FirebaseFirestore.instance
        .collection('company')
        .doc(compId)
        .get()
        .then((onValue) {
      if (onValue["skills"] != null) {
        onValue["skills"].forEach((doc) {
          skillsList.add(doc.toString());
        });
      }
    });
    if (widget.data["skills"] != null) {
      for (int i = 0; i < widget.data["skills"].length; i++) {
        userSkillList.add(widget.data["skills"][i]);
      }
    }
  }

  final TextEditingController _textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: buildMyAppBar(context, 'Skills', true),
        body: Stack(
          children: [
            const BackgroundCircle(),
            SingleChildScrollView(
              child: Container(
                margin: Platform.isIOS
                    ? const EdgeInsets.only(
                        left: 15, right: 12, bottom: 50, top: 120)
                    : const EdgeInsets.only(
                        left: 15, right: 12, bottom: 15, top: 90),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            focusNode: node,
                            style: TextFieldTextStyle(),
                            decoration: TextFieldDecoration('Add your Skills'),
                            controller: _textcontroller,
                          ),
                          suggestionsCallback: (Pattern) => skillsList.where(
                            (element) => element
                                .toLowerCase()
                                .contains(Pattern.toLowerCase()),
                          ),
                          getImmediateSuggestions: true,
                          hideSuggestionsOnKeyboardHide: false,
                          onSuggestionSelected: (value) {
                            setState(() {
                              if (userSkillList.contains(value)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Already Selected'),
                                  ),
                                );
                              } else {
                                userSkillList.add(value.toString());
                              }
                            });
                          },
                          itemBuilder: (_, String element) {
                            return ListTile(
                              title: Text(element),
                            );
                          },
                          noItemsFoundBuilder: (context) {
                            return Column(
                              children: [
                                const ListTile(
                                  title: Text('No Sugestion Found'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.add),
                                  title: const Text('Add to List'),
                                  onTap: () {
                                    setState(() {
                                      userSkillList.add(_textcontroller.text);
                                      skillsList.add(_textcontroller.text);
                                      _textcontroller.clear();
                                      node.unfocus();
                                    });
                                  },
                                )
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        if (userSkillList.isNotEmpty)
                          Wrap(
                            spacing: 6.0,
                            runSpacing: 6.0,
                            children: List<Widget>.generate(
                                userSkillList.length, (int index) {
                              return Chip(
                                label: Text(userSkillList[index]),
                                onDeleted: () {
                                  setState(() {
                                    userSkillList.removeAt(index);
                                  });
                                },
                              );
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 60),
                  ],
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
                      primary: darkRed,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: () {
                      if (userSkillList.isNotEmpty) {
                        validateAndSave(userSkillList);

                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add some Skills'),
                          ),
                        );
                      }
                    }),
              ),
            )
          ],
        ));
  }

  validateAndSave(skills) async {
    showLoadingDialog(context);
    int guest = 0;
    showLoadingDialog(context);
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection("employees")
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((value) {
      guest = value.docs.length;
    });
    if (guest == 0) {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        DocumentReference guestReference =
            FirebaseFirestore.instance.collection("guests").doc(user.uid);
        await guestReference.update({"skills": userSkillList});
      }).whenComplete(() {
        Navigator.pop(context);

        Fluttertoast.showToast(msg: "Skills is updated successfully");
      }).catchError((e) {
        // ignore: avoid_print
        print('======Error====$e==== ');
      });
      Future.delayed(const Duration(milliseconds: 1150), () {
        Navigator.of(context).pop();
      });
    } else {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        DocumentReference reference =
            FirebaseFirestore.instance.collection("employees").doc(userId);

        await reference.update({"skills": userSkillList});
      }).whenComplete(() {
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 1150), () {
          Navigator.of(context).pop();
        });

        Fluttertoast.showToast(msg: "Skills is updated successfully");
      }).catchError((e) {
        // ignore: avoid_print
        print('======Error====$e==== ');
      });
    }
  }

  void showLoadingDialog(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingDialog()));
  }
}
