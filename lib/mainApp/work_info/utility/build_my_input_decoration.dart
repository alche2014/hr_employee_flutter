import 'package:flutter/material.dart';

InputDecoration buildMyInputDecoration(BuildContext context, String hint) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
          BorderSide(color: Colors.grey.shade300.withOpacity(0.8), width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    // filled: true,
    fillColor: Theme.of(context).scaffoldBackgroundColor,
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  );
}
