import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FirebseMessagings extends StatefulWidget {
  const FirebseMessagings({Key? key}) : super(key: key);

  @override
  State<FirebseMessagings> createState() => _FirebseMessagingState();
}

class _FirebseMessagingState extends State<FirebseMessagings>{
   final FirebaseMessaging _firebaseMessaging=FirebaseMessaging.instance;
  _getToken(){
    _firebaseMessaging.getToken().then((deviceToken) {
    print("device token $deviceToken");
    });
  }
  void initState()
  {
    super.initState();
    _getToken();
  }
  _configureFirebaseListner() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("on Messaging $message");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage lunchresume) {
      print("on Messaging $lunchresume");
    });

  }
  @override
  Widget build(BuildContext context) {
    return Container();

}
}
