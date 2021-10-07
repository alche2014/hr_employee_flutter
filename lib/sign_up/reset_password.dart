// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, curly_braces_in_flow_control_structures, unused_field, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/colors.dart';

//use welcome screen to run app
class MainResetPassword extends StatelessWidget {
  const MainResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, '', false),
      body: Stack(
        children: [
          BackgroundCircle(),
          _MainResetPasswordBody(),
        ],
      ),
    );
  }
}

//=====================================================//
class _MainResetPasswordBody extends StatelessWidget {
  _MainResetPasswordBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        child: Column(
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
                'Reset your password',
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
                        'Please create your new passowrd and enjoy the destination app',
                        style: TextStyle(color: Colors.grey),
                      ))),
            ),
            // Spacer(),
            //----------------------------------------------//
            Spacer(flex: 1),
            _ResetPasswordCard(),
            Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => ResetYourPassword()));
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
                    'SAVE',
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
//===========================================================//

class _ResetPasswordCard extends StatelessWidget {
  _ResetPasswordCard({Key? key}) : super(key: key);

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  var password;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Add TextFormFields and RaisedButton here.
            TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Create Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                ),
                controller: _pass,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) return 'Empty';
                  return null;
                }),
            SizedBox(height: 20),
            //------------------------//
            TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Verify Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                ),
                controller: _confirmPass,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) return 'Empty';
                  if (value != _pass.text) return 'Password Not Match';
                  if (value == _pass.text) return 'Password Match';
                  return null;
                }),
          ],
        ),
      ),
    );
  }
}
