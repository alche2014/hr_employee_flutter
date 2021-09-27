import 'package:flutter/material.dart';

class DropDownOpt extends StatefulWidget {    //dropdown
  @override
  State<DropDownOpt> createState() => _DropDownOptState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DropDownOptState extends State<DropDownOpt> {      //dropdown
  String dropdownValue = 'January';

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
      items: <String>['January', 'Feb', 'March']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value), //using a string value
        );
      }).toList(),
      underline: DropdownButtonHideUnderline(child: Container()),
    );
  }
}