import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DropDownOpt extends StatefulWidget {
  //dropdown
  @override
  State<DropDownOpt> createState() => _DropDownOptState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DropDownOptState extends State<DropDownOpt> {
  //dropdown
  String dropdownValue = 'January';
  @override
  void initState() {
    dropdownValue = DateFormat('MMMM').format(DateTime.now()).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down_sharp),
      iconSize: 40,
      elevation: 20,
      // style: const TextStyle(color: Colors.black),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>[
        'January',
        'February',
        'March ',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value), //using a string value
        );
      }).toList(),
      underline: DropdownButtonHideUnderline(child: Container()),
    );
  }
}
