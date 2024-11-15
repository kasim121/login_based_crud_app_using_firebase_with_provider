import 'package:flutter/material.dart';

// Define custom colors for light mode
const Color primaryColorLight =
    Color(0xff4caf50); // Professional green for primary elements
const Color secondaryColorLight =
    Color(0xfff0f4f1); // Light grey for secondary elements
const Color backgroundColorLight = Color(0xffffffff); // Clean white background
const Color textColorLight =
    Colors.black; // Black text for contrast on light background

// Define the system light theme with a green and white color combo
final ThemeData systemLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColorLight, // Green for primary buttons, links, etc.
  scaffoldBackgroundColor: backgroundColorLight, // Clean white background
  textTheme: TextTheme(
    bodyText1: TextStyle(color: textColorLight), // Default body text in black
    headline6: TextStyle(
        color: textColorLight, fontWeight: FontWeight.bold), // Headline style
  ),
  iconTheme:
      IconThemeData(color: textColorLight), // Icons in black for contrast
  appBarTheme: AppBarTheme(
    color: secondaryColorLight, // Soft light grey for the AppBar
    iconTheme: IconThemeData(color: textColorLight), // Black icons in AppBar
    titleTextStyle:
        TextStyle(color: textColorLight, fontWeight: FontWeight.bold),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: primaryColorLight, // Green for buttons
    textTheme: ButtonTextTheme.primary, // White text on buttons
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: secondaryColorLight, // Light grey background for input fields
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: primaryColorLight), // Green border for inputs
    ),
    hintStyle: TextStyle(
        color: primaryColorLight), // Green for hint text in input fields
  ),
);

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
