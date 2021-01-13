// this class for fiutAction button
import 'package:flutter/material.dart';
import 'package:marasil/pageView/search_screen.dart';
import 'package:marasil/utils/universal_variables.dart';

class newChatButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: UniversalVariables.fabGradient,
          borderRadius: BorderRadius.circular(30.0)),
      child: IconButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen())),
          icon: Icon(Icons.search, color: Colors.white, size: 25.0)),
      padding: EdgeInsets.all(15.0),
    );
  }
}
