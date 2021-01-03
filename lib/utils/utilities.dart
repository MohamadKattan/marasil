// this class for great sing and make username uniq

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:marasil/enum/userState.dart';
import 'package:marasil/provider/image_upload_provider.dart';
import 'package:path_provider/path_provider.dart';
class Utils {

  // this class for great sing and make username uniq for search User
  static String getUsername(String email) {
    return 'live${email.split('@'[0])}';
  }

  // this method for get firstName and last to user and show in appBar ChatList
  static String getInitials(String name) {
    List<String> nameSplit = name.split('');
    String firstNameInitials =
        nameSplit[0][0]; // first[0]forfirstname + second[0] for firstLitter
    String lastNameInitials =
        nameSplit[1][0]; //[1]=lastname+[0] for firstLitter from lastName
    return firstNameInitials + lastNameInitials;
  }

// this method conected with method in chat screen for send an image
  static Future <File> pickImage({@required ImageSource source})async {
    File selectedImage = await ImagePicker.pickImage(source: source);
    return compreesImage(selectedImage);
  }

  // this method for compress thie image after pick and befor upload
  static Future<File>compreesImage(File imageToCompress)async {
    final tempDir=await getTemporaryDirectory();
    final path =  tempDir.path;
    int random = Random().nextInt(1000);
    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image,width: 500,height: 500,);

    return new File('$path/img_$random.jpg')
        ..writeAsBytesSync(Im.encodeJpg(image,quality: 85));

  }

  // this metho for switch Userstate from String to number using for of or on line
  static int stateToNum(UserState userState){
    switch (userState){
      case UserState.offline:
        return 0;

      case UserState.onLine:
        return 1;

      default:
        return 2;
     }
   }

  //  this for reback UserState from num to String
  static UserState numToState(int number){
    switch (number){
      case 0:
        return UserState.offline;

      case 1:
         return UserState.onLine;

      default:
        return UserState.waiting;
     }
   }

 }
