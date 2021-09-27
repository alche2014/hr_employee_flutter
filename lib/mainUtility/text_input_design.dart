import 'package:flutter/material.dart';

  // ignore: non_constant_identifier_names
  InputDecoration 
  MyInputStyle(String hint) {
      return InputDecoration(
      border: OutlineInputBorder(
       borderRadius: BorderRadius.circular(6),
       borderSide: BorderSide(color: 
       Colors.grey.withOpacity(0.4), 
       width: 1),
       ),
      enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color:
      Colors.grey.withOpacity(0.4), width: 1),
      ),
       contentPadding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  hintText: hint,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey
                  ));
  }  //===================================================================//
