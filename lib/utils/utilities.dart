// this class for great sing and make username uniq

import 'package:flutter/material.dart';

class Utils {
  // this class for great sing and make username uniq
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
}
