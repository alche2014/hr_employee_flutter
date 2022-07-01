import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hr_app/main.dart';

class MainSkills extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const MainSkills({Key? key, this.data}) : super(key: key);

  @override
  _MainSkillsState createState() => _MainSkillsState();
}

class _MainSkillsState extends State<MainSkills> {
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
    if (guest != 0) {
      compId = widget.data["companyId"];
      FirebaseFirestore.instance
          .collection('company')
          .doc(compId)
          .get()
          .then((onValue) {
        setState(() {
          if (onValue["skills"] != null) {
            onValue["skills"].forEach((doc) {
              skillsList.add(doc.toString());
            });
          }
        });
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
        backgroundColor: Colors.grey.shade100,
        appBar: buildMyAppBar(context, 'Skills', true),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("  Add your Skills", style: TextFieldHeadingStyle()),
                const SizedBox(height: 10),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    textCapitalization: TextCapitalization.sentences,
                    focusNode: node,
                    style: TextFieldTextStyle(),
                    decoration: TextFieldDecoration('Add your Skills'),
                    controller: _textcontroller,
                  ),
                  suggestionsCallback: (Pattern) => skillsList.where(
                    (element) =>
                        element.toLowerCase().contains(Pattern.toLowerCase()),
                  ),
                  getImmediateSuggestions: true,
                  hideSuggestionsOnKeyboardHide: false,
                  onSuggestionSelected: (value) {
                    setState(() {
                      if (userSkillList.contains(value)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.white,
                            content: Text('Already Selected',
                                style: TextStyle(color: Colors.black)),
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
                    children: List<Widget>.generate(userSkillList.length,
                        (int index) {
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
                const SizedBox(height: 15),
                saveButton(context, onpress)
              ],
            ),
          ),
        ));
  }

  onpress() {
    if (userSkillList.isNotEmpty) {
      validateAndSave(userSkillList);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content:
              Text('Add some Skills', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }

  validateAndSave(skills) async {
    showLoadingDialog(context);
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference = guest == 0
          ? FirebaseFirestore.instance.collection("guests").doc(uid)
          : FirebaseFirestore.instance.collection("employees").doc(uid);

      await reference.update({"skills": userSkillList});
    }).whenComplete(() {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 1150), () {});
      Fluttertoast.showToast(msg: "Skills are added successfully");
    }).catchError((e) {});
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            const LoadingDialog(value: "Loading")));
  }
}
