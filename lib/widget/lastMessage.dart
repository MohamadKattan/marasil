// this method will use in subtitle in ContactView in customTile for show last message fromsender in chatLastScreen

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marasil/model/messages.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;
  LastMessageContainer({this.stream});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data.documents;
            if (docList.isNotEmpty) {
              Message message = Message.fromMap(docList.last.data);
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  message.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              );
            }
            return Text('No message',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ));
          }
          return Text('..',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ));
        });
  }
}
