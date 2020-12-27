import 'package:flutter/material.dart';
import 'package:marasil/utils/universal_variables.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets margin;
  final GestureTapCallback onTap;
  final bool mini;
  final GestureLongPressCallback onLongPress;

  CustomTile(
      {@required this.leading,
      @required this.title,
      this.icon,
      @required this.subtitle,
      this.trailing,
      this.margin = const EdgeInsets.all(0),
      this.onTap,
      this.onLongPress,
      this.mini = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
        margin: margin,
        child: Row(
          children: [
            leading,
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: mini ? 3 : 20),
              margin: EdgeInsets.only(left: mini ? 10 : 15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: UniversalVariables.separatorColor))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      SizedBox(
                        height: 5,
                      ),
                      icon ?? Container(),
                      icon != null ? icon : Container(),
                      subtitle,
                    ],
                  ),
                  trailing ?? Container(),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
