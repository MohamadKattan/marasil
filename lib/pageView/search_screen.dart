import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'package:marasil/screens/chatScreen.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:marasil/widget/customTile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // for call
  FirebaseRepository _repository = FirebaseRepository();
  // list for search users and get result search
  List<User> userList;
  // for query for on changed
  String query = '';
  TextEditingController searchEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((FirebaseUser user) {
      _repository.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchUserAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),
    );
  }

// this method for search appBar
  searchUserAppBar(BuildContext context) {
    return GradientAppBar(
      backgroundColorStart: UniversalVariables.gradientColorStart,
      backgroundColorEnd: UniversalVariables.gradientColorEnd,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchEditingController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => searchEditingController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

// this method for show resulut search user in list view
  buildSuggestions(String query) {
    //1-- here when we start type on text failed will start see some sugget useer
    List<User> suggestList = query.isEmpty
        ? []
        : userList.where((User user) {
            String _getuserName = user.username.toLowerCase();
            String _getName = user.name.toLowerCase();
            String _query = query.toLowerCase();
            bool matchUserName = _getuserName.contains(_query);
            bool matchName = _getName.contains(_query);
            return (matchName || matchUserName);
          }).toList();
    // 2-- it will put data from result in list view
    return ListView.builder(
        itemCount: suggestList.length,
        itemBuilder: (context, index) {
          User searchedUser = User(
            uid: suggestList[index].uid,
            username: suggestList[index].username,
            name: suggestList[index].name,
            profilePhoto: suggestList[index].profilePhoto,
          );
          // 3-- it will show in customtile include listview from the up
          return CustomTile(
              mini: false,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(receiver:searchedUser)));
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(searchedUser.profilePhoto),
                backgroundColor: Colors.grey,
              ),
              title: Text(
                searchedUser.username,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                searchedUser.name,
                style: TextStyle(color: UniversalVariables.greyColor),
              ));
        });
  }
}
