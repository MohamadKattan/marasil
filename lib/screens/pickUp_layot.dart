import 'package:flutter/material.dart';
import 'package:marasil/model/call.dart';
import 'package:marasil/provider/userProvider.dart';
import 'package:marasil/resources/call_method.dart';
import 'package:marasil/screens/pickUp_screen.dart';
import 'package:provider/provider.dart';

class PickUpLayput extends StatelessWidget {
  final Widget scffold;
  final CallMethods callMethods = CallMethods();
  PickUpLayput({this.scffold});
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return userProvider != null && userProvider.getUser != null
        ? StreamBuilder(
            stream: callMethods.callStream(uid: userProvider.getUser.uid),
            builder: (context,snapshot){
              if(snapshot.hasData&&snapshot.data.data!=null){
                Call call = Call.fromMap(snapshot.data.data);
                return PickUpScreen(call: call);
              }
              return scffold;
            })
        : Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
  }
}
