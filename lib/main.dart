import 'dart:convert';
import 'dart:io';

import 'package:chatapp/Authentication/login.dart';
import 'package:chatapp/Authentication/signin.dart';
import 'package:chatapp/Calling/CallHistory.dart';
import 'package:chatapp/Calling/voice_calling/user_provider.dart';
import 'package:chatapp/Controller/authcontroller.dart';
import 'package:chatapp/ModelClasses/DataModel.dart';
import 'package:chatapp/Screens/chatscreen.dart';
import 'package:chatapp/Screens/profile.dart';
import 'package:chatapp/Screens/splash_screen.dart';
import 'package:chatapp/constant/firebase_auth_constant.dart';
import 'package:chatapp/firebaseCud/firebasedatabase.dart';
import 'package:chatapp/flutter_local_notification.dart';
import 'package:chatapp/statues/statues_screen.dart';
import 'package:chatapp/statues/statues_screen_new.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  /// On click listner
}
Future<dynamic> myBackgroundMessageHandlerAndroid(RemoteMessage message) async {
  if (message.data['title'] == 'Call Ended' || message.data['title'] == 'Missed Call') {
    flutterLocalNotificationsPlugin..cancelAll();
    final data = message.data;
    final titleMultilang = data['titleMultilang'];
    final bodyMultilang = data['bodyMultilang'];
    await _showNotificationWithDefaultSound('Missed Call', 'You have Missed a Call', titleMultilang, bodyMultilang);
  } else {
    if (message.data['title'] == 'You have new message(s)' ||
        message.data['title'] == 'New message in Group') {
      //-- need not to do anythig for these message type as it will be automatically popped up.

    } else if (message.data['title'] == 'Incoming Audio Call...' ||
        message.data['title'] == 'Incoming Video Call...') {
      final data = message.data;
      final title = data['title'];
      final body = data['body'];
      final titleMultilang = data['titleMultilang'];
      final bodyMultilang = data['bodyMultilang'];
      await _showNotificationWithDefaultSound(
          title, body, titleMultilang, bodyMultilang);
    }
  }
  return Future<void>.value();
}
// Future<dynamic> myBackgroundMessageHandlerIos(RemoteMessage message) async {
//   await Firebase.initializeApp();

//   if (message.data['title'] == 'Call Ended') {
//     final data = message.data;

//     final titleMultilang = data['titleMultilang'];
//     final bodyMultilang = data['bodyMultilang'];
//     flutterLocalNotificationsPlugin..cancelAll();
//     await _showNotificationWithDefaultSound(
//         'Missed Call', 'You have Missed a Call', titleMultilang, bodyMultilang);
//   } else {
//     if (message.data['title'] == 'You have new message(s)') {
//     } else if (message.data['title'] == 'Incoming Audio Call...' ||
//         message.data['title'] == 'Incoming Video Call...') {
//       final data = message.data;
//       final title = data['title'];
//       final body = data['body'];
//       final titleMultilang = data['titleMultilang'];
//       final bodyMultilang = data['bodyMultilang'];
//       await _showNotificationWithDefaultSound(
//           title, body, titleMultilang, bodyMultilang);
//     }
//   }

//   return Future<void>.value();
// }
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future _showNotificationWithDefaultSound(String? title, String? message,
    String? titleMultilang, String? bodyMultilang) async {
  if (Platform.isAndroid) {
    flutterLocalNotificationsPlugin.cancelAll();
  }
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  var androidPlatformChannelSpecifics =
  title == 'Missed Call' || title == 'Call Ended'
      ? AndroidNotificationDetails(
      'channel_id', 'channel_name',
      importance: Importance.max,
      priority:Priority.high,
      sound: RawResourceAndroidNotificationSound('whistle2'),
      playSound: true,
      ongoing: true,
      visibility: NotificationVisibility.public,
      timeoutAfter: 28000)
      : AndroidNotificationDetails(
      'channel_id', 'channel_name',
      sound: RawResourceAndroidNotificationSound('ringtone'),
      playSound: true,
      ongoing: true,
      importance: Importance.max,
      priority:Priority.high,
      visibility: NotificationVisibility.public,
      timeoutAfter: 28000);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    sound:
    title == 'Missed Call' || title == 'Call Ended' ? '' : 'ringtone.caf',
    presentSound: true,
  );
  var platformChannelSpecifics =NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin
      .show(
    0,
    '$titleMultilang',
    '$bodyMultilang',
    platformChannelSpecifics,
    payload: 'payload',
  )
      .catchError((err) {
    print('ERROR DISPLAYING NOTIFICATION: $err');
  });
}
void main()async{
  LocalNotificationService.initialize;
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
   await Firebase.initializeApp();
  runApp(GetMaterialApp(home:SplashScreen(),));
}
class initialScreen extends StatefulWidget {
  const initialScreen({Key? key}) : super(key: key);
  @override
  _initialScreenState createState() => _initialScreenState();
}
class _initialScreenState extends State<initialScreen>  with WidgetsBindingObserver{
  final upperTab = const TabBar(tabs: <Tab>[
    Tab(text: "CHAT"),
    Tab(text: "STATUS",),
    Tab(text: "CALLS",),
  ]);
  void onSelect(item) {
    switch (item) {
      case 'Profile':
        Navigator.push(context, MaterialPageRoute(
            builder:(context)=>Profile()));
        break;
      case 'SignOut':
        auth.signOut();
        Get.to(Login());
        FirestoreDb.devicestatues(false);
        break;
      case 'Setting':
        print('Setting clicked');
        break;
    }
  }
  var myMenuItems = <String>[
    'Profile',
    'SignOut',
    'Setting',
  ];
  @mustCallSuper
  @protected
  @override
   dispose(){
    setState(() {
      FirestoreDb.devicestatues(false);
      print('value of dispose is');
    });
     WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
     // _notification = state;
    });
    switch(state) {
      case AppLifecycleState.resumed:
        setState(() {
          FirestoreDb.devicestatues(true);
        });
        print('value of resum');
        // Handle this case
        break;
      case AppLifecycleState.inactive:
        setState(() {
          FirestoreDb.devicestatues(false);
        });
        print('value of inactive');
      // Handle this case
        break;
      case AppLifecycleState.paused:
        setState(() {
          FirestoreDb.devicestatues(false);
        });
        print('value of paused');
      // Handle this case
        break;
      case AppLifecycleState.detached:
        setState(() {
          FirestoreDb.devicestatues(false);
        });
        print('value of detached');
      // Handle this case
        break;
    }
  }
  @override
  void detective(){
    super.deactivate();
    FirestoreDb.devicestatues(false);
    print('dispose');
  }
  initState(){
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
FirestoreDb.devicestatues(true);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 10,
              backgroundImage: AssetImage('assets/chaticon.png')),
          ),
          actions: [
            PopupMenuButton<String>(
            onSelected: onSelect,
            itemBuilder: (BuildContext context) {
              return myMenuItems.map((String choice) {
                return PopupMenuItem<String>(
                  child: Row(
                    children: [
                      choice=='Profile'?Icon(Icons.person_sharp,color: Colors.black,):
                      choice=='SignOut'?Icon(Icons.login,color: Colors.black,):
                      choice=='Setting'?Icon(Icons.settings,color: Colors.black,):Text('Empty'),
                     SizedBox(width: 10,),
                      Text(choice),
                    ],
                  ),
                  value: choice,
                );
              }).toList();
            }),
          ],
          bottom: upperTab,
        ),
        body: TabBarView(
          children: <Widget>[
            HomeScreen(token: ''),
            Statues_Screeb(),
            // Status(
            //     currentUserNo: auth.currentUser!.uid,
            //     model: model,
            //  //   prefs: prefs,
            //     currentUserFullname: "nadeem",
            //     currentUserPhotourl: "https://firebasestorage.googleapis.com/v0/b/chatingapp-54fe0.appspot.com/o/046767879502560101253725054218246941432?alt=media&token=3a38b5d8-8b56-4187-bb09-6a7982f67548"),
            CallHistory()
          ],
        ),
      ),
    );
  }
 //DataModel? model;
}
