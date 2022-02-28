import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
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
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      hintText: hint,
      hintStyle: const TextStyle(
          color: Color(0xFF737373),
          fontWeight: FontWeight.w500,
          fontSize: 13,
          fontFamily: "Poppins"),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0)));
}

InputDecoration TextPhoneFieldDecoration(String defaultCode) {
  return InputDecoration(
    isDense: true,
    fillColor: Colors.white,
    filled: true,
    prefixIcon: CountryCodePicker(
        initialSelection: defaultCode,
        padding: const EdgeInsets.all(0),
        onChanged: (CountryCode? selectedValue) {
          defaultCode = selectedValue!.dialCode.toString();
        },
        hideSearch: false,
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        alignLeft: false),
    contentPadding: const EdgeInsets.only(bottom: 15, top: -5, left: 15),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.transparent, width: 0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    ),
    hintText: 'Phone',
    hintStyle: const TextStyle(color: Colors.grey),
  );
}

// ignore: non_constant_identifier_names
TextStyle TextFieldTextStyle() => const TextStyle(fontSize: 14);
TextStyle TextFieldHeadingStyle() => const TextStyle(
    color: Color(0xffacacac),
    fontWeight: FontWeight.w500,
    fontFamily: "Poppins",
    fontSize: 13);
Widget saveButton(context, onpress) {
  return SizedBox(
    height: 55,
    width: MediaQuery.of(context).size.width,
    child: ElevatedButton(
      child: const Text('SAVE'), //next button
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          primary: purpleDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: onpress,
    ),
  );
}
