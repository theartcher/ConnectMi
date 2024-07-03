import 'package:flutter/material.dart';

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
);

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
);
