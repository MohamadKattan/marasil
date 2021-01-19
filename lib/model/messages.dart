import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String messageId;
  String type;
  String message;
  String photoUrl;
  String video;
  String reVoice;
  Timestamp timestamp;
  Message({
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.timestamp,
    this.messageId,
  });

  // will use just when send an image
  Message.imageMessage({
    this.senderId,
    this.receiverId,
    this.type,
    this.timestamp,
    this.photoUrl,
    this.messageId,
    this.message,
  });
  // will use just when send an video
  Message.videoMessage(
      {this.senderId,
      this.receiverId,
      this.type,
      this.timestamp,
      this.video,
      this.message,
      this.messageId});
  // will use just when send voice
  Message.reVoiceMessage(
      {this.senderId,
      this.receiverId,
      this.type,
      this.timestamp,
      this.reVoice,
      this.messageId,
      this.message});
  // this for set
  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['messageId'] = this.messageId;
    map['timestamp'] = this.timestamp;
    return map;
  }
// for set with image
  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['photoUrl'] = this.photoUrl;
    map['timestamp'] = this.timestamp;
    map['messageId'] = this.messageId;
    return map;
  }

  // for set with image
  Map toVideoeMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['video'] = this.video;
    map['timestamp'] = this.timestamp;
    map['messageId'] = this.messageId;
    return map;
  }

  Map toreVoiceeMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['reVoice'] = this.reVoice;
    map['timestamp'] = this.timestamp;
    map['messageId'] = this.messageId;
    return map;
  }

  // this for get
  Message.fromMap(Map<String, dynamic> map) {
    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.type = map['type'];
    this.message = map['message'];
    this.photoUrl = map['photoUrl'];
    this.video = map['video'];
    this.reVoice = map['reVoice'];
    this.timestamp = map['timestamp'];
    this.messageId = map['messageId'];
  }
}
