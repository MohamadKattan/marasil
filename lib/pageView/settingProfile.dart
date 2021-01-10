import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marasil/provider/userProvider.dart';
import 'package:marasil/resources/firebase_method.dart';
import 'package:marasil/screens/loginScreen.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:provider/provider.dart';

class SittingsScreen extends StatefulWidget {
  @override
  _SittingsScreenState createState() => _SittingsScreenState();
}

class _SittingsScreenState extends State<SittingsScreen> {
  String photoUrl='';
  String name='';
  String uid='';
  UserProvider userProvider;
  // for controller textfield
  TextEditingController nickNametextEditingController;

  // for image photoUrl
  File imageFileAvatar;
  //bool
  bool isloading = false;

  // these key for textField help to update
  final FocusNode nickNameFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreashUser();
      readDataFromLocal();
    });

  }
  //for read data from shared locally
  void readDataFromLocal() async {

    uid = userProvider.getUser.uid;
    name = userProvider.getUser.name;
    photoUrl =userProvider.getUser.profilePhoto;


    nickNametextEditingController = TextEditingController(text: name);


    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20.0),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        (imageFileAvatar == null)
                            // NOT NULL=Material
                            ? (photoUrl!= '')
                                //IN THIS DISPLAY OLD IMAGE
                                ? Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.teal[600]),
                                        ),
                                        width: 150.0,
                                        height: 150.0,
                                        padding: EdgeInsets.all(20.0),
                                      ),
                                      imageUrl: photoUrl,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(125.0)),
                                    clipBehavior: Clip.hardEdge,
                                  )
                                //if no found Image from User
                                : Icon(Icons.account_circle,
                                    size: 90.0, color: Colors.grey)
                            // if user want to change his Image
                            : Material(
                                child: Image.file(
                                  imageFileAvatar,
                                  width: 150.0,
                                  height: 150.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(125.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                        IconButton(
                          onPressed: () => getImage(),
                          icon: Icon(Icons.camera_alt),
                          color: Colors.white54.withOpacity(0.3),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.grey,
                          iconSize: 90.0,
                          padding: EdgeInsets.all(0.0),
                        ),

                        // this button for change image
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: isloading ? CircularProgressIndicator() : Text(''),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          'Profile Name :',
                          style: TextStyle(
                              color: UniversalVariables.blueColor,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: UniversalVariables.blueColor),
                        child: TextField(
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5.0),
                              hintText: 'your name',
                              hintStyle: TextStyle(color: Colors.black)),
                          controller: nickNametextEditingController,
                          onChanged: (value) {
                            name = value;
                          },
                          focusNode: nickNameFocusNode,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
                // Buttons
                Container(
                  child: FlatButton(
                    onPressed:()=> updateData(uid: userProvider.getUser.uid),
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    color: UniversalVariables.blueColor,
                    highlightColor: Colors.grey,
                    splashColor: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  child: FlatButton(
                    onPressed: () => signOut(context),
                    child: Text(
                      'LogOut',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    color: Colors.red[600],
                    highlightColor: Colors.grey,
                    splashColor: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  ),
                  margin: EdgeInsets.only(bottom: 10.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//for read data from shared locally


// this method for pick an image for change image profile
  Future getImage() async {
    File newImageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (newImageFile != null) {
      setState(() {
        this.imageFileAvatar = newImageFile;
        isloading = true;
      });
    }
    uploadImageToFirebaseAndStorage(uid: userProvider.getUser.uid);
  }

// this method for updata Image user and upload to fireStoreAnd Storage came from = (getImage)
  Future uploadImageToFirebaseAndStorage({@required String uid}) async {
    // 1_id for each user when want to update
    try {
      String mFileName = uid;
      // 2_ Start upload tp Storage
      final StorageReference storageReference =
          FirebaseStorage.instance.ref().child(mFileName);
      StorageUploadTask storageUploadTask =
          storageReference.putFile(imageFileAvatar);
      var imageUrl =
          await (await storageUploadTask.onComplete).ref.getDownloadURL();
      photoUrl = imageUrl.toString();
      Firestore.instance.collection('users').document(uid).updateData({
        'profilePhoto':photoUrl ,
        'name': name,
        // //         // 4_ after that will update to locale to shaerdprefrenc
      }).then((value) async{
        await userProvider.refreashUser();
        setState(() {
          isloading = false;
        });
      });
    } catch (e) {
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: 'Error update try again');
    }

  }

// this method for updateDat nickname+aboutme to fireStore
  void updateData({@required String uid}) {
    nickNameFocusNode.unfocus();
    setState(() {
      isloading = true;
    });

    Firestore.instance.collection('users').document(uid).updateData({
      'profilePhoto': photoUrl,
      'name': name,
      // 4_ after that will update to locale to shaerdprefrenc
    }).then((value) async {
      await userProvider.getUser;
      setState(() {

        isloading = false;
      });
      Fluttertoast.showToast(msg: 'Update don');
    });
  }
  // // this method for sign out
  void signOut(BuildContext context) async {
    bool isLogOut = await FirebaseMethods().signOut();
    if (isLogOut) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }), (Route<dynamic> route) => false);
    }
  }
}
