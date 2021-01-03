// this class is widget dot color if red / green / orange will use in contactView
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:marasil/enum/userState.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/resources/firebase_method.dart';
import 'package:marasil/utils/utilities.dart';

class OnlineDot extends StatelessWidget {
  final String uid;
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  OnlineDot({@required this.uid});
  @override
  Widget build(BuildContext context) {
    // for switch color conect with state user
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.offline:
          return Colors.red;
        case UserState.onLine:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: _firebaseMethods.getUserStream(uid: uid),
        builder: (context, snapshot) {
          User user;
          if (snapshot.hasData && snapshot != null) {
            user = User.fromMap(snapshot.data.data);
          }
          return Container(
            width: 10,
            height: 10,
            margin: EdgeInsets.only(right: 8, top: 8),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: getColor(user?.state)),
          );
        });
  }
}
