// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/forms/form_2.dart';

class MainPersonal_Info extends StatefulWidget {
  const MainPersonal_Info({Key? key}) : super(key: key);

  @override
  State<MainPersonal_Info> createState() => _MainPersonal_InfoState();
}

class _MainPersonal_InfoState extends State<MainPersonal_Info> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: buildMyAppBar(context, 'Personal Info', true),
      body: Stack(children: [
        BackgroundCircle(),
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            buildMyNewAppBar(context, 'Personal Info', true),
          ],
          body: FormTwo(),
        ),
      ]),
    );
  }
}

//======================================================//