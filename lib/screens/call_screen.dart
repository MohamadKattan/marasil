 // this page when caller will start dialler a call and wait tiil answer from receiver

import 'package:flutter/material.dart';
import 'package:marasil/model/call.dart';
import 'package:marasil/resources/call_method.dart';

class CallScreen extends StatefulWidget {
  // this argument came from pickupScreen = from answer button
  final Call call;
  CallScreen({@required this.call});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  CallMethods callMethods = CallMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Calling',
              style: TextStyle(fontSize: 20.0),
            ),
            MaterialButton(
              color: Colors.red,
              child: Icon(
                Icons.call_end_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                 callMethods.endCall(call: widget.call);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
