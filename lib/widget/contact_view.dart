import 'package:flutter/material.dart';
import 'package:marasil/model/contact.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/provider/userProvider.dart';
import 'package:marasil/resources/firebase_method.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'package:marasil/screens/chatScreen.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:marasil/widget/cashed_image.dart';
import 'package:marasil/widget/customTile.dart';
import 'package:provider/provider.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  FirebaseRepository _repository = FirebaseRepository();
  ContactView(this.contact);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _firebaseMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  FirebaseRepository _repository = FirebaseRepository();
  ViewLayout({@required this.contact});
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context){return
          ChatScreen(
            receiver: contact,
          );
        }));
      },
      title: Text(
       contact.name,
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      subtitle: Text(
        'hello',
        style: TextStyle(color: Colors.grey, fontSize: 14.0),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: [
         CashedImage(
           imageUrl: contact.profilePhoto,
           radius: 80,
           isRound: true,
         ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UniversalVariables.onlineDotColor,
                    border: Border.all(
                        color: UniversalVariables.blackColor, width: 2)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

