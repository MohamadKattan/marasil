import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marasil/provider/changeThemColor.dart';
import 'package:marasil/provider/image_upload_provider.dart';
import 'package:marasil/provider/userProvider.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'package:marasil/screens/homeScreen.dart';
import 'package:marasil/screens/loginScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  // for get access
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(create: (_) => ThemeProvider(),builder: (context, _){
      final themeProvider = Provider.of<ThemeProvider>(context);
      return  MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],builder: (context,_){
          return   MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'mersail',
               themeMode: themeProvider.themeMode,
              theme:MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
              home:
              FutureBuilder(
                future: _repository.getCurrentUser(),
                builder: (context, AsyncSnapshot<FirebaseUser> snapShot) {
                  if (snapShot.hasData) {
                    return HomeScreen();
                  } else {
                    return LoginScreen();
                  }
                },
              )
          );
      },

      );
    },);


  }
}
