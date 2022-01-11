// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/mainApp/personal_Info/bank_data_info.dart';
import '../../../colors.dart';
import '../../../main.dart';

class AccountInfoCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const AccountInfoCard({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              color: isdarkmode.value == false
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.white,
              width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Account Info',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: "Sofia Pro",
                        fontStyle: FontStyle.normal,
                        color: darkRed)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BankdataInfo(data: data)));
                    },
                    icon: Icon(Icons.edit_outlined,
                        color: isdarkmode.value == false
                            ? const Color(0xff34354A)
                            : Colors.grey[500])),
              ]),
              AccountInfo(data),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget AccountInfo(snapshot) {
    return Container(
        // width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(bottom: 15, left: 8, right: 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 6, bottom: 6, left: 5),
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
                            fontStyle: FontStyle.normal,
                            fontFamily: "Sofia Pro",
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
                margin: const EdgeInsets.only(top: 6, bottom: 6, left: 5),
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
                            fontStyle: FontStyle.normal,
                            fontFamily: "Sofia Pro",
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
              )
            ]));
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.hint,
  }) : super(key: key);
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
