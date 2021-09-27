import 'package:flutter/material.dart';

  Future<dynamic> applyLeave(BuildContext context) {
    return showDialog(               //showdialog on Apply now 
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Text('Apply Leave'), //on which popup pops
                        content: SingleChildScrollView(
                          child: Container(
                            height: 320,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Drop('Date'),
                                Drop('Leave Type'),
                                TextField(
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                        hintText: 'Comment',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            )))),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(         //another pop used to show cleared and exit
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          title: Row(
                                            children: [
                                              SizedBox(
                                                width: 210,
                                              ),
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
                                                  Icon(
                                                    Icons.check_circle,
                                                    size: 60,
                                                    color: Colors.green,
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  Text(
                                                      'You have Applied for your leave'),
                                                  Text(
                                                      'Waiting for approval'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom( //button used in dialog
                                        primary: Colors.red[800],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
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
class Drop extends StatefulWidget {
  String hintTxt;
  Drop(this.hintTxt);
  @override
  _DropState createState() => _DropState();
}

class _DropState extends State<Drop> {
  final textFieldColor = Color(0xffFFFFFA);

  String? dropdownvalue;
  var items = [
    // 'Gender',
    '1',
    '2',
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffFFFFFA),
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