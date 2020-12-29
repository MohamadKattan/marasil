// this class it will be short for code from code from firebase_method
import 'dart:io';

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

  void uploadImage({@ required File image,@required String receiverId, @required String senderId,@required ImageUploadProvider imageProvide})
  =>_firebaseMethods.uploadImage(
    image,receiverId,senderId,imageProvide
  );
}
