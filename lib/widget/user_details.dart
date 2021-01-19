// this class is profile user

import 'package:flutter/material.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/provider/userProvider.dart';
import 'package:marasil/resources/firebase_method.dart';
import 'package:marasil/screens/loginScreen.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:marasil/widget/cashed_image.dart';
import 'package:marasil/widget/customAppBar.dart';
import 'package:marasil/widget/shimer.dart';
import 'package:provider/provider.dart';

class UserDetailsIsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: [
          CustomAppBar(
              title: shimeringLogo(),
              actions: [
                FlatButton(
                  onPressed: () {
                    signOut(context);
                  },
                  child: Icon(Icons.close),
                )
              ],
              centerTitle: true,
              leading: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: Icon(Icons.arrow_back),
              )),
          UserDetailsBody(),
        ],
      ),
    );
  }

  void signOut(BuildContext context) async {
    bool isLogOut = await FirebaseMethods().signOut();
    if (isLogOut) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }), (Route<dynamic> route) => false);
    }
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CashedImage(
            isRound: true,
            radius: 50,
            imageUrl: userProvider.getUser.profilePhoto,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name,
                  style: TextStyle(
                      color: UniversalVariables.blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                user.email,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}
