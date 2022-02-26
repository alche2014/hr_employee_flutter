import 'package:flutter/material.dart';
// import 'package:hr_app/Utils/helpers.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

const kPrimaryColor = Color(0xff583b6c);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;
// ignore: prefer_if_null_operators
// Future<bool> darkmode = Helper.getPreferenceBoolean('darkmode');
var darkmode = false;

var phonemask = MaskTextInputFormatter(mask: '+92 ### #######');
var cnicemask = MaskTextInputFormatter(mask: '#####-#######-#');

// ignore: non_constant_identifier_names
InputDecoration TextFieldDecoration(String hint) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    labelText: hint,
    labelStyle: const TextStyle(color: Colors.grey),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1, color: Color(0xFFE0E0E0)),
    ),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(
        width: 1,
        color: Color(0xFFE0E0E0),
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
TextStyle TextFieldTextStyle() => const TextStyle(fontSize: 14);
