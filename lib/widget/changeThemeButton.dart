// this widget for button in appBar for click if i want to change dark or light
import 'package:flutter/material.dart';
import 'package:marasil/provider/changeThemColor.dart';
import 'package:provider/provider.dart';

class ChangeThemeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Switch(
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
        });
  }
}
