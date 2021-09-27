import 'package:flutter/material.dart';

import '../../../colors.dart';

// ignore: must_be_immutable
class ChipsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Wrap(
        spacing: 9.0,
        children: List<Widget>.generate(Chips.chipList.length, (int index) {
          return Chip(
            label: Text(Chips.chipList[index],
                style: TextStyle(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.black
                        : Colors.grey)),
            backgroundColor: lightPink,
            // deleteIconColor:
            //   MediaQuery.of(context).platformBrightness == Brightness.light
            //       ? Colors.black
            //       : Colors.grey,
          );
        }),
      ),
    );
  }
}

//----------------Chip Maker-------------------------
class Chips extends StatefulWidget {
  static List<String> chipList = ['Adobe PhotoShop', 'Adobe XD', 'Figma'];
  @override
  _ChipsState createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: 3.0,
        runSpacing: 4.0,
        children: List<Widget>.generate(Chips.chipList.length, (int index) {
          return Chip(
            label: Text(Chips.chipList[index],
                style: TextStyle(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.black
                        : Colors.grey)),
            backgroundColor: lightPink,
            deleteIconColor:
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? Colors.black
                    : Colors.grey,
            onDeleted: () {
              setState(() {
                Chips.chipList.removeAt(index);
              });
            },
          );
        }),
      ),
    );
  }
}

// ignore: must_be_immutable
class DiscriptionField extends StatelessWidget {
  String text;
  DiscriptionField(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        child: TextField(
          maxLines: 5,
          style: TextStyle(),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),
            hintText: "$text",
            filled: true,
            // fillColor: textFieldColor,
          ),
        ),
      ),
    );
  }
}

Widget getTextField({required String hint}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: SizedBox(
      height: 70,
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            filled: true,
            suffixStyle: TextStyle(color: Colors.black),
            // fillColor: textFieldColor,
            hintText: hint,
            // suffixText: 'YRS',
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            )),
      ),
    ),
  );
}

// MediaQuery.of(context).platformBrightness ==
//         Brightness.light
//     ? kPrimaryColor.withOpacity(0.7)
//     : kContentColorLightTheme.withOpacity(0.7)
