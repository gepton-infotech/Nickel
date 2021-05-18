import 'package:flutter/material.dart';
import 'package:pyfin/utils/constants.dart';

ThemeData appTheme() {
  return ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      primary: kPrimaryColor,
    )),
    backgroundColor: kSecondaryColor,
    primaryColor: kPrimaryColor,
  );
}
