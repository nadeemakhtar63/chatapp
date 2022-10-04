//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Calling/voice_calling/call.dart';
import 'package:chatapp/Calling/voice_calling/caller.dart';
import 'package:chatapp/Calling/voice_calling/video_call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Function/cached_image.dart';
import '../../Utils/permissions.dart';
import '../../Widget/pdf_file/call_history_provider.dart';
import '../../constant/Dbpaths.dart';
import '../../constant/firebase_auth_constant.dart';
import '../../main.dart';
import 'call_methods.dart';

// ignore: must_be_immutable
class PickupScreen extends StatelessWidget {
  final Call call;
  final String? currentuseruid;
  final CallMethods callMethods = CallMethods();

  PickupScreen({
    required this.call,
    required this.currentuseruid,
  });
  ClientRole _role = ClientRole.Broadcaster;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Consumer<FirestoreDataProviderCALLHISTORY>(
        builder: (context, firestoreDataProviderCALLHISTORY, _child) => h > w &&
                ((h / w) > 1.5)
            ? Scaffold(
                backgroundColor: fiberchatDeepGreen,
                body: Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        color: Colors.green,
                        height: h / 4,
                        width: w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 7,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  call.isvideocall == true
                                      ? Icons.videocam
                                      : Icons.mic_rounded,
                                  size: 40,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  call.isvideocall == true
                                      ?  'incomingvideo'
                                      : 'incomingaudio',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: h / 9,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 7),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: Text(
                                      call.callerName!,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.indigo,
                                        fontSize: 27,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    call.callerId!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.greenAccent,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(height: h / 25),

                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      call.callerPic == null || call.callerPic == ''
                          ? Container(
                              height: w + (w / 140),
                              width: w,
                              color: Colors.white12,
                              child: Icon(
                                Icons.person,
                                size: 140,
                                color: fiberchatDeepGreen,
                              ),
                            )
                          : Stack(
                              children: [
                                Container(
                                    height: w + (w / 140),
                                    width: w,
                                    color: Colors.white12,
                                    child: CachedNetworkImage(
                                      imageUrl: call.callerPic!,
                                      fit: BoxFit.cover,
                                      height: w + (w / 140),
                                      width: w,
                                      placeholder: (context, url) => Center(
                                          child: Container(
                                        height: w + (w / 140),
                                        width: w,
                                        color: Colors.white12,
                                        child: Icon(
                                          Icons.person,
                                          size: 140,
                                          color: fiberchatDeepGreen,
                                        ),
                                      )),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: w + (w / 140),
                                        width: w,
                                        color: Colors.white12,
                                        child: Icon(
                                          Icons.person,
                                          size: 140,
                                          color: fiberchatDeepGreen,
                                        ),
                                      ),
                                    )),
                                Container(
                                  height: w + (w / 140),
                                  width: w,
                                  color: Colors.black.withOpacity(0.18),
                                ),
                              ],
                            ),
                      Container(
                        height: h / 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RawMaterialButton(
                              onPressed: () async {
                                flutterLocalNotificationsPlugin.cancelAll();
                                await callMethods.endCall(call: call);
                                FirebaseFirestore.instance
                                    .collection(DbPaths.collectionusers)
                                    .doc(call.callerId)
                                    .collection(DbPaths.collectioncallhistory)
                                    .doc(call.timeepoch.toString())
                                    .set({
                                  'STATUS': 'rejected',
                                  'ENDED': DateTime.now(),
                                }, SetOptions(merge: true));
                                FirebaseFirestore.instance
                                    .collection(DbPaths.collectionusers)
                                    .doc(call.receiverId)
                                    .collection(DbPaths.collectioncallhistory)
                                    .doc(call.timeepoch.toString())
                                    .set({
                                  'STATUS': 'rejected',
                                  'ENDED': DateTime.now(),
                                }, SetOptions(merge: true));
                                //----------
                                await FirebaseFirestore.instance
                                    .collection(DbPaths.collectionusers)
                                    .doc(call.receiverId)
                                    .collection('recent')
                                    .doc('callended')
                                    .set({
                                  'id': call.receiverId,
                                  'ENDED': DateTime.now().millisecondsSinceEpoch
                                }, SetOptions(merge: true));

                                firestoreDataProviderCALLHISTORY.fetchNextData(
                                    'CALLHISTORY',
                                    FirebaseFirestore.instance
                                        .collection(DbPaths.collectionusers)
                                        .doc(call.receiverId)
                                        .collection(
                                            DbPaths.collectioncallhistory)
                                        .orderBy('TIME', descending: true)
                                        .limit(14),
                                    true);
                              },
                              child: Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 35.0,
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.redAccent,
                              padding: const EdgeInsets.all(15.0),
                            ),
                            SizedBox(width: 45),
                            RawMaterialButton(
                              onPressed: () async {
                                flutterLocalNotificationsPlugin.cancelAll();
                                await Permissions
                                        .cameraAndMicrophonePermissionsGranted()
                                    .then((isgranted) async {
                                  if (isgranted == true) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => call
                                                    .isvideocall ==
                                                true
                                            ? VideoCall(
                                                currentuseruid: currentuseruid,
                                                call: call,
                                                channelName: call.channelId,
                                                role: _role,
                                              )
                                            : AudioCall(
                                                currentuseruid: currentuseruid,
                                                call: call,
                                                channelName: call.channelId,
                                                role: _role,
                                              ),
                                      ),
                                    );
                                  } else {
                                  //  Fiberchat.showRationale( 'pmc');
                                  //   Navigator.push(
                                  //       context,
                                  //       new MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               OpenSettings()));
                                  }
                                }).catchError((onError) {
                                  // Fiberchat.showRationale(
                                  //     getTranslated(context, 'pmc'));
                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             OpenSettings()));
                                });
                              },
                              child: Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 35.0,
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.green[400],
                              padding: const EdgeInsets.all(15.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            : Scaffold(
                backgroundColor: Colors.green,
                body: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: w > h ? 60 : 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        w > h
                            ? SizedBox(
                                height: 0,
                              )
                            : Icon(
                                call.isvideocall == true
                                    ? Icons.videocam_outlined
                                    : Icons.mic,
                                size: 80,
                                color: Colors.green,
                              ),
                        w > h
                            ? SizedBox(
                                height: 0,
                              )
                            : SizedBox(
                                height: 20,
                              ),
                        Text(
                          call.isvideocall == true
                              ?  'incomingvideo'
                              : 'incomingaudio',
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.white
                          ),
                        ),
                        SizedBox(height: w > h ? 16 : 50),
                        CachedImage(
                          call.callerPic,
                          isRound: true,
                          height: w > h ? 60 : 110,
                          width: w > h ? 60 : 110,
                          radius: w > h ? 70 : 138,
                        ),
                        SizedBox(height: 15),
                        Text(
                          call.callerName!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: w > h ? 30 : 75),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RawMaterialButton(
                              onPressed: () async {
                                flutterLocalNotificationsPlugin.cancelAll();
                                await callMethods.endCall(call: call);
                                FirebaseFirestore.instance
                                    .collection(DbPaths.collectionusers)
                                    .doc(call.callerId)
                                    .collection(DbPaths.collectioncallhistory)
                                    .doc(call.timeepoch.toString())
                                    .set({
                                  'STATUS': 'rejected',
                                  'ENDED': DateTime.now(),
                                }, SetOptions(merge: true));
                                FirebaseFirestore.instance
                                    .collection(DbPaths.collectionusers)
                                    .doc(call.receiverId)
                                    .collection(DbPaths.collectioncallhistory)
                                    .doc(call.timeepoch.toString())
                                    .set({
                                  'STATUS': 'rejected',
                                  'ENDED': DateTime.now(),
                                }, SetOptions(merge: true));
                                //----------
                                await FirebaseFirestore.instance
                                    .collection(DbPaths.collectionusers)
                                    .doc(call.receiverId)
                                    .collection('recent')
                                    .doc('callended')
                                    .set({
                                  'id': call.receiverId,
                                  'ENDED': DateTime.now().millisecondsSinceEpoch
                                }, SetOptions(merge: true));

                                firestoreDataProviderCALLHISTORY.fetchNextData(
                                    'CALLHISTORY',
                                    FirebaseFirestore.instance
                                        .collection(DbPaths.collectionusers)
                                        .doc(call.receiverId)
                                        .collection(
                                            DbPaths.collectioncallhistory)
                                        .orderBy('TIME', descending: true)
                                        .limit(14),
                                    true);
                              },
                              child: Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 35.0,
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.redAccent,
                              padding: const EdgeInsets.all(15.0),
                            ),
                            SizedBox(width: 45),
                            RawMaterialButton(
                              onPressed: () async {
                                flutterLocalNotificationsPlugin.cancelAll();
                                await Permissions
                                        .cameraAndMicrophonePermissionsGranted()
                                    .then((isgranted) async {
                                  if (isgranted == true) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => call
                                                    .isvideocall ==
                                                true
                                            ? VideoCall(
                                                currentuseruid: currentuseruid,
                                                call: call,
                                                channelName: call.channelId,
                                                role: _role,
                                              )
                                            : AudioCall(
                                                currentuseruid: currentuseruid,
                                                call: call,
                                                channelName: call.channelId,
                                                role: _role,
                                              ),
                                      ),
                                    );
                                  } else {
                                    // Fiberchat.showRationale(
                                    //     getTranslated(context, 'pmc'));
                                    // Navigator.push(
                                    //     context,
                                    //     new MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             OpenSettings()));
                                  }
                                }).catchError((onError) {
                                  // Fiberchat.showRationale(
                                  //     getTranslated(context, 'pmc'));
                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             OpenSettings()));
                                });
                              },
                              child: Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 35.0,
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: fiberchatLightGreen,
                              padding: const EdgeInsets.all(15.0),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
