// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/colors.dart';
import 'package:hr_app/sign_up/reset_password.dart';

//use welcome screen to run app
class MainRecovering extends StatelessWidget {
  const MainRecovering({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, '', false),
      body: Stack(
        children: [
           BackgroundCircle(),
          _MainMainRecoveringBody(),
        ],
      ),
    );
  }
}

class _MainMainRecoveringBody extends StatelessWidget {
  const _MainMainRecoveringBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacer(flex: 1),
        Center(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset("assets/Logo.png"),
            ),
          ),
        ),
        Spacer(flex: 1),
        // SizedBox(height: 20),
        //-------------------------------------------//
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Enter 4-digit recovery code',
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        //----------------------------------------------//
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SizedBox(
              height: 50,
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'The recovery code was sent to your mobile number. please enter the code.',
                    style: TextStyle(color: Colors.grey),
                  ))),
        ),
        // Spacer(),
        //----------------------------------------------//
        Spacer(flex: 1),
        _RecoveryCards(),
        Spacer(flex: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MainResetPassword()));
              },
              style: ElevatedButton.styleFrom(
                primary: kPrimaryRed,
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: Text(
                'NEXT',
              ),
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
//===========================================================//

class _RecoveryCards extends StatelessWidget {
  _RecoveryCards({Key? key}) : super(key: key);

  final node0 = FocusNode();
  final node1 = FocusNode();
  final node2 = FocusNode();
  final node3 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
           Container(
              alignment: Alignment.center,
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                focusNode: node0,
                style: TextStyle(fontSize: 42),
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    counter: Offstage()),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if(value.isNotEmpty)
                    FocusScope.of(context).requestFocus(node1);
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                focusNode: node1,
                style: TextStyle(fontSize: 42),
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    counter: Offstage()),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty)
                    FocusScope.of(context).requestFocus(node2);
                  if (value.isEmpty)
                    FocusScope.of(context).requestFocus(node0);
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                focusNode: node2,
                style: TextStyle(fontSize: 42),
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    counter: Offstage()),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty)
                    FocusScope.of(context).requestFocus(node3);
                  if (value.isEmpty)
                    FocusScope.of(context).requestFocus(node1);
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                focusNode: node3,
                style: TextStyle(fontSize: 42),
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    counter: Offstage()),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isEmpty)
                    FocusScope.of(context).requestFocus(node2);
                },
              ),
            ),
        ],
      ),
    );
  }
}
