import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/main.dart';

SliverAppBar buildMyNewAppBar(BuildContext context, String name, bool turn) {
  return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: isdarkmode.value ? Colors.white : Colors.black,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontFamily: 'Sodia',
          color: isdarkmode.value ? Colors.white : Colors.black,
        ),
      ));
}

//======================================================================//
AppBar buildMyAppBar(BuildContext context, String name, bool turn) {
  return AppBar(
    elevation: 0,
    centerTitle: false,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
      // color: Colors.black,
      onPressed: () => Navigator.of(context).pop(),
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[purpleLight, purpleDark]),
      ),
    ),
    backgroundColor: Colors.transparent,
    title: Text(name,
        style: const TextStyle(
          fontFamily: 'Sodia',
          color: Colors.white,
        )),
  );
}
