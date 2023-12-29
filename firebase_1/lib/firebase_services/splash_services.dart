import 'dart:async';

import 'package:firebase_1/auth/login_screen.dart';
import 'package:firebase_1/posts/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => PostScreen())));
    }
    //if user is already login then go to the postcsreen when the app is open
    else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }
    //if user is not login then to the login screen and login
  }
}
