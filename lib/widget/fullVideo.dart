
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'package:marasil/screens/chatScreen.dart';
import 'package:video_player/video_player.dart';

class FullVideo extends StatefulWidget {
  final String urlVideo;
  final String receiver;
  final String id;
  final String sender;
  FullVideo({this.urlVideo, this.sender, this.receiver, this.id});

  @override
  _FullVideoState createState() => _FullVideoState();
}

class _FullVideoState extends State<FullVideo> {
  ChatScreen chatScreen = ChatScreen();

  FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('playVideo'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async{
                Firestore.instance
                    .collection('messages')
                    .document(widget.sender)
                    .collection(widget.receiver)
                    .document(widget.id)
                    .get()
                    .then((document) {
                  if (document.exists) {
                    document.reference.delete();
                  }
                });
                await  Firestore.instance
                    .collection('messages')
                    .document(widget.receiver)
                    .collection(widget.sender)
                    .document(widget.id)
                    .get()
                    .then((document) {
                  if (document.exists) {
                    document.reference.delete();
                  }
                  Navigator.maybePop(context);
                });
              })
        ],
      ),
      body: ChewieList(
        videoPlayerController: VideoPlayerController.network(widget.urlVideo),
        looping: true,
      ),
    );
  }
}
