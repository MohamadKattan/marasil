import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:marasil/enum/userState.dart';
import 'package:marasil/local_db/log_repository.dart';
import 'package:marasil/pageView/chat_List_screen.dart';
import 'package:marasil/pageView/lof_screen.dart';
import 'package:marasil/provider/userProvider.dart';
import 'package:marasil/resources/firebase_method.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'package:marasil/screens/pickUp_layot.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// this with  WidgetsBindingObserver conected with dotOnline for listing
class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  FirebaseRepository _repository = FirebaseRepository();
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  PageController pageController;
  int _page = 0;
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();

    pageController = PageController();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreashUser();
// **this with  WidgetsBindingObserver conected with dotOnline for listing
      _firebaseMethods.setUserState(
          userId: userProvider.getUser.uid, userState: UserState.onLine);
      // for using Hove database
      LogRepository.init(isHive: true, dbName: userProvider.getUser.uid);
    });
    //** this with  WidgetsBindingObserver conected with dotOnline for listing
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    // **this with  WidgetsBindingObserver conected with dotOnline for listing
    WidgetsBinding.instance.removeObserver(this);
  }

//** this with  WidgetsBindingObserver conected with dotOnline for listing
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currenUserId = (userProvider != null && userProvider.getUser != null)
        ? userProvider.getUser.uid
        : '';
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        currenUserId != null
            ? _firebaseMethods.setUserState(
                userId: currenUserId, userState: UserState.onLine)
            : print('resumed');

        break;
      case AppLifecycleState.inactive:
        currenUserId != null
            ? _firebaseMethods.setUserState(
                userId: currenUserId, userState: UserState.offline)
            : print('offline');

        break;
      case AppLifecycleState.paused:
        currenUserId != null
            ? _firebaseMethods.setUserState(
                userId: currenUserId, userState: UserState.waiting)
            : print('passed');
        break;
      case AppLifecycleState.detached:
        currenUserId != null
            ? _firebaseMethods.setUserState(
                userId: currenUserId, userState: UserState.offline)
            : print('detached');
        break;
    }
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
            Container(
              child: LogScreen(),
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
                  // ignore: deprecated_member_use
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
