// this class for all process firebase apportion  = great collection+ set + get call video

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marasil/model/call.dart';

class CallMethods {
  final CollectionReference callCollection =
      Firestore.instance.collection('calls');
  // this for listing to every change on call
  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.document(uid).snapshots();
  // // this method for create call for dialer and receiver and set in fireStor
  Future<bool> makeCall({Call call}) async {
    try {
      // if dialler will send data to dialler docs (collection)
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      // if receiver will send data to receiver docs
      call.hasDialled = false;
      Map<String, dynamic> nohasDialledMap = call.toMap(call);
      //after check send to collection
      await callCollection.document(call.callerId).setData(hasDialledMap);
      await callCollection.document(call.receiverId).setData(nohasDialledMap);
      return true;
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }

  // this method for delete data from firStore after end call
  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.document(call.callerId).delete();
      await callCollection.document(call.receiverId).delete();
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }
}
