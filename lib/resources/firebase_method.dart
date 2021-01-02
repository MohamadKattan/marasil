//this class will include all scours method code to firebase
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marasil/model/contact.dart';
import 'package:marasil/model/messages.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/provider/image_upload_provider.dart';
import 'package:marasil/utils/utilities.dart';

class FirebaseMethods {
  // for install all labrly from Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();

  static final Firestore firestore = Firestore.instance;

  User user = User();

  StorageReference _storageReference;

  static final CollectionReference _userCollection = firestore.collection('users');
  static final CollectionReference _messageCollection = firestore.collection('messages');



  // this method for got currentUser from Auth
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  // this method for get user id from crurrentuser=>UserProvider
  Future <User>getUserDetails()async{
    FirebaseUser currentUser= await getCurrentUser();
    DocumentSnapshot documentSnapshot = await _userCollection.document(currentUser.uid).get();
    return User.fromMap(documentSnapshot.data);
  }

// for get data and show in ContactView
  Future<User> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
      await _userCollection.document(id).get();
      return User.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // this method for google singIN
  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken);
    FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }


  // this method for receiver firebase user
  Future<bool> autnehticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection('users') // 1-for get from collection
        .where('email ',
            isEqualTo: user.email) //2-- all data from our account on gmail
        .getDocuments(); //already got it
    final List<DocumentSnapshot> docs =
        result.documents; //3-- list all data what will get from google
    // if user is registerd it data length of list> 0 == false or == 0 == true
    return docs.length == 0 ? true : false;
  }


  // this method for set dat to firebase and all veribel it will be im model = user
  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);
    user = User(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoUrl,
      username: username,
    );
    firestore
        .collection('users')
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }


  // this mwthod for signOut
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signIn();
    return await _auth.signOut();
  }

//this method for result search ALL users from firebase
  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();
    QuerySnapshot querySnapshot =
        await firestore.collection('users').getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }


// this method for add messages to data base*****
  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();

    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContact(senderId:message.senderId,receiverId:message.receiverId);

    await _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

//** this method it will work with this method (addMessageToDb) for set or get data contact if new or old
  addToContact({String senderId,String receiverId }) async{
    Timestamp currentTime = Timestamp.now();
    await addToSendersContact(senderId, receiverId, currentTime);
    await addToReceiverContact(senderId, receiverId, currentTime);
  }
  //** this method for preper collection for set and get contact
  DocumentReference getContactDocument({String of,String forContact })=>
  _userCollection.document(of).collection('contact').document(forContact);
  //** this method if sendrer send a message and receiver is new for add receive data to contect sender
Future<void>addToSendersContact(String senderId,String receiverId,currentTime )async{
  // for check if found data recever befor or it is new
  DocumentSnapshot  senderSnapshot =
  await getContactDocument(of: senderId,forContact: receiverId).get();
  if(!senderSnapshot.exists){
    Contact receiverContact = Contact(
      uid: receiverId,
      addedOn: currentTime,
    );
    // if No found data will start set to colloction by map
    var receiverMap = receiverContact.toMap(receiverContact);
    await getContactDocument(of: senderId,forContact: receiverId)
    .setData(receiverMap);
  }
}
  //** this method if receiver got a message and sender is new for add sender data to contect receiver
  Future<void>addToReceiverContact(String senderId,String receiverId,currentTime )async{
    // for check if found data sender befor or it is new
    DocumentSnapshot  receiverSnapshot =
    await getContactDocument(of: receiverId,forContact: senderId).get();
    if(!receiverSnapshot.exists){
      Contact senderContactContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );
      // if No found data will start set to colloction by map
      var senderrMap = senderContactContact.toMap(senderContactContact);
      await getContactDocument(of: receiverId,forContact: senderId)
          .setData(senderrMap);
    }
  }
 //**for get sender and show in chatlsit
  Stream<QuerySnapshot>fetchContacts({String userId})=>
  _userCollection.document(userId).collection('contact').snapshots();
  //** this method for take last message from sender and show to reciver in chat_list
Stream<QuerySnapshot>fetchLastMessageBetween({@required String senderId,@required String receiverId })=>
_messageCollection.document(senderId).collection(receiverId).orderBy('timestamp').snapshots();



  // this method for upload image to storage
  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference =
          FirebaseStorage.instance.ref().child('${DateTime.now()}');
      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);
      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (ex) {
      print(ex.toString());
    }
  }

// this method for uploadIma=ge to fire store
  void setImageMsg(String url, String senderId, String receiverId) async {
    Message _message;
    _message = Message.imageMessage(
      message: 'IMAGE',
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      type: 'image',
      timestamp: Timestamp.now(),
    );
    var map = _message.toImageMap();
    await _messageCollection
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await _messageCollection
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  uploadImage(File image, String receiverId, String senderId, ImageUploadProvider imageProvide) async {
    imageProvide.setToLoading();
    String url = await uploadImageToStorage(image);
    imageProvide.setToIdle();
    setImageMsg(url, senderId, receiverId);
  }



}
