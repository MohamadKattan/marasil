import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:marasil/pageView/chat_List_screen.dart';
import 'package:marasil/provider/userProvider.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'package:marasil/screens/pickUp_layot.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  PageController pageController;
  int _page = 0;
  UserProvider userProvider;
  @override
  void initState() {
    super.initState();
    pageController = PageController();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.refreashUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PickUpLayput(
      scffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: [
            Container(
              child: ChatListScreen(),
            ),
            Center(
              child: FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _repository.signOut();
                  },
                  child: Text('callScreen')),
            ),
            Center(
              child: Text('contactScreen'),
            ),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: (_page == 0)
                        ? UniversalVariables.lightBlueColor
                        : Colors.grey,
                  ),
                  title: Text('Chat',
                      style: TextStyle(
                          fontSize: 10.0,
                          color: (_page == 0)
                              ? UniversalVariables.lightBlueColor
                              : Colors.grey)),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    color: (_page == 1)
                        ? UniversalVariables.lightBlueColor
                        : Colors.grey,
                  ),
                  title: Text('Call',
                      style: TextStyle(
                          fontSize: 10.0,
                          color: (_page == 1)
                              ? UniversalVariables.lightBlueColor
                              : Colors.grey)),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contact_phone,
                    color: (_page == 2)
                        ? UniversalVariables.lightBlueColor
                        : Colors.grey,
                  ),
                  title: Text('Contact',
                      style: TextStyle(
                          fontSize: 10.0,
                          color: (_page == 2)
                              ? UniversalVariables.lightBlueColor
                              : Colors.grey)),
                ),
              ],
              currentIndex: _page,
              onTap: navigationTapped,
            ),
          ),
        ),
      ),
    );
  }

// this method for change page in page view
  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

// this method for navigator from page to page
  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
    pageController.jumpToPage(page);
  }
}
