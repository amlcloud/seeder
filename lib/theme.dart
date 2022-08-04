import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    // scaffoldBackgroundColor: Colors.black,
    // primaryColor: Colors.white,
    // backgroundColor: Color(0xff181a1b),
    // colorScheme: const ColorScheme(
    //     primary: Color(0xffcdcbc9),
    //     secondary: Colors.grey,
    //     onPrimary: Colors.blueGrey,
    //     onSecondary: Color(0xff303035),
    //     background: Color(0xff303035),
    //     surface: Colors.black54,
    //     onSurface: Color(0xffcdcbc9),
    //     onBackground: Color(0xffcdcbc9),
    //     error: Colors.red,
    //     brightness: Brightness.dark,
    //     onError: Color(0xffcdcbc9))
    );

final darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.white,
  backgroundColor: Color(0xff181a1b),
  colorScheme: const ColorScheme(
      primary: Color(0xffcdcbc9),
      secondary: Colors.grey,
      onPrimary: Colors.blueGrey,
      onSecondary: Color(0xff303035),
      background: Color(0xff303035),
      surface: Colors.black54,
      onSurface: Color(0xffcdcbc9),
      onBackground: Color(0xffcdcbc9),
      error: Colors.red,
      brightness: Brightness.dark,
      onError: Color(0xffcdcbc9)),
  sliderTheme: ThemeData.dark().sliderTheme.copyWith(
      valueIndicatorColor: Colors.black,
      valueIndicatorTextStyle:
          TextStyle(color: Colors.grey, backgroundColor: Colors.transparent)),
  textTheme: TextTheme(
    
    labelSmall: TextStyle(fontSize: 12, color: Colors.red),
  ),
  tabBarTheme: TabBarTheme(
      labelColor: Colors.blueGrey,
      unselectedLabelColor: Colors.white,
      labelStyle: TextStyle(color: Colors.pink[800]), // color for text
      indicator: UnderlineTabIndicator(
          // color for indicator (underline)
          borderSide: BorderSide(color: Colors.blueGrey))),
);
