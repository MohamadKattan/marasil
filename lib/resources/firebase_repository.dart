// this class it will be short for code from code from firebase_method
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:marasil/model/messages.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/provider/image_upload_provider.dart';
import 'package:marasil/resources/firebase_method.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();

  Future<bool> autnehticateUser(FirebaseUser user)=>_firebaseMethods.autnehticateUser(user);

  Future<void>addDataToDb(FirebaseUser user) => _firebaseMethods.addDataToDb(user);

  Future<void>signOut()=>_firebaseMethods.signOut();

  Future<List<User>> fetchAllUsers(FirebaseUser user)=>_firebaseMethods.fetchAllUsers(user);

  void addMessageToDb(Message message, User sender,User receiver) {
    _firebaseMethods.addMessageToDb(message,sender,receiver);
  }
//from image picker to start upload image to storage
  void uploadImage({@ required File image,@required String receiverId, @required String senderId,@required ImageUploadProvider imageProvide,@required String messageId})
  =>_firebaseMethods.uploadImage(
   image,receiverId,senderId,messageId,imageProvide,
  );

  Future <User>getUserDetails()=>_firebaseMethods.getUserDetails();
// for delete image
  void deleteImage({String receiverId, String senderId, String messageId})  =>_firebaseMethods.deleteImage(
   receiverId,senderId,messageId,
  );
//from image picker to start upload video to storage
  void UploadVideo({File video, String receiverId, String senderId, ImageUploadProvider imageProvide, String messageId})
  =>_firebaseMethods.UploadVideo(
    video,receiverId,senderId,messageId,imageProvide,
  );

  void setRecoerd({String reVoice, String receiverId, String senderId, String messageId, ImageUploadProvider imageProvide})=>
      _firebaseMethods.UploadReVoice(
        reVoice,receiverId,senderId,messageId,imageProvide,
      );



}
