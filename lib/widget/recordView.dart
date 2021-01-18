// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
// import 'package:marasil/enum/RecordingState.dart';
// import 'package:marasil/model/user.dart';
// import 'package:marasil/provider/image_upload_provider.dart';
// import 'package:marasil/resources/firebase_repository.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
//
//
// class RecorderView extends StatefulWidget {
//   final Function onSaved;
//   final User receiver;
//
//   RecorderView({Key key, @required this.onSaved, this.receiver})
//       : super(key: key);
//
//   @override
//   _RecorderViewState createState() => _RecorderViewState();
// }
//
// class _RecorderViewState extends State<RecorderView> {
//   FirebaseRepository _repository = FirebaseRepository();
//   User sender;
//   String _currentUser;
//   String messageId = Uuid().v4();
//   ImageUploadProvider _imageUploadProvider;
//
//   // icon button if no record yet
//   IconData _recordIcon = Icons.mic_none;
//
//   String _recordText = 'Click';
//
//   File getFile;
//
//   // for switch state by enum
//   RecordingState _recordingState = RecordingState.UnSet;
//
//   // for initialize flutter Record pluging
//   FlutterAudioRecorder audioRecorder;
//
//   @override
//   void initState() {
//     super.initState();
//     // this bool permission  for switch to record now when click
//     FlutterAudioRecorder.hasPermissions.then((hasPermission) {
//       if (hasPermission) {
//         _recordingState = RecordingState.Set;
//         _recordIcon = Icons.mic;
//         _recordText = 'Record';
//       }
//     });
//     _repository.getCurrentUser().then((user) {
//       _currentUser = user.uid;
//       setState(() {
//         // for get id sender
//         sender = User(
//           uid: user.uid,
//           name: user.displayName,
//           profilePhoto: user.photoUrl,
//         );
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _recordingState = RecordingState.UnSet;
//     audioRecorder = null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         IconButton(
//           onPressed: () async {
//             await _onRecordButtonPressed();
//             setState(() {});
//           },
//           icon: Icon(_recordIcon),
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: Padding(
//           child: Text(_recordText),
//           padding: EdgeInsets.all(6),
//           ),
//         ),
//       ],
//     );
//   }
//
// // this method when user click on mic button for switch to an state if record or stop
//   Future<void> _onRecordButtonPressed() async {
//     switch (_recordingState) {
//       case RecordingState.Set:
//         await _recordVoice();
//         break;
//
//       case RecordingState.Recording:
//         await _stopRecording();
//         _recordingState = RecordingState.Stopped;
//         _recordIcon = Icons.fiber_manual_record;
//         _recordText = 'Record new one';
//
//         break;
//
//       case RecordingState.Stopped:
//         await _recordVoice();
//         break;
//
//       case RecordingState.UnSet:
//         Scaffold.of(context).hideCurrentSnackBar();
//         Scaffold.of(context).showSnackBar(
//             SnackBar(content: Text('allow recording from sittings')));
//         break;
//     }
//   }
//
//   _stopRecording() async {
//     await audioRecorder.stop();
//     widget.onSaved();
//   }
//   // {@required File getFile }
//
//   Future<void> _recordVoice() async {
//     if (await FlutterAudioRecorder.hasPermissions) {
//       getFile=
//       await _iniRecorder();
//       await startRecording();
//       _recordingState = RecordingState.Recording;
//       _recordIcon = Icons.stop;
//       _recordText='Recording';
//       _repository.setRecoerd(
//         reVoice: getFile,
//         receiverId: widget.receiver.uid,
//         senderId:_currentUser,
//         messageId: messageId,
//         imageProvide: _imageUploadProvider,
//       );
//     } else {
//       Scaffold.of(context).hideCurrentSnackBar();
//       Scaffold.of(context).showSnackBar(
//           SnackBar(content: Text('allow recording from sittings')));
//     }
//   }
//
//   _iniRecorder() async {
//     Directory appDirectory = await getApplicationDocumentsDirectory();
//     String filePath =
//         appDirectory.path + '/' + DateTime.now().toString() + '.aac';
//     audioRecorder =
//         FlutterAudioRecorder(filePath, audioFormat: AudioFormat.AAC);
//     await audioRecorder.initialized;
//   }
//
//   startRecording() async {
//     await audioRecorder.start();
//     await audioRecorder.current(channel: 0);
//   }
// }
