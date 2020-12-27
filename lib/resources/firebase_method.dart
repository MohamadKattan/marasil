//this class will include all scours method code to firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/utils/utilities.dart';

class FirebaseMethods {
  // for install all labrly from Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;
  User user = User();

  // this method for got currentUser from Auth
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  // this method for google singIN
  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken);
    FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }

  // this method for receiver firebase user
  Future<bool> autnehticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection('users') // 1-for get from collection
        .where('email ',
            isEqualTo: user.email) //2-- all data from our account on gmail
        .getDocuments(); //already got it
    final List<DocumentSnapshot> docs =
        result.documents; //3-- list all data what will get from google
    // if user is registerd it data length of list> 0 == false or == 0 == true
    return docs.length == 0 ? true : false;
  }

  // this method for set dat to firebase and all veribel it will be im model = user
  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);
    user = User(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoUrl,
      username: username,
    );
    firestore
        .collection('users')
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  // this mwthod for signOut

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signIn();
    return await _auth.signOut();
  }

//this method for result search ALL users from firebase
  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();
    QuerySnapshot querySnapshot =
        await firestore.collection('users').getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }
}
