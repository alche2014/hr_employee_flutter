// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';

class WorkInfoCard extends StatelessWidget {
  const WorkInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Work Info',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: darkRed)),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit_outlined, color: Colors.grey)),
              ]),
              Row(children: [
                Text('Employee Type: '),
                Text('Full Time', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: [
                Text('Office Timing: '),
                Text('9 - 6 Morning', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: [
                Text('Designation: '),
                Text('UI UX Design', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: [
                Text('Role: '),
                Text('UI UX', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: [
                Text('Department: '),
                Text('App Design', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: [
                Text('Reporting to: '),
                Text('Soud Haroon', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: [
                Text('Phone: '),
                Text('03244094880', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: [
                Text('Date Joining: '),
                Text('2 Aug 2021', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: [
                Text('Location: '),
                Text('Alchemative', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.hint,
  }) : super(key: key);
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
