
import 'package:flutter/material.dart';

final lightTheme = ThemeData.light();

final darkTheme = ThemeData.dark();

//style static class for login_page
class LoginStyle {
  static ButtonStyle buttonStyle = ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size(350, 50)),
      maximumSize: MaterialStateProperty.all(Size(350, 50)),
      backgroundColor: MaterialStateProperty.all(Colors.white));
  static TextStyle buttontextStyle = TextStyle(
      fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w500);
  static TextStyle titleStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
  static TextStyle linkStyle = TextStyle(fontSize: 18, color: Colors.blueGrey);
  static BoxDecoration containerStyle = BoxDecoration(
      border: Border(
          right: BorderSide(
    color: Colors.grey,
  )));
  static BoxDecoration seperatedLine = BoxDecoration(
      border: Border(
          top: BorderSide(
    color: Color.fromARGB(255, 208, 208, 208),
  )));
}
