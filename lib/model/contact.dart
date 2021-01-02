// this clas for set and get data from to fireStor

import 'package:cloud_firestore/cloud_firestore.dart';

class Contact{
  String uid;
  Timestamp addedOn;
  Contact({
    this.uid,this.addedOn
});
  // for set
  Map toMap(Contact contact){
    var data = Map<String,dynamic>();
    data ['contact_id']=contact.uid;
    data ['addedOn']=contact.addedOn;
    return data;
  }

  Contact.fromMap(Map<String,dynamic>mapData){
    this.uid=mapData['contact_id'];
    this.addedOn=mapData['addedOn'];
  }
}