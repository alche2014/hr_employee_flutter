// ignore_for_file: prefer_const_constructors, unused_field, must_be_immutable, prefer_final_fields, unnecessary_new

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/Personal_Info/personal_info.dart';
import 'package:hr_app/sign_up/sign_up.dart';
import '../colors.dart';

//-------Main Login Screen------//

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundCircle(),
          LogBody(),
        ],
      ),
    );
  }
}

class LogBody extends StatefulWidget {
  LogBody({
    Key? key,
  }) : super(key: key);

  @override
  State<LogBody> createState() => _LogBodyState();
}

class _LogBodyState extends State<LogBody> {
  TextEditingController _controller1 = new TextEditingController();

  TextEditingController _userPasswordController = new TextEditingController();

  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                const SizedBox(height: 50),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset("assets/Logo.png"),
                  ),
                ),
                const SizedBox(height: 50),
                //------------------------------------------------------//
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      TextFormField(
                          controller: _controller1,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Username",
                            hintText: "Username",
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
                          //----------------------------------//
                          validator: (value) {
                            const pattern =
                                (r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
                            final regExp = RegExp(pattern);

                            if (value!.contains(' ')) {
                              return 'Cant have blank spaces';
                            } else if (!regExp.hasMatch(value)) {
                              return 'Enter a valid email';
                            } else {
                              return null;
                            }
                            //----------------------------------//
                          }),

                      const SizedBox(height: 20),
                      //-------------------------------------------------------//
                      TextFormField(
                          controller: _userPasswordController,
                          textInputAction: TextInputAction.done,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Password",
                             suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                                  ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                      _passwordVisible = !_passwordVisible;
                                  });
                                },
                                ),
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
                          validator: (value) {
                            if (value!.contains(' ')) {
                              return 'Password can not contain blank Spaces';
                            } else if (value.length < 6) {
                              return 'Enter atleast 8 characters';
                            } else {
                              return null;
                            }
                          }),
                    ]),
                  ),
                ),
                //---------------------------------------------//
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        child: Text(
                          'Forget Password',
                          style: TextStyle(
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? kPrimaryRed
                                      : Colors.grey),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ]),
              //--------------------------------------------------------//
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MainSignUp()));
                        },
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    //---------------------------------------------------//
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('SIGN IN',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          primary: kPrimaryRed,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onPressed: () {
                          //  if (_controller1.text.isNotEmpty &&
                          //       _controller2.text.isNotEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Personalinfo()));
                          // }
                          // if (_controller1.text.isEmpty ||
                          //     _controller2.text.isEmpty) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //       content: Text('Enter User Name & Password.'),
                          //     ),
                          //   );
                          // }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
