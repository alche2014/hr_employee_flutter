// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, file_names, prefer_const_constructors, sized_box_for_whitespace, must_be_immutable, duplicate_ignore, prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hr_app/colors.dart';

DateTime? _fromDate;
DateTime? _tillDate;

Future<dynamic> applyLeave(BuildContext context) {
  return showDialog(
    //showdialog on Apply now
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      // backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Apply Leave',
            style: TextStyle(color: kPrimaryRed),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close)),
        ],
      ), //on which popup pops
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeDropMenu('Type'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FromDate(),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TillDate(),
                      ),
                      // Align(
                      //     alignment: Alignment.centerRight,
                      //     child: SizedBox(width: 120, child: _FormDropMenu('Form'))),
                    ]),
              ),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Comment',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      //another pop used to show cleared and exit
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
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
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                height: 200,
                                child:
                                    Image.asset('assets/custom/truecheck.png')),
                            SizedBox(
                              height: 50,
                            ),
                            Text('You have Applied for your leave'),
                            Text('Waiting for approval'),
                          ],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      //button used in dialog
                      primary: Colors.red[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
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

class FromDate extends StatefulWidget {
  FromDate({Key? key}) : super(key: key);

  @override
  _FromDateState createState() => _FromDateState();
}

class _FromDateState extends State<FromDate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2022))
                  .then((value) {
                setState(() {
                  _fromDate = value;
                  print(_fromDate);
                });
              });
            },
            child: Text(
              _fromDate == null
                  ? 'From Date'
                  : '${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}'
                      .toString(),
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------//
class TillDate extends StatefulWidget {
  const TillDate({Key? key}) : super(key: key);

  @override
  _TillDateState createState() => _TillDateState();
}

class _TillDateState extends State<TillDate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (_fromDate != null) {
                showDatePicker(
                        context: context,
                        initialDate: DateTime(_fromDate!.year.toInt(),
                            _fromDate!.month.toInt(), _fromDate!.day.toInt()),
                        firstDate: DateTime(_fromDate!.year.toInt(),
                            _fromDate!.month.toInt(), _fromDate!.day.toInt()),
                        lastDate: DateTime(2022))
                    .then((value) {
                  setState(() {
                    _tillDate = value;
                    print(_tillDate);
                  });
                });
              }
            },
            child: Text(
              _tillDate == null
                  ? 'Till Date'
                  : '${_tillDate!.day}/${_tillDate!.month}/${_tillDate!.year}'
                      .toString(),
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}

//----------------------------------------------------------------//

// ignore: must_be_immutable
class _TypeDropMenu extends StatefulWidget {
  String hintTxt;
  _TypeDropMenu(this.hintTxt, {Key? key}) : super(key: key);
  @override
  _TypeDropMenuState createState() => _TypeDropMenuState();
}

class _TypeDropMenuState extends State<_TypeDropMenu> {
  final textFieldColor = Color(0xffFFFFFA);

  String? dropdownvalue;
  var items = [
    // 'Gender',
    'Causal',
    'Married',
    'Check up',
    'Sick',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),
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
    );
  }
}

class _FormDropMenu extends StatefulWidget {
  String hintText;
  _FormDropMenu(this.hintText, {Key? key}) : super(key: key);

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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Colors.grey.withOpacity(0.4),
          ),
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
