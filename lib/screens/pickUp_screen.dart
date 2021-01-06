// this page will start with receiver call tell he accpet

import 'package:flutter/material.dart';
import 'package:marasil/local_db/log_repository.dart';
import 'package:marasil/model/call.dart';
import 'package:marasil/model/log.dart';
import 'package:marasil/resources/call_method.dart';
import 'package:marasil/screens/call_screen.dart';
import 'package:marasil/utils/premission.dart';
import 'package:marasil/widget/cashed_image.dart';

class PickUpScreen extends StatefulWidget {
  final Call call;

  PickUpScreen({@required this.call});

  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  final CallMethods callMethods = CallMethods();
  bool isCallMissed = true;
  //  for add log to database
  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
        callerName: widget.call.callerName,
        callerPic: widget.call.callerPic,
        receiverName: widget.call.receiverName,
        receiverPic: widget.call.receiverPic,
        timestamp: DateTime.now().toString(),
        callStatus: callStatus);
    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    super.dispose();
    //if callerd cut call befor answer
    if (isCallMissed) {
      addToLocalStorage(callStatus: 'missed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Incoming....',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30.0),
            ),
            SizedBox(
              height: 50.0,
            ),
            CashedImage(
              imageUrl: widget.call.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              widget.call.callerName,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 75.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    color: Colors.red,
                    icon: Icon(
                      Icons.call_end,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: 'received');
                      await callMethods.endCall(call: widget.call);
                    }),
                SizedBox(
                  height: 25.0,
                ),
                IconButton(
                    color: Colors.green,
                    icon: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: 'received');
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                              return CallScreen(call: widget.call);
                            }))
                          : {};
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
