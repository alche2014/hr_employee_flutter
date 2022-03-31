// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/UserprofileScreen.dart/bank_data_info.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/main.dart';

class AccountInfoCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data, teamEdit;
  const AccountInfoCard({Key? key, this.data, this.teamEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Account Info',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: purpleDark)),
            teamEdit
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BankdataInfo(data: data)));
                    },
                    child: Container(
                        width: 50,
                        height: 30,
                        alignment: Alignment.centerRight,
                        child: const Text('Edit',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w400))))
                : Container()
          ]),
          AccountInfo(data),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget AccountInfo(snapshot) {
    return Container(
        padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5, top: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Expanded(
                      flex: 4,
                      child: Text(
                        "Bank Name: ",
                        style: TextStyle(
                            color: Color(0XFF535353),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          snapshot["bnkName"] ?? "Bank Name",
                          style: TextStyle(
                              color: snapshot["bnkName"] == null
                                  ? Colors.grey[500]
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Expanded(
                      flex: 4,
                      child: Text(
                        "Account Number: ",
                        style: TextStyle(
                            color: Color(0XFF535353),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          snapshot["bankNo"] ?? "Account Number",
                          style: TextStyle(
                              color: snapshot["bankNo"] == null
                                  ? Colors.grey[500]
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Expanded(
                      flex: 4,
                      child: Text(
                        "IBAN No: ",
                        style: TextStyle(
                            color: Color(0XFF535353),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          snapshot["iban"] ?? "IBAN No",
                          style: TextStyle(
                              color: snapshot["bankNo"] == null
                                  ? Colors.grey[500]
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Expanded(
                      flex: 4,
                      child: Text(
                        "Bank Branch: ",
                        style: TextStyle(
                            color: Color(0XFF535353),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          snapshot["bankBranch"] ?? "Bank Branch",
                          style: TextStyle(
                              color: snapshot["bankBranch"] == null
                                  ? Colors.grey[500]
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Expanded(
                      flex: 4,
                      child: Text(
                        "Branch Code: ",
                        style: TextStyle(
                            color: Color(0XFF535353),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          snapshot["branchCode"] ?? "Branch Code",
                          style: TextStyle(
                              color: snapshot["branchCode"] == null
                                  ? Colors.grey[500]
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Expanded(
                      flex: 4,
                      child: Text(
                        "Account Title: ",
                        style: TextStyle(
                            color: Color(0XFF535353),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          snapshot["accountTitle"] ?? "Account Title",
                          style: TextStyle(
                              color: snapshot["accountTitle"] == null
                                  ? Colors.grey[500]
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]));

    // });
  }
}
