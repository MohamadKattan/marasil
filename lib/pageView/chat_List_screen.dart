import 'package:flutter/material.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/pageView/search_screen.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:marasil/utils/utilities.dart';
import 'package:marasil/widget/customAppBar.dart';
import 'package:marasil/widget/customTile.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  //for called class
  final FirebaseRepository _repository = FirebaseRepository();
  String currentUserId;
  String initials=''; //for name user in appBar
  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUserId = user.uid;

        initials = Utils.getInitials(user.displayName);

        //for name user in appBar
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: newChatButtom(),
      body: chatListContainer(currentUserId),
    );
  }

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
      title: UserCircle(initials),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
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
}

//this class for chatlist
class chatListContainer extends StatefulWidget {
  final String currentUserId;
  chatListContainer(this.currentUserId);
  @override
  _chatListContainerState createState() => _chatListContainerState();
}

class _chatListContainerState extends State<chatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return CustomTile(
                mini: false,
                onTap: () {},
                title: Text(
                  'Mohamad',
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
                      CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            'https://digitalsynopsis.com/wp-content/uploads/2017/12/funny-agency-life-creative-designer-copywriter-memes-1.jpg'),
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
                                  color: UniversalVariables.blackColor,
                                  width: 2)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

// this class for show user name + if online or not conecte with CustomAppBar
class UserCircle extends StatelessWidget {
  final String text;
  UserCircle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
          color: UniversalVariables.separatorColor,
          borderRadius: BorderRadius.circular(50)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child:
              Text(text, style: TextStyle(
                  color: UniversalVariables.lightBlueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0),),


          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12.0,
              width: 12.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(width: 2, color: UniversalVariables.blackColor),
                color: UniversalVariables.onlineDotColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// this class for fiutAction button
class newChatButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: UniversalVariables.fabGradient,
          borderRadius: BorderRadius.circular(50.0)),
      child: Icon(Icons.edit, color: Colors.white, size: 25.0),
      padding: EdgeInsets.all(15.0),
    );
  }
}
