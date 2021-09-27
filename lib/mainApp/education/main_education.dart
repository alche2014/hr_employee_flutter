import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';

import 'add_education.dart';

String t1 = 'Eden Garden School';
String t2 = 'Superior College';
String t3 = 'Degree - Lorem Ipsum';

class MainEducation extends StatelessWidget {
  const MainEducation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Education', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              children: [
                CardEdu(text1: t1, text2: t3),
                CardEdu(text1: t2, text2: t3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardEdu extends StatelessWidget {
  String text1, text2;

  CardEdu({Key? key, required this.text1, required this.text2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddEducation()));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(children: [
                  SizedBox(
                      height: 40, child: Image.asset('assets/picBack.png')),
                  const SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(text1.toString()),
                        const SizedBox(height: 7),
                        Text(text2.toString()),
                      ]),
                ]),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
