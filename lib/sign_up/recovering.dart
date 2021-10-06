// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';

//use welcome screen to run app
class MainRecovering extends StatelessWidget {
  const MainRecovering({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        ResetByNumberCard(),
        Spacer(flex: 2),
      ],
    );
  }
}
//===========================================================//

class ResetByNumberCard extends StatelessWidget {
  ResetByNumberCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Container(
            height: 66,
            width: 66,
            decoration: BoxDecoration(
              // borderRadius: const BorderRadius.all(
              //   Radius.circular(4),
              // ),
              border: Border.all(color: Colors.grey.withOpacity(0.8), width: 1),
            ),
            child: TextFormField(
                            decoration: InputDecoration(
                              counter: Offstage(),
                              border: InputBorder.none,
                            ),
                            maxLines: 1,
          ),
          ),
        ],
      ),
    );
  }
}

//=======================================================================//
class ResetByEmailCard extends StatelessWidget {
  String? text;
  VoidCallback? press;
  ResetByEmailCard({Key? key, this.text, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: press,
        child: Container(
          height: 108,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Icon(
                    Icons.mail_outline,
                    size: 50,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('via email:',
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                      Text(
                          //on card
                          '.... ....el@gmail.com',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}