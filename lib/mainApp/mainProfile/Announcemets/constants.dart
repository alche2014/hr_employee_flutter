import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

const kPrimaryColor = Color(0xFFC53B4B);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;

var darkmode = false;

var phonemask = new MaskTextInputFormatter(mask: '+92 ### #######');
var cnicemask = new MaskTextInputFormatter(mask: '#####-#######-#');

// ignore: non_constant_identifier_names
InputDecoration TextFieldDecoration(String hint) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    labelText: hint,
    labelStyle: TextStyle(color: Colors.grey.shade700),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        width: 1,
        color: Color(0xFFE0E0E0),
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        width: 1,
        color: Color(0xFFE0E0E0),
      ),
    ),
  );
}

TextStyle TextFieldTextStyle() => TextStyle(fontSize: 14);
