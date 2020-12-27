// this class it will be short for code from code from firebase_method
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/resources/firebase_method.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();

  Future<bool> autnehticateUser(FirebaseUser user)=>_firebaseMethods.autnehticateUser(user);

  Future<void>addDataToDb(FirebaseUser user) => _firebaseMethods.addDataToDb(user);

  Future<void>signOut()=>_firebaseMethods.signOut();

  Future<List<User>> fetchAllUsers(FirebaseUser user)=>_firebaseMethods.fetchAllUsers(user);
}
