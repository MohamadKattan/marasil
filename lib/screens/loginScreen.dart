
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'homeScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:marasil/utils/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  bool isLoginPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Stack(
        children: [
          Center(child: loginButton()),
          isLoginPressed ? Center(child: CircularProgressIndicator()) : Text('')
        ],
      ),
    );
  }

// this for button login
  Widget loginButton() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      child: Padding(
        padding: EdgeInsets.all(35),
        child: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: perfformLogin,
            child: Text(
              'Login',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2),
            )),
      ),
    );
  }

  void perfformLogin() {
    setState(() {
      isLoginPressed = true;
    });
    _repository.signIn().then((FirebaseUser user) {
      if (user != null) {
        autnehticateUser(user);
      } else {
        print('someThing went wrong ');
      }
    });
  }

// this methoed for receiver firebase user
  void autnehticateUser(FirebaseUser user) {
    _repository.autnehticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });
      if (isNewUser) {
        _repository.addDataToDb(user).then((value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }
}
