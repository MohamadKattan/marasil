import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as locel;
import 'package:marasil/enum/userState.dart';
import 'package:marasil/local_db/log_repository.dart';
import 'package:marasil/pageView/chat_List_screen.dart';
import 'package:marasil/pageView/lof_screen.dart';
import 'package:marasil/pageView/settingProfile.dart';
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
  final locel.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      locel.FlutterLocalNotificationsPlugin();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
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
        backgroundColor: Theme.of(context).primaryColor,
        body: PageView(
          children: [
            Container(
              child: ChatListScreen(),
            ),
            Container(
              child: LogScreen(),
            ),
            Container(
              child: SittingsScreen(),
            ),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: Theme.of(context).primaryColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: (_page == 0)
                        ? UniversalVariables.blueColor
                        : Colors.grey,
                  ),
                  // ignore: deprecated_member_use
                  title: Text('Chat',
                      style: TextStyle(
                          fontSize: 10.0,
                          color: (_page == 0)
                              ? UniversalVariables.blueColor
                              : Colors.grey)),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    color: (_page == 1)
                        ? UniversalVariables.blueColor
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
                    Icons.settings,
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
// for firebase messaging
  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });
// for creat token
    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document(userProvider.getUser.uid)
          .updateData({'pushToken': token});
    }).catchError((err) {
      print(err.toString());
    });
  }
// for local notfiction
  void configLocalNotification() {
    var initializationSettingsAndroid =
        new locel.AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new locel.IOSInitializationSettings();
    var initializationSettings = new locel.InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
// for local notfiction
  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new locel.AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.kattansoftware.marasil'
          : 'com.duytq.kattansoftware.marasil',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: locel.Importance.max,
      priority: locel.Priority.high,
    );
    var iOSPlatformChannelSpecifics = new locel.IOSNotificationDetails();
    var platformChannelSpecifics = new locel.NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    print(message);
    print(message['body'].toString());
    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

  }
}
