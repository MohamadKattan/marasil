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
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height*0.96,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('images/logo.png',fit: BoxFit.fill,)),
                Center(child: loginButton()),
                isLoginPressed
                    ? Center(child: CircularProgressIndicator())
                    : Text(''),
                Center(
                    child: Text(
                      '..Click..',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    )),
              ],
            ),

          ],
        ),
      ),
    );
  }

// this for button login
  Widget loginButton() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      child: Padding(
        padding: EdgeInsets.all(20),
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
