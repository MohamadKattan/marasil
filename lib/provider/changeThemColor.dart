import 'package:flutter/material.dart';
import 'package:marasil/utils/universal_variables.dart';

// this provider for listin to any theme mode we want to change
class ThemeProvider extends ChangeNotifier {
  // if we want to start app with dark mode
  ThemeMode themeMode = ThemeMode.system;
  // this  bool if dark mode false or true
  bool get isDarkMode => themeMode == ThemeMode.dark;
// this work with button (ChangeThemeButton) for switch
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// tgis class incload colors app if we want to use dark or light
class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
    primaryColor: UniversalVariables.blackColor,
    iconTheme: IconThemeData(color: Colors.pink[900],opacity: 0.8),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.light(),
    primaryColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.pink[900],opacity: 0.8),
  );
}
