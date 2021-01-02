// this class for fiutAction button
import 'package:flutter/material.dart';
import 'package:marasil/utils/universal_variables.dart';

class newChatButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: UniversalVariables.fabGradient,
          borderRadius: BorderRadius.circular(50.0)),
      child: Icon(Icons.edit, color: Colors.white, size: 25.0),
      padding: EdgeInsets.all(15.0),
    );
  }
}