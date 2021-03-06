import 'package:flutter/material.dart';
import 'package:marasil/utils/universal_variables.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);

  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;
  const CustomAppBar(
      {Key key,
      @required this.title,
      @required this.actions,
      @required this.centerTitle,
      @required this.leading})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border(
              bottom: BorderSide(
                  style: BorderStyle.solid,
                  width: 1.4,
                  color: UniversalVariables.separatorColor))),
      child: AppBar(
        backgroundColor:Theme.of(context).primaryColor,
        leading: leading,
        actions: actions,
        title: title,
        centerTitle: centerTitle,
      ),
    );
  }
}
