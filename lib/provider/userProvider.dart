import 'package:flutter/foundation.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/resources/firebase_repository.dart';
// this provider for get user id in pickUpLayout
class UserProvider with ChangeNotifier{
  User _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  User get getUser => _user;
  void refreashUser()async {
    User user = await _firebaseRepository.getUserDetails();
    _user = user;
   notifyListeners();
  }
}