import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Controller/authcontroller.dart';

AuthController authController = AuthController.instance;
//final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
GoogleSignIn googleSign = GoogleSignIn();
const Agora_APP_IDD = '3989624bfcf946b196547ec732aed389';
const dynamic Agora_TOKEN = null;
final fiberchatBlack = new Color(0xFF353f58);
final fiberchatBlue = new Color(0xFF35a6e5);
final fiberchatDeepGreen = new Color(0xFF296ac6);
final fiberchatLightGreen = new Color(0xFF06a2ff);
final fiberchatgreen = new Color(0xFFfa9d1a);
final fiberchatteagreen = new Color(0xFFeefcf8);
final fiberchatWhite = Colors.greenAccent;
final fiberchatGrey = Colors.grey;
final fiberchatChatbackground = new Color(0xffdde6ea);
const IsRemovePhoneNumberFromCallingPageWhenOnCall =
true;