import 'dart:io';
import 'package:chatapp/Authentication/login.dart';
import 'package:chatapp/ModelClasses/contect_list_moduleclass.dart';
import 'package:chatapp/ModelClasses/mesg_module.dart';
import 'package:chatapp/ModelClasses/profileModule.dart';
import 'package:chatapp/Screens/chatscreen.dart';
import 'package:chatapp/firebaseCud/firebasedatabase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chatapp/constant/firebase_auth_constant.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import '../Authentication/signin.dart';
enum authProblems { UserNotFound, PasswordNotValid, NetworkError }
class AuthController extends GetxController
{
  RxBool sharebox = false.obs;
static AuthController instance=Get.find();
late Rx<User?> firebaseUser;

Rx<List<TodoModel>> todoList = Rx<List<TodoModel>>([]);
List<TodoModel> get todos => todoList.value;

Rx<List<ContectModel>> contectList = Rx<List<ContectModel>>([]);
List<ContectModel> get contects => contectList.value;

late Rx<GoogleSignInAccount?> googleSignInAccount;
void onReady(){
  super.onReady();
  contectList.bindStream(FirestoreDb.contectStream());
  todoList.bindStream(FirestoreDb.todoStream());
  firebaseUser=Rx<User?>(auth.currentUser);
  firebaseUser.bindStream(auth.userChanges());
  googleSignInAccount = Rx<GoogleSignInAccount?>(googleSign.currentUser);
 // ever(firebaseUser,_setInitialScreen);
}
// _setInitialScreenGoogle(GoogleSignInAccount? googleSignInAccount) {
//   print(googleSignInAccount);
//   if (googleSignInAccount == null) {
//     // if the user is not found then the user is navigated to the Register Screen
//     Get.offAll(() => const Register());
//   } else {
//     // if the user exists and logged in the the user is navigated to the Home Screen
//     Get.offAll(() => Home());
//   }
// }

// void signInWithGoogle() async {
//   try {
//     GoogleSignInAccount? googleSignInAccount = await googleSign.signIn();
//
//     if (googleSignInAccount != null) {
//       GoogleSignInAuthentication googleSignInAuthentication =
//       await googleSignInAccount.authentication;
//
//       AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );
//
//       await auth
//           .signInWithCredential(credential)
//           .catchError((onErr) => print(onErr));
//     }
//   } catch (e) {
//     Get.snackbar(
//       "Error",
//       e.toString(),
//       snackPosition: SnackPosition.BOTTOM,
//     );
//     print(e.toString());
//   }
// }
// _setInitialScreen(User? user){
// if(user==null)
//   {
//     Get.offAll(()=>Login());
//   }
// else
//   {
//     Get.offAll(()=>initialScreen());
//   }
// }
void login(String email,String password)async
{
  try {
    final user = await auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (user != null) {
      String? token=await FirebaseMessaging.instance.getToken();
      firebaseFirestore.collection("user").doc(auth.currentUser!.uid).set({
        'token':token
      },SetOptions(merge: true));
      print('my token$token');
      Get.to(initialScreen());
    }
  }
  catch(e)
  {
    Get.snackbar("Error", e.toString());
  }
}
void register(String email,String password,images,file,String uname,statues,stvalidate)async{
  try
  {
   final user= await auth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
   if(user!=null)
     {
       final ref = FirebaseStorage.instance.ref(auth.currentUser!.uid);
       await ref.putFile(images);
       String url = await ref.getDownloadURL();
       print("image url is =$url");
       await firebaseFirestore.collection("user").doc(auth.currentUser!.uid).set({
         'username':uname,
         'email':email,
         'url':url,
         'lastmessage':"null",
         'statues':stvalidate?"new Employee":statues,
          'uid':auth.currentUser!.uid
         
       });
     }
  }
  catch (e) {
    authProblems? errorType;
    if (Platform.isAndroid) {
      switch (e) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = authProblems.UserNotFound;
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = authProblems.PasswordNotValid;
          break;
        case 'A network error ( such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = authProblems.NetworkError;
          break;
      // ...
        default:
          print('Case ${e} is not yet implemented');
      }
    }
    print('The error is $errorType');
  }
}
void signout()async{
  await auth.signOut();
  Get.to(Login());
}
}