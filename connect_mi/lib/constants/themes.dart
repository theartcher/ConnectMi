import 'package:flutter/material.dart';

const fontFamilyAldrich = 'Aldrich';

// Create a custom TextTheme
const TextTheme textTheme = TextTheme(
  displayLarge: TextStyle(fontSize: 40, fontFamily: fontFamilyAldrich),
  displayMedium: TextStyle(fontSize: 30, fontFamily: fontFamilyAldrich),
  displaySmall: TextStyle(fontSize: 21, fontFamily: fontFamilyAldrich),
  bodyLarge: TextStyle(fontSize: 14, fontFamily: fontFamilyAldrich),
  bodySmall: TextStyle(fontSize: 11, fontFamily: fontFamilyAldrich),
  // Add any other text styles you need, ensuring they also use the font family
);

//  Temporary duplicate as a light theme is not a priority at the moment.
//  This does make future changes much easier.
final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      surface: Color(0xff171819),
      onSurface: Color(0xffFFFFFF),
      primary: Color(0xff44CB8A),
      onPrimary: Color(0xff042713),
      secondary: Color(0xff252829),
      onSecondary: Color(0xffFFFFFF),
      error: Color(0xffCB4485),
      onError: Color(0xffFFFFFF),
    ),
    textTheme: textTheme);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    surface: Color(0xff171819),
    onSurface: Color(0xffFFFFFF),
    primary: Color(0xff44CB8A),
    onPrimary: Color(0xff042713),
    secondary: Color(0xff252829),
    onSecondary: Color(0xffFFFFFF),
    error: Color(0xffCB4485),
    onError: Color(0xffFFFFFF),
  ),
  textTheme: textTheme,
);
