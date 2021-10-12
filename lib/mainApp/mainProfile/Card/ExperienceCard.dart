// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hr_app/mainApp/experiences/add_experiences.dart';

import '../../../colors.dart';

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({Key? key}) : super(key: key);

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
                const Text('experience',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: darkRed)),
                IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: 
                      (context)=> AddExperience()));
                    },
                    icon: const Icon(Icons.edit_outlined, color: Colors.grey)),
              ]),
              Column(children: [
                Row(children: [
                  SizedBox(height: 40, child: Image.asset('assets/Logo.png')),
                  const SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'UI UX Designer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Alchemative - Full time'),
                        Text('Mar 2020 - Present 1yr 7 mos'),
                      ]),
                ]),
                const SizedBox(height: 20),
                //===============================================//
                Row(children: [
                  SizedBox(
                      height: 40, child: Image.asset('assets/picBack.png')),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Web UI & UX Designer at Technology Wisdom',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text('Technology Wisdom - Full time'),
                          Text('Feb 2018 – Feb 2020 2 yrs 1 mos'),
                        ]),
                  ),
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
                          'Graphic Web Designer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Computer Xperts - Full time'),
                        Text('Mar 2016 – Feb 20182 yrs'),
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
