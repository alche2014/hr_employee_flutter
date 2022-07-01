import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/MainApp/Login/Verification.dart';
import 'package:hr_app/MainApp/Login/auth.dart';
import 'package:hr_app/MainApp/Login/email_login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
          child: Column(children: [
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
                  "  Password Reset",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text("  Enter your email address to retrive your password",
                    textAlign: TextAlign.center,
                    style: TextFieldHeadingStyle()),
                const SizedBox(height: 30),
                Text("  Email", style: TextFieldHeadingStyle()),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  style: TextFieldTextStyle(),
                  textInputAction: TextInputAction.next,
                  decoration: TextFieldDecoration('Email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 25),
                SizedBox(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: const Text('SEND'), //next button
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            primary: purpleDark,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          // await authService
                          //     .handleSignUp(
                          //         _emailController.text, _passwordController.text)
                          //     .then((value) async {
                          //   final User? user = FirebaseAuth.instance.currentUser;
                          //   bool _result = await AuthService().userExist(user);
                          //   if (_result) {
                          //     showLoadingDialog(context);
                          //     bool _result2 = await AuthService().guestExist(user);
                          //     if (_result2) {
                          //       bool domainExist =
                          //           await AuthService().domainExist(user!);
                          //       if (domainExist) {
                          //         List domainList = [];
                          //         String? userEmail = user.email;
                          //         var domainPart = userEmail!.split('@');
                          //         await FirebaseFirestore.instance
                          //             .collection("company")
                          //             .get()
                          //             .then((onValue) {
                          //           final List<DocumentSnapshot> documents =
                          //               onValue.docs;

                          //           for (int i = 0; i < documents.length; i++) {
                          //             domainList = documents[i]["domain"];
                          //             if (domainList.contains(domainPart[1])) {
                          //               FirebaseFirestore.instance
                          //                   .collection("employees")
                          //                   .doc(user.uid)
                          //                   .set({
                          //                 'uid': user.uid,
                          //                 'email': "${user.email}",
                          //                 'imagePath': "${user.photoURL}",
                          //                 'displayName': "${user.displayName}",
                          //                 "companyId": documents[i].id,
                          //                 'timeStamp': DateTime.now(),
                          //                 'empId': null,
                          //                 "active": true,
                          //                 "containsId": false
                          //               });
                          //               setState(() {
                          //                 guest = 1;
                          //                 uid = user.uid;
                          //                 designation = "Designation";
                          //                 department = "Department";
                          //                 locationId = null;
                          //                 shiftId = null;
                          //                 companyId = documents[i].id;
                          //                 reportingTo = "";
                          //                 leaveData = [];
                          //                 joiningDate = "";
                          //                 empEmail = user.email!;
                          //               });
                          //               break;
                          //             }
                          //           }
                          //         });
                          //         bool firstTimeProfile =
                          //             await AuthService().firstTimeEmpLogin(user);
                          //         if (firstTimeProfile) {
                          //           Navigator.of(context).pushNamedAndRemoveUntil(
                          //               '/firstTimeForm',
                          //               (Route<dynamic> route) => false);
                          //         }
                          //       } else {
                          //         FirebaseFirestore.instance
                          //             .collection("guests")
                          //             .doc(user.uid)
                          //             .set({
                          //           'uid': user.uid,
                          //           'email': "${user.email}",
                          //           'imagePath': null,
                          //           'displayName': null,
                          //           'timeStamp': DateTime.now(),
                          //           'empId': null,
                          //           "containsId": false
                          //         });
                          //         setState(() {
                          //           guest = 0;
                          //           uid = user.uid;
                          //           designation = "Designation";
                          //           department = "Department";
                          //           locationId = null;
                          //           shiftId = null;
                          //           companyId = null;
                          //           reportingTo = "";
                          //           leaveData = [];
                          //           joiningDate = "";
                          //           empEmail = user.email!;
                          //         });
                          //         bool firstTimeProfile =
                          //             await AuthService().firstTimeLogin(user);
                          //         if (firstTimeProfile) {
                          //           Navigator.of(context).pushNamedAndRemoveUntil(
                          //               '/firstTimeForm',
                          //               (Route<dynamic> route) => false);
                          //         } else {
                          //           Navigator.of(context).pushNamedAndRemoveUntil(
                          //               '/invalidUser',
                          //               (Route<dynamic> route) => false);
                          //         }
                          //       }
                          //     }
                          //   }
                          // }).catchError((e) {
                          //   String error = e.toString();
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     backgroundColor: Colors.white,
                          //     content: Text(error.split(']')[1],
                          //         style: const TextStyle(color: Colors.black)),
                          //   ));
                          // });
                          showLoadingDialog(context);

                          await authService
                              .forgetPassword(_emailController.text)
                              .then((value) {
                            if (value == "" || value == "no exception") {
                              Fluttertoast.showToast(
                                  msg:
                                      "Password Reset Email Link has been sent to your email");
                              Future.delayed(const Duration(seconds: 2), () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EmailLoginScreen()),
                                    (Route<dynamic> route) => false);
                              });
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(value)));
                            }
                          });
                        })),
              ]),
        )
      ])),
    );
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

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            const LoadingDialog(value: "Loading")));
  }
}
