import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'package:marasil/screens/homeScreen.dart';
import 'package:marasil/screens/loginScreen.dart';

class Logo extends StatefulWidget {
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  FirebaseRepository _repository = FirebaseRepository();
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.teal[600],
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'images/logo.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
