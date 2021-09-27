// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/models/listofdata.dart';

import '../../../colors.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({Key? key}) : super(key: key);

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
                const Text('About',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: darkRed)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, color: Colors.grey)),
              ]),
              Text(bodyText),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
