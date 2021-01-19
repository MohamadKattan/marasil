// this class for show user name + if online or not conecte with CustomAppBar
import 'package:flutter/material.dart';
import 'package:marasil/provider/userProvider.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:marasil/utils/utilities.dart';
import 'package:marasil/widget/user_details.dart';
import 'package:provider/provider.dart';

// circle where found logo with dotonline in chat list Screen
class UserCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Theme.of(context).primaryColor,
            context: context,
            builder: (context) {
              return UserDetailsIsContainer();
            });
      },
      child: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
            color: UniversalVariables.separatorColor,
            borderRadius: BorderRadius.circular(50)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                Utils.getInitials(userProvider.getUser.name),
                style: TextStyle(
                    color: UniversalVariables.lightBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12.0,
                width: 12.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2, color: UniversalVariables.blackColor),
                  color: UniversalVariables.onlineDotColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
