import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marasil/model/call.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/resources/call_method.dart';
import 'package:marasil/screens/call_screen.dart';

// this class for give value to variable in (class Call ) from (class User )
class CallUtils {
  static final CallMethods callMethods = CallMethods();
  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(), // user Random more saucer
    );
    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialled = true; //this for call screen know data caller and receiver
    // if set from dialer and get from receiver
    if (callMade) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CallScreen(
          call: call,
        );
      }));
    }

  }
}