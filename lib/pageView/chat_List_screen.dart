import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marasil/model/contact.dart';
import 'package:marasil/pageView/search_screen.dart';
import 'package:marasil/provider/userProvider.dart';
import 'package:marasil/resources/firebase_method.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:marasil/widget/contact_view.dart';
import 'package:marasil/widget/customAppBar.dart';
import 'package:marasil/widget/newChatButtom.dart';
import 'package:marasil/widget/quiet_box.dart';
import 'package:marasil/widget/userCircle.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  //for called class
  final FirebaseRepository _repository = FirebaseRepository();
// this method for customApp
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: UserCircle(),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: newChatButtom(),
      body: chatListContainer(),
    );
  }
}

//this class for chatlist for take data from (contact)and show in listView
class chatListContainer extends StatelessWidget {
  FirebaseRepository _repository = FirebaseRepository();
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
            stream: _firebaseMethods.fetchContacts(
                userId: userProvider.getUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var docList = snapshot.data.documents;
                if (docList.isEmpty) {
                  return QuietBox();
                }
                return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: docList.length,
                    itemBuilder: (context, index) {
                      Contact contact = Contact.fromMap(docList[index].data);
                      return ContactView(contact);
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
