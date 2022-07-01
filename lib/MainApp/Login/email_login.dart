import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:hr_app/MainApp/Login/Forgot_password.dart';
import 'package:hr_app/MainApp/Login/Verification.dart';
import 'package:hr_app/MainApp/Login/auth.dart';
import 'package:hr_app/MainApp/Login/email_registeration.dart';
import 'package:hr_app/UserprofileScreen.dart/my_profile_edit.dart';
import 'package:hr_app/main.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({Key? key}) : super(key: key);

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Column(
            children: [
              upperPortion(),
              Container(
                // height: MediaQuery.of(context).size.height / 2.2,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "  Log in your account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text("  Email", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      style: TextFieldTextStyle(),
                      textInputAction: TextInputAction.next,
                      decoration: TextFieldDecoration('Email'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 15),
                    Text("  Password", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      style: TextFieldTextStyle(),
                      textInputAction: TextInputAction.next,
                      decoration: TextFieldDecoration('Password'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        child: const Text('LOGIN'), //next button
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            primary: purpleDark,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: onpress,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                                },
                                child: const Text('Forgot Password?')),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()));
                                },
                                child: const Text('Sign up')),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            const LoadingDialog(value: "Loading")));
  }

  Widget upperPortion() {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height / 1.8,
            width: MediaQuery.of(context).size.width,
            color: purpleDark,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logos.png',
                  height: 70,
                  width: 70,
                ),
                const SizedBox(height: 20),
                const Text(
                  "SMART HR",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            )),
        Positioned(
          top: MediaQuery.of(context).size.height / 1.7 - 60,
          left: 0,
          right: 0,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                color: Colors.grey.shade100),
          ),
        ),
      ],
    );
  }

  onpress() async {
    // final isValid = _formKey.currentState!.validate();
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content:
              Text("Email is required", style: TextStyle(color: Colors.black)),
        ),
      );
    } else if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.white,
        content:
            Text('Password is required', style: TextStyle(color: Colors.black)),
      ));
    } else if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.white,
        content: Text('Password should be at least 6 characters',
            style: TextStyle(color: Colors.black)),
      ));
    } else {
      await authService
          .handleSignInEmail(_emailController.text, _passwordController.text)
          .then((value) async {
        showLoadingDialog(context);
        final User? user = FirebaseAuth.instance.currentUser;
        if (user!.emailVerified) {
          bool _result = await AuthService().userExist(user);
          if (_result) {
            showLoadingDialog(context);
            bool _result2 = await AuthService().guestExist(user);
            if (_result2) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/invalidUser', (Route<dynamic> route) => false);
            } else {
              FirebaseFirestore.instance
                  .collection('guests')
                  .doc(user.uid)
                  .snapshots()
                  .listen((onValue) async {
                if (mounted) {
                  setState(() {
                    guest = 0;
                    uid = user.uid;
                    imagePath = onValue.data()!['imagePath'];
                    empName = onValue.data()!['displayName'];
                    empEmail = onValue.data()!['email'];
                    joiningDate = "";
                  });
                }
              });
              bool firstTimeProfile = await AuthService().firstTimeLogin(user);
              if (firstTimeProfile) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/firstTimeForm', (Route<dynamic> route) => false);
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const MyProfileEdit(teamId: "")),
                    (Route<dynamic> route) => false);
              }
            }
          } else {
            FirebaseFirestore.instance
                .collection('employees')
                .doc(user.uid)
                .snapshots()
                .listen((onValue) async {
              if (mounted) {
                setState(() {
                  guest = 1;
                  uid = user.uid;
                  designation = onValue.data()!["designation"] ?? "Designation";
                  department = onValue.data()!["department"] ?? "Department";
                  locationId = onValue.data()!["locationId"];
                  shiftId = onValue.data()!["shiftId"];
                  companyId = onValue.data()!["companyId"];
                  reportingTo = onValue.data()!['reportingToId'];
                  imagePath = onValue.data()!['imagePath'];
                  empName = onValue.data()!['displayName'];
                  empEmail = onValue.data()!['email'];
                  leaveData = onValue.data()!['leaves'] ?? [];
                  joiningDate = onValue.data()!['joiningDate'] ?? "";
                });
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/app', (Route<dynamic> route) => false);
              }
            });
          }
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => EmailVerification(link: false)),
              (Route<dynamic> route) => false);
        }
      }).catchError((e) {
        String error = e.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          content: Text(error.split(']')[1],
              style: const TextStyle(color: Colors.black)),
        ));
      });
    }
  }
}
