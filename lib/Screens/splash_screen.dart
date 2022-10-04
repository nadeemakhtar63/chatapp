import 'dart:async';

import 'package:chatapp/Authentication/login.dart';
import 'package:chatapp/Screens/chatscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';


class SplashScreen extends StatelessWidget {
  String dotCoderLogo = 'https://raw.githubusercontent.com/OsamaQureshi796/MealMonkey/main/assets/dotcoder.png';
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if(user.isNull){
      Timer(Duration(seconds: 5),()=> Get.offAll(()=>Login()));

    }else{
      Timer(Duration(seconds: 5),()=> Get.offAll(()=>initialScreen()));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(width: Get.width,
                height: 220,
                child: Image.asset('assets/chaticon.png')
              ),
            ),

            SizedBox(
              height: 10,
            ),

         //   Text("FCM by DOTCODER")
//
          ],
        ),
      ),
    );
  }
}