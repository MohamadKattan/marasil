import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  String photoUrl;
  Timestamp timestamp;
  Message(
      {this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.timestamp});

  // will use just when send an image with text
  Message.imageMessage(
      {this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.timestamp,
      this.photoUrl});
  // this for set
  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['photoUrl'] = this.photoUrl;
    map['timestamp'] = this.timestamp;
    return map;
  }

  // this for get
  Message.fromMap(Map<String, dynamic> map) {

    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.type = map['type'];
    this.message = map['message'];
    this.photoUrl = map['photoUrl'];
    this.timestamp = map['timestamp'];

  }
}
