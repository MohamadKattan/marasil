// tjis class for show who call and you call in pageview

import 'package:flutter/material.dart';
import 'package:marasil/local_db/log_repository.dart';
import 'package:marasil/model/log.dart';
import 'package:marasil/utils/universal_variables.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Center(
        child: FlatButton(
          child: Text("Click Me"),
          onPressed: () {
            LogRepository.init(isHive: false);
            LogRepository.addLogs(Log());
          },
        ),
      ),
    );
  }
}