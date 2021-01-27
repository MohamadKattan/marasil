import 'dart:io';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:marasil/enum/RecordingState.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/provider/image_upload_provider.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class featureButtonView extends StatefulWidget {
  final Function onSaved;
  final String receiver;

  featureButtonView({Key key, @required this.onSaved, this.receiver})
      : super(key: key);

  @override
  _featureButtonViewState createState() => _featureButtonViewState();
}

class _featureButtonViewState extends State<featureButtonView> {
  FirebaseRepository _repository = FirebaseRepository();
  User sender;
  String _currentUser;
  String messageId = Uuid().v4();
  ImageUploadProvider _imageUploadProvider;

  bool isPlaying;
  bool isUploading;
  bool isRecorded;
  bool isRecording;
  AudioPlayer _audioPlayer;
  String fileRecord;
  FlutterAudioRecorder _audioRecorder;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    isRecorded = false;
    isRecording = false;
    isUploading = false;
    _audioPlayer = AudioPlayer();

    _repository.getCurrentUser().then((user) {
      _currentUser = user.uid;
      setState(() {
        // for get id sender
        sender = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return isRecorded
        ? Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                IconButton(
                    icon: Icon(
                      Icons.replay,
                      color: UniversalVariables.blueColor,
                    ),
                    onPressed: _onRecordAgain),
                IconButton(
                    icon: Icon(
                      Icons.send,
                      color: UniversalVariables.blueColor,
                    ),
                    onPressed: (){
                      return uploadToFireStore();
                    }),
              ]))
        : IconButton(
            icon: isRecording
                ? Icon(
                    Icons.pause,
                    color: UniversalVariables.blueColor,
                  )
                : Icon(
                    Icons.mic,
                    color: UniversalVariables.blueColor,
                  ),
            onPressed: _onRecoredButton);
  }

//this for cancel  recored
  void _onRecordAgain() {
    setState(() {
      isRecorded = false;
    });
  }

// this method for upload to fire base
 void uploadToFireStore()  {
    setState(() {
      isUploading=true;
    });
    _repository.setRecoerd(
        reVoice: fileRecord,
        receiverId: widget.receiver,
        senderId: _currentUser,
        imageProvide: _imageUploadProvider,
        messageId: messageId);
    setState(() {
      isUploading=false;
      isRecorded=false;
    });
  }

//this method if already recording
  Future<void> _onRecoredButton() async {
    if (isRecording) {
      _audioRecorder.stop();
      isRecording = false;
      isRecorded = true;
    } else {
      isRecording = true;
      isRecorded = false;
      await startRecording();
    }
    setState(() {});
  }

//this method for clicik button and start recording
  Future<void> startRecording() async {
    final bool hasRecordingPermission =
        await FlutterAudioRecorder.hasPermissions;
    if (hasRecordingPermission) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath =
          directory.path + '/' + DateTime.now().toString() + '.aac';
      _audioRecorder =
          FlutterAudioRecorder(filePath, audioFormat: AudioFormat.AAC);
      await _audioRecorder.initialized;
      _audioRecorder.start();
      fileRecord = filePath;
      setState(() {});
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Center(
          child: Text('please enable recording permission'),
        ),
      ));
    }
  }
}
