import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/work_info/utility/build_my_input_decoration.dart';

class MainDependent extends StatefulWidget {
  const MainDependent({Key? key}) : super(key: key);

  @override
  State<MainDependent> createState() => _MainDependentState();
}

class _MainDependentState extends State<MainDependent> {
  @override
  Widget build(BuildContext context) {
    var dropGenderValue;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Dependent', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(children: [
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: buildMyInputDecoration(context, 'School'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        final pattern = ('[a-zA-Z]+([\s][a-zA-Z]+)*');
                        final regExp = RegExp(pattern);
                        if (value!.isEmpty) {
                          return null;
                        } else if (!regExp.hasMatch(value)) {
                          return 'Enter only Alphabets';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    //-------------------------------------------------//
                    SizedBox(
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300.withOpacity(0.8),
                            width: 2,
                          ),
                        ),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              hintText: "Relation",
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor),
                          value: dropGenderValue,
                          items: <String>['Permanent', 'Temporary']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              dropGenderValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    //-------------------------------------------------//
                    TextFormField(
                      decoration: buildMyInputDecoration(context, 'Phone'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        final pattern = ('[0-9]');
                        final regExp = RegExp(pattern);
                        if (value!.isEmpty) {
                          return null;
                        } else if (!regExp.hasMatch(value)) {
                          return 'Enter only Alphabets';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    //-------------------------------------------------//
                    TextFormField(
                      maxLines: 5,
                      decoration:
                          buildMyInputDecoration(context, 'Description'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        final pattern = ('[a-zA-Z]+([\s][a-zA-Z]+)*');
                        final regExp = RegExp(pattern);
                        if (value!.isEmpty) {
                          return null;
                        } else if (!regExp.hasMatch(value)) {
                          return 'Enter only Alphabets';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                  ]),
                ),
                //===========================================//
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            child: const Text('SAVE'), //next button
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              primary: Color(0xffC53B4B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => SecondProfile()));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
