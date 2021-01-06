// this class using in logScreen for floatActionButton
import 'package:flutter/material.dart';
import 'package:marasil/utils/universal_variables.dart';

class CulomnFloatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: UniversalVariables.fabGradient,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.dialpad,
            color: Colors.white,
            size: 25,
          ),
        ),
        SizedBox(height: 7),
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(width: 2),
            gradient: UniversalVariables.fabGradient,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add_call,
            color: UniversalVariables.gradientColorEnd,
            size: 25,
          ),
        ),
      ],
    );
  }
}
