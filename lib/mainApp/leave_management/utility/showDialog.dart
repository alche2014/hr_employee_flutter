// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, file_names, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

Future<dynamic> applyLeave(BuildContext context) {
  return showDialog(
    //showdialog on Apply now
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Apply Leave'),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close)),
        ],
      ), //on which popup pops
      content: Container(
        width: MediaQuery.of(context).size.width * 1,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypeDropMenu('Type'),
              TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                      hintText: 'Comment',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          )))),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      //another pop used to show cleared and exit
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        content: SingleChildScrollView(
                          child: Container(
                            // height: 320,
                            color: Colors.white,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey[100],
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundImage: const AssetImage(
                                      "assets/custom/truecheck.png"), //using profilepic
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Text('You have Applied for your leave'),
                                Text('Waiting for approval'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      //button used in dialog
                      primary: Colors.red[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Apply Now',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    ),
  );
}

//===========================================================================//
// ignore: must_be_immutable
class TypeDropMenu extends StatefulWidget {
  String hintTxt;
  TypeDropMenu(this.hintTxt, {Key? key}) : super(key: key);
  @override
  _TypeDropMenuState createState() => _TypeDropMenuState();
}

class _TypeDropMenuState extends State<TypeDropMenu> {
  final textFieldColor = Color(0xffFFFFFA);

  String? dropdownvalue;
  var items = [
    // 'Gender',
    'Causal',
    'Married',
    'Check up',
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                elevation: 0,
                hint: Text(
                  '${widget.hintTxt}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                value: dropdownvalue,
                icon: Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(value: items, child: Text(items));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormDropMenu extends StatefulWidget {
  String hintText;
   _FormDropMenu(this.hintText ,{Key? key}) : super(key: key);

  @override
  _FormDropMenuState createState() => _FormDropMenuState();
}

class _FormDropMenuState extends State<_FormDropMenu> {
  String? dropdownvalue;
  var items = [
    // 'Gender',
    'Causal',
    'Married',
    'Check up',
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                elevation: 0,
                hint: Text(
                  '${widget.hintText}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                value: dropdownvalue,
                icon: Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(value: items, child: Text(items));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
