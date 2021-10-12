import 'package:flutter/material.dart';

InputDecoration buildMyInputDecoration(BuildContext context, String hint) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color:Colors.grey.withOpacity(0.4), 
       width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide:
          BorderSide(color: Colors.grey.withOpacity(0.4), 
       width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    // filled: true,
    fillColor: Theme.of(context).scaffoldBackgroundColor,
    labelText: hint,
    hintText: hint,
    // hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  );
}
