// tjis class for show who call and you call in pageview

import 'package:flutter/material.dart';
import 'package:marasil/pageView/search_screen.dart';
import 'package:marasil/screens/pickUp_layot.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:marasil/widget/culomnFloatButton.dart';
import 'package:marasil/widget/listLogContainer.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickUpLayput(
      scffold: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
            title: Text(
              'Calls',
              style: TextStyle( fontSize: 16),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScreen())))
            ]),
        // floatingActionButton: CulomnFloatButton(),
        body:listLogContainer(),
      ),
    );
  }
}
