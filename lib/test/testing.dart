// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hr_app/mainApp/main_home_profile/main_home_profile.dart';


class MainTesting extends StatelessWidget {
  const MainTesting({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainHomeProfile(),
    );
  }
}