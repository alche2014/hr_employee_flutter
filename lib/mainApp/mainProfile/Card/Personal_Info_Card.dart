// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';

class PersonalInfoCard extends StatelessWidget {
  const PersonalInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Personal Info',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: darkRed)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, color: Colors.grey)),
              ]),
              Row(children: const [
                Text('Name: '),
                Text('User Name', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: const [
                Text('Email: '),
                Text('loremipsum@gmail.com',
                    style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: const [
                Text('Phone: '),
                Text('0311-1111100', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: const [
                Text('City: '),
                Text('Lahore, Punjab', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: const [
                Text('Gender: '),
                Text('Male', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: const [
                Text('Blood Group: '),
                Text('A+', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: const [
                Text('Marital Stats:: '),
                Text('Single', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: const [
                Text('Relation Name: '),
                Text('Lorem Ipsum', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 6),
              //
              Row(children: const [
                Text('Relation: '),
                Text('Father', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 15),
              Row(children: const [
                Text('Relation Phone: '),
                Text('0311465467886', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 15),
              Row(children: const [
                Text('CNIC: '),
                Text('34603-11148761-2', style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 15),
              Row(children: const [
                Text('Location: '),
                Text('1 floor MM Alam road Vogue\n tower Lahore pakistan',
                    style: TextStyle(color: Colors.grey)),
              ]),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
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
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
