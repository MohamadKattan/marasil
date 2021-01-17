import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marasil/widget/cashed_image.dart';

class FullPhoto extends StatelessWidget {
  // argument connect with chat page = craeteItem=FlatButton
  final String url;
  final String id;
  final String receiver;
  final String sender;
  FullPhoto({Key key, @required this.url,@required this.id,@required this.receiver,@required this.sender}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions:[IconButton(icon:Icon(Icons.delete), onPressed:()=>
            Firestore.instance.collection('messages').document(sender).collection(receiver).document(id).get().then((document) {
              if (document.exists) {document.reference.delete();}
            })
        )],
        backgroundColor: Colors.black,
        title: Text('Full image'),
      ),
      body: FullPhotoScreen(url: url),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;
  FullPhotoScreen({Key key, @required this.url}) : super(key: key);
  @override
  FullPhotoScreenState createState() => FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;
  FullPhotoScreenState({Key key, @required this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: CashedImage(
          imageUrl: url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}