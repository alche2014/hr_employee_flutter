// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/sign_up/recovering.dart';

//use welcome screen to run app
class MainSignUp extends StatelessWidget {
  const MainSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, '', false),
      body: Stack(
        children: [
           BackgroundCircle(),
          _MainSignUpBody(),
        ],
      ),
    );
  }
}

class _MainSignUpBody extends StatelessWidget {
  const _MainSignUpBody({
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
            'Forgot Password',
            style: Theme.of(context)
                .textTheme
                .headline4
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
                    'How to verify your password reset request?',
                    style: TextStyle(color: Colors.grey),
                  ))),
        ),
        // Spacer(),
        //----------------------------------------------//
        Spacer(flex: 1),
        ResetByNumberCard(press: (){
                                  Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const MainRecovering()));
        }),
        ResetByEmailCard(press: (){}),
        Spacer(flex: 2),
      ],
    );
  }
}
//===========================================================//

class ResetByNumberCard extends StatelessWidget {
  String? text;
  VoidCallback? press;
  ResetByNumberCard({Key? key, this.text, this.press}) : super(key: key);

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
                    Icons.app_settings_alt_outlined,
                    size: 50,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('via sms:',
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                      Text(
                          //on card
                          '.... .... 9011',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
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