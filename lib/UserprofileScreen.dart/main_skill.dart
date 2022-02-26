import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';

import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/constants.dart';
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
  int guest = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    userId = widget.data["uid"];

    await FirebaseFirestore.instance
        .collection("employees")
        .where('uid', isEqualTo: userId)
        .get()
        .then((value) {
      guest = value.docs.length;
    });
    if (guest != 0) {
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
    }
    if (widget.data["skills"] != null) {
      for (int i = 0; i < widget.data["skills"].length; i++) {
        userSkillList.add(widget.data["skills"][i]);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final TextEditingController _textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildMyAppBar(context, 'Skills', true),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 15, top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            textCapitalization: TextCapitalization.sentences,
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
                      primary: purpleDark,
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
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(userId)
          : FirebaseFirestore.instance.collection("employees").doc(userId);

      await reference.update({"skills": userSkillList});
    }).whenComplete(() {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 1150), () {
        Navigator.pop(context);
      });
      Fluttertoast.showToast(msg: "Skills is updated successfully");
    }).catchError((e) {});
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            LoadingDialog(value: "Loading")));
  }
}