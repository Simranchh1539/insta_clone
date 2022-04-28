import 'package:flutter/material.dart';

const mobileBackgroundColor = Color.fromRGBO(0, 0, 0, 1);
const webBackgroundColor = Color.fromRGBO(18, 18, 18, 1);
const mobileSearchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;

final darkTheme = ThemeData(
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: Colors.white54,
    labelColor: Colors.white,
  ),
  primaryColor: Colors.white,
  backgroundColor: Colors.grey[800],
  accentColor: Colors.grey[850],
  appBarTheme: AppBarTheme(color: mobileBackgroundColor),
  scaffoldBackgroundColor: mobileBackgroundColor,
  hintColor: Colors.white54,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.white),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: mobileBackgroundColor,
    unselectedIconTheme: IconThemeData(color: Colors.white),
    selectedIconTheme: IconThemeData(color: Colors.white),
  ),
  textSelectionColor: Colors.white54,
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.white),
    border: InputBorder.none,
  ),
  cardColor: Colors.grey[800],
);

final lightTheme = ThemeData(
  primaryColor: Colors.white,
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(color: Colors.white),
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: Colors.grey[350],
    labelColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  accentColor: Colors.black,
  hintColor: Colors.black54,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.transparent,
  iconTheme: IconThemeData(color: Colors.black),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    unselectedIconTheme: IconThemeData(color: Colors.black),
    selectedIconTheme: IconThemeData(color: Colors.black),
  ),
  textSelectionColor: Colors.black38,
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.black),
    border: InputBorder.none,
  ),
  cardColor: Colors.grey.shade200,
);

const kFontWeightBoldTextStyle = TextStyle(fontWeight: FontWeight.bold);
const kFontColorBlackTextStyle = TextStyle(color: Colors.black);
const kFontColorRedTextStyle = TextStyle(color: Colors.red);
const kFontColorGreyTextStyle = TextStyle(color: Colors.grey);
const kFontColorBlack54TextStyle = TextStyle(color: Colors.black54);
const kFontSize18TextStyle = TextStyle(fontSize: 18.0);
const kFontColorWhiteSize18TextStyle =
    TextStyle(color: Colors.white, fontSize: 18.0);
const kFontSize18FontWeight600TextStyle =
    TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600);
const kBillabongFamilyTextStyle =
    TextStyle(fontSize: 35.0, fontFamily: 'Billabong');
TextStyle kHintColorStyle(BuildContext context) {
  return TextStyle(color: Theme.of(context).hintColor);
}

const kBlueColorTextStyle = TextStyle(color: Colors.blue);
final Color kBlueColorWithOpacity = Colors.blue.withOpacity(0.8);
