// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../../../colors.dart';

class EducationCard extends StatelessWidget {
  const EducationCard({Key? key}) : super(key: key);

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
                const Text('Education',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: darkRed)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, color: Colors.grey)),
              ]),
              Column(children: [
                //===============================================//
                Row(children: [
                  SizedBox(
                      height: 40, child: Image.asset('assets/picBack.png')),
                  const SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Eden Garden School',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text('Degree - Lorem Ipsum'),
                      ]),
                ]),
                const SizedBox(height: 20),
                //==================================================//
                Row(children: [
                  SizedBox(
                      height: 40, child: Image.asset('assets/picBack.png')),
                  const SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Superior College',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text('Degree - Lorem Ipsum'),
                      ]),
                ]),
              ]),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
