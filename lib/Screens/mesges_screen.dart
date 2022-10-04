import 'dart:convert';
import 'package:chatapp/Screens/pdffile.dart';
import 'package:chatapp/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/AudioRecordFolder/AudioPlayerMessage.dart';
import 'package:chatapp/AudioRecordFolder/SoundRecorder.dart';
import 'package:chatapp/AudioRecordFolder/timercontroller.dart';
import 'package:chatapp/Calling/voice_calling/caller.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/Controller/authcontroller.dart';
import 'package:chatapp/ModelClasses/mesg_module.dart';
import 'package:chatapp/Screens/imageshare.dart';
import 'package:chatapp/Screens/imageshow.dart';
import 'package:chatapp/constant/firebase_auth_constant.dart';
import 'package:chatapp/firebaseCud/firebasedatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Calling/voice_calling/Observer.dart';
import '../Calling/voice_calling/call.dart';
import '../CloudeAudioRecorded/homeviewaudio/home.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../constant/firebase_auth_constant.dart';
import '../Utils/call_utilities.dart';
import '../Utils/permissions.dart';
class ChatScreen extends StatefulWidget {
  final String uname;
  final String statues;
  final String url;
  final String uid;
  final String? token;
   var statuestime;
  final bool? devicestate;
  final LocalFileSystem localFileSystem;
 ChatScreen({localFileSystem, required this.uname,
   required this.statues, required this.url,
   required this.uid,this.statuestime,this.devicestate, this.token}) : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  // ChatScreen({Key? key,required this.token,required this.uname,required this.statues,required this.url,required this.uid}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 // final LocalFileSystem localFileSystem;
  TextEditingController contentTextEditorController=new TextEditingController();
  AuthController mesgcontroller=Get.put<AuthController>(AuthController());
   File? imageFile;
  DateFormat df = new DateFormat('yyyy-MM-dd HH:mm:ss');
  PickedFile? pickedFile;

  _getFromGallery() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile!.path);
      });
    if(imageFile!=null)
      {
        Get.to(ImageShare(imageFile: imageFile,uid: widget.uid,idkey: "msg",));
      }
    }
  }
  /// Get from camera
  _getFromCamera() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = (File(pickedFile!.path));
      });
      if(imageFile!=null)
      {
        Get.to(ImageShare(imageFile: imageFile,uid: widget.uid,idkey: "msg",));
      }
    }
  }
  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Media"),
      actions: [
        IconButton(onPressed: (){
          _getFromCamera();
          Navigator.pop(context);
        }, icon: Icon(Icons.camera_alt)),
        IconButton(onPressed: (){
          _getFromGallery();
          Navigator.pop(context);
        }, icon: Icon(Icons.description))
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showAlertDeleteDialog(BuildContext context) {
    // Widget okButton = TextButton(
    //   child: Text("OK"),
    //   onPressed: ()async {
    //     print(id);
    //     print(widget.uid);
    //  var res= await  FirestoreDb.deleteTodo(id, widget.uid);
    //  print("res : $res");
    //   Navigator.pop(context);
    //
    //     },
    // );
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          appbaritemchoose=false;
        });
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Delete Message??"),

      actions: [
        TextButton(onPressed: (){

          setState(() {
            appbaritemchoose=false;
            print(id);
            print(widget.uid);
            FirestoreDb.deleteTodo(id, widget.uid);
            Navigator.pop(context);
          });
        }, child: Text("Delete for me?")),
        // TextButton(onPressed: (){
        //
        //   setState(() {
        //     appbaritemchoose=false;
        //     print(id);
        //     print(widget.uid);
        //     FirestoreDb.deletereciversenderTodo(id, widget.uid);
        //     Navigator.pop(context);
        //   });
        // }, child: Text("Delete both side?")),
        //okButton,
        cancelButton
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  _onEmojiSelected(Emoji emoji) {
    contentTextEditorController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: contentTextEditorController.text.length));
  }
  _onBackspacePressed() {
    contentTextEditorController
      ..text = contentTextEditorController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: contentTextEditorController.text.length));
  }
  String masgstates='';
  bool contentshare=false;
  bool emojishare=false;
  bool audioplay=false;
  bool recordingStope=false;
  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  @override
  void initState() {
    // TODO: implement initState
   // devicestatues();
    // TODO: implement initState
    _init();
    super.initState();
    Fiberchat.internetLookUp();
  }

  call(BuildContext context, bool isvideocall) async {

    CallUtils.dial(
        currentuseruid: widget.uid,
        fromDp: widget.url,
        toDp: widget.uid,
        fromUID: auth.currentUser!.uid,
        fromFullname: widget.uname,
        toUID: widget.uid,
        toFullname: widget.uname,
        context: context,
        isvideocall: isvideocall);
  }
  ScrollController _controller = ScrollController();

  bool hasPeerBlockedMe = false;
  bool iscallsallowed=true;
  bool isCallFeatureTotallyHide=true;
  bool devicestate=false;
  //var statuestime;
  showDialOptions() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          // return your layout
          return Consumer(
              builder: (context, observer, _child) => Container(
                  padding: EdgeInsets.all(12),
                  height: 130,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: iscallsallowed == false
                              ? () {
                            Navigator.of(this.context).pop();
                            Get.snackbar("Alert",'callnotallowed');
                          }
                              : hasPeerBlockedMe == true
                              ? () {
                            Navigator.of(this.context).pop();
                            Get.snackbar("Alert", 'userhasblocked');
                          }
                              : () async {
                            // final observer = Provider.of<Observer>(
                            //     this.context,
                            //     listen: false);

                            await Permissions
                                .cameraAndMicrophonePermissionsGranted()
                                .then((isgranted) {
                              if (isgranted == true) {
                                Navigator.of(this.context).pop();
                                FirestoreDb.updatelasttextmesage("call", widget.uid, "call");

                                call(this.context, false);
                              } else {

                                Navigator.of(this.context).pop();
                                Get.snackbar("Alert",'pmc');

                              }
                            }).catchError((onError) {
                              Get.snackbar("Alert",'pmc');
                              // Navigator.push(
                              //     context,
                              //     new MaterialPageRoute(
                              //         builder: (context) =>
                              //             OpenSettings()));
                            });
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 13),
                                Icon(
                                  Icons.local_phone,
                                  size: 35,
                                  color: fiberchatLightGreen,
                                ),
                                SizedBox(height: 13),
                                Text('audiocall',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: fiberchatBlack),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: iscallsallowed == false
                                ? () {
                              Navigator.of(this.context).pop();
                              Get.snackbar("Alert",'callnotallowed');
                            }
                                : hasPeerBlockedMe == true
                                ? () {
                              Navigator.of(this.context).pop();
                              Get.snackbar("Alert", 'userhasblocked');
                            }
                                : () async {
                              // final observer = Provider.of<Observer>(
                              //     this.context,
                              //     listen: false);
                              await Permissions
                                  .cameraAndMicrophonePermissionsGranted()
                                  .then((isgranted) {
                                if (isgranted == true) {
                                  FirestoreDb.updatelasttextmesage("call", widget.uid, "call");
                                  Navigator.of(this.context).pop();
                                  call(this.context, true);
                                } else {
                                  Navigator.of(this.context).pop();
                                  Get.snackbar("Alert",'pmc');
                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             OpenSettings()));
                                }
                              }).catchError((onError) {
                                Get.snackbar("Alert",'pmc');
                                // Navigator.push(
                                //     context,
                                //     new MaterialPageRoute(
                                //         builder: (context) =>
                                //             OpenSettings()));
                              });
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 13),
                                  Icon(
                                    Icons.videocam,
                                    size: 39,
                                    color: fiberchatLightGreen,
                                  ),
                                  SizedBox(height: 13),
                                  Text('videocall',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: fiberchatBlack),
                                  ),
                                ],
                              ),
                            ))
                      ])
              ));
        });
  }
  //     void devicestatues()async{
  //       var collection = FirebaseFirestore.instance.collection('Devicestatues');
  //       var docSnapshot = await collection.doc(widget.uid).get();
  //       if (docSnapshot.exists) {
  //         Map<String, dynamic>? data = docSnapshot.data();
  //        setState(() {
  //          devicestate = data?['statues'];
  //          statuestime=data?['time']==null?0:data?['time'];
  //        });
  //         print('device statues: $statuestime');
  //         print('device statues: $devicestate');
  //       }
  // }
  String id='';
  bool appbaritemchoose=false;
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 500), () =>
    setState(() {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }));
      return Scaffold(
      appBar: AppBar(
        title:Column(
          children: [
            Text(widget.uname),
            widget.devicestate==null?Container()
                :widget.devicestate==true?
            Text('online',style: TextStyle(fontSize: 9),):
            Text((timeago.format((widget.statuestime).toDate())==null?
            "Last Seen":timeago.format(widget.statuestime.toDate())
            ), style: TextStyle(fontSize: 11)),
          ],
        ),
        actions: [
          isCallFeatureTotallyHide == false
              || appbaritemchoose==true?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(
                    onPressed:(){
                   //   print(id);
                      showAlertDeleteDialog(context);
                    },
                   icon:( Icon(Icons.delete,color: Colors.red,))),
                  SizedBox(height: 20,),
                  Icon(Icons.share)
                ],
              )
              : SizedBox(
            width: 55,
            child: IconButton(
                icon: Icon(
                  Icons.add_call,
                ),
                onPressed:
               iscallsallowed ==
                    false
                    ? () {
                  Get.snackbar("Alert", 'callnotallowed');
                  // Fiberchat.showRationale(
                  //     getTranslated(
                  //         this.context,
                  //         'callnotallowed'));
                }
                    : hasPeerBlockedMe == true
                    ? () {
                  Get.snackbar("Alert",
                        'userhasblocked'
                  );
                }
                    : () async {
                  showDialOptions();
                }),
          ),
          // IconButton(
          //     onPressed: (){
          //       call(this.context, false);
          // }, icon:Icon(Icons.call)),
          SizedBox(
            width: 15,
          ),
        ],
         ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
                  Expanded(
            child: StreamBuilder<QuerySnapshot>(
             stream: firebaseFirestore.collection('Messages').doc(auth.currentUser!.uid).
             collection(((auth.currentUser!.uid)+widget.uid)).orderBy('createdon', descending: false).snapshots() ,
               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData || snapshot.hasError)
                {
                  return Text('');
                }
              else
                     return Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: new ListView
                         (
                       //  controller: _controller,
                           children: getExpenseItems(snapshot),
                       ),
                     );
                     }),
                ),
       contentshare?    Padding(
              padding: const EdgeInsets.only(left: 20,right: 20.0),
              child: Container(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  //  buildStart(),
                   IconButton(
                       onPressed:()
                       {
                         setState(() {
                         //  Get.to(RecorderExample());
                           audioplay=!audioplay;
                           contentshare=!contentshare;
                         });
                       }
                       , icon: Icon(Icons.mic,size: 24,)),
                    IconButton(
                        onPressed:()
                        {
                          getPdfAndUpload(widget.uid);
                         //getPdfAndUpload(imageFile,auth.currentUser!.uid);
                        }
                        , icon: Icon(Icons.attachment,size: 24,)),
                    IconButton(
                        onPressed:()
                        {
                          showAlertDialog(context);
                        }
                        , icon: Icon(Icons.image,size: 24,)),
                    IconButton(
                        onPressed:()
                        {
                          setState(() {
                            emojishare=!emojishare;
                          });
                        }
                        , icon: Icon(Icons.workspaces_filled,size: 24,)),
                  ],
                ),
              ),
            ):Container(),
            audioplay?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        switch (_currentStatus) {
                          case RecordingStatus.Initialized:
                            {
                              _start();
                              break;
                            }
                          case RecordingStatus.Recording:
                            {

                              _pause();
                              break;
                            }
                          case RecordingStatus.Paused:
                            {
                              _resume();
                              break;
                            }
                          case RecordingStatus.Stopped:
                            {

                              _init();
                              break;
                            }
                          default:
                            break;
                        }
                      },
                      child: _buildText(_currentStatus),
                    ),
                    IconButton(onPressed: _currentStatus != RecordingStatus.Unset ? _stop : null,
                        icon: Icon(Icons.stop,size: 35,)),

                    IconButton(onPressed: onPlayAudio, icon: Icon(Icons.play_arrow,size: 35,)),
                    Text("${_current?.duration.toString()}"),
                    IconButton(
                        onPressed: ()async{
                          // final todoModel = TodoModel(
                          //     content: contentTextEditorController.text.trim(),
                          //     isDone: false,
                          //     uid: widget.uid
                          // );
                          if(fileaudio!=null) {
                            _init();
                            FirestoreDb.updatelasttextmesage("audio message", widget.uid, "audio");
                            await FirestoreDb.uploadAudioToStorage(
                                fileaudio!, widget.uid,_current?.duration.toString());

                            await FirestoreDb.updatelasttextmesage(contentTextEditorController.text.trim(),widget.uid,"audio");
                            contentTextEditorController.clear();
                            sendNotification(contentTextEditorController.text
                                .trim(), widget.token.toString());
                            setState(() {
                              // Timer(Duration(milliseconds: 500), () => _controller.jumpTo(_controller.position.maxScrollExtent));
                              // audioplay=!audioplay;
                              Navigator.pop(context);
                            });
                          }
                          else
                            {
                              Get.snackbar('ERROR', 'Stop audio before uploading ');
                            }
                        }, icon: Icon(Icons.send,size: 35)) ,
                  ],
                ),
              ),
            ): TextField(
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Text here..",
                  prefixIcon:
                  IconButton(
                      onPressed:()
                      {
                        setState(() {
                          contentshare=!contentshare;
                        });
                       }
                  , icon: Icon(Icons.add_to_drive,size: 30,)),

                  suffixIcon: IconButton(
                      onPressed: ()async{
                        if(contentTextEditorController.text!='') {
                          final todoModel = TodoModel(
                              content: contentTextEditorController.text.trim(),
                              isDone: false,
                              uid: widget.uid
                          );
                          await FirestoreDb.addTodo(todoModel, widget.uid);
                          await FirestoreDb.updatelasttextmesage(contentTextEditorController.text.trim(),widget.uid,"msg");
                          contentTextEditorController.clear();
                          // Timer(Duration(milliseconds: 500), () =>
                          //     _controller.jumpTo(_controller.position
                          //         .maxScrollExtent));
                          // sendNotification(contentTextEditorController.text.trim(), widget.token.toString());
                        }
    }, icon: Icon(Icons.send,size: 35)) ,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              controller: contentTextEditorController,
            ),
            emojishare? Container(
              height: 200,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
              _onEmojiSelected(emoji);
                // Do something when emoji is tapped
              },
              onBackspacePressed: () {
                _onBackspacePressed();
                setState(() {
                  emojishare=!emojishare;
                });
                // Backspace-Button tapped logic
                // Remove this line to also remove the button in the UI
              },
              config: Config(
                  columns: 7,
                  emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                 // initCategory: Category.RECENT,
                  bgColor: Color(0xFFF2F2F2),
                  indicatorColor: Colors.blue,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.blue,
                  progressIndicatorColor: Colors.blue,
                  backspaceColor: Colors.blue,
                  skinToneDialogBgColor: Colors.white,
                  skinToneIndicatorColor: Colors.grey,
                  enableSkinTones: true,
                  showRecentsTab: true,
                  recentsLimit: 28,
                  noRecentsText: "No Recents",
                  noRecentsStyle:
                  const TextStyle(fontSize: 20, color: Colors.black26),
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL
              ),
            ),
            ):Container(),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot){
   return snapshot.data!.docs.map((doc) =>
  doc['msgstatus']==null?Container(): doc["msgstatus"]=="send"? Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(
             decoration: BoxDecoration(
               color: Colors.indigo,
              borderRadius: BorderRadius.only(bottomRight:Radius.circular(10),
                  topLeft:Radius.circular(10) ,
                  topRight:Radius.circular(10))
             ),
               child:doc["audioMessage"]==null? doc["imageshare"]==null?doc["file"]==null?
                  InkWell(
                    onTap: (){
                      setState(() {
                        appbaritemchoose=false;
                      });

                    },
                    onLongPress: (){
                      setState(() {
                        id=doc.id;
                        appbaritemchoose=true;
                      });
                    },
                    child: Padding(
                     padding: const EdgeInsets.all(10.0),
                     child:
                     // Slidable(
                     //   actionPane: SlidableDrawerActionPane(),
                     //  // actionExtentRatio: 0.25,
                     //   child: Container(
                     //     //   color: Colors.white,
                     //     child:
                     //     ListTile(
                     //       // leading: CircleAvatar(
                     //       //   backgroundColor: Colors.indigoAccent,
                     //       //   child: Icon(Icons.description),
                     //       //   //  foregroundColor: Colors.white,
                     //       // ),
                     //       title:  Text(doc["content"],style: TextStyle(fontSize: 18),)
                     //       //  subtitle: Text('SlidableDrawerDelegate'),
                     //     ),
                     //   ),
                     //   secondaryActions: <Widget>[
                     //     IconSlideAction(
                     //       caption: 'More',
                     //       color: Colors.black45,
                     //       icon: Icons.more_horiz,
                     //       // onTap: () => _showSnackBar('More'),
                     //     ),
                     //     IconSlideAction(
                     //       caption: 'Delete',
                     //       color: Colors.red,
                     //       icon: Icons.delete,
                     //       // onTap: () => _showSnackBar('Delete'),
                     //     ),
                     //   ],
                     // )
                      Text(doc["content"],style: TextStyle(fontSize: 18),)
               ),
                  ):
               // Slidable(
               //   actionPane: SlidableDrawerActionPane(),
               //   actionExtentRatio: 0.25,
               //   child: Container(
               //     //   color: Colors.white,
               //     child: InkWell(
               //       onTap: () {
               //         Get.to(PDFScreen(path: remotePDFpath));
               //         // Get.to(PDFFILESHOW(pdflink: doc['file'],));
               //         createFileOfPdfUrl(doc['file']).then((f) {
               //           setState(() {
               //             remotePDFpath = f.path;
               //           });
               //           Timer(Duration(seconds: 3), () =>
               //               CircularProgressIndicator()
               //           );
               //
               //         });
               //       },
               //
               //       child: ListTile(
               //
               //         leading: CircleAvatar(
               //           backgroundColor: Colors.indigoAccent,
               //           child: Icon(Icons.description),
               //           //  foregroundColor: Colors.white,
               //         ),
               //         title:  Flexible(
               //           flex: 1,
               //           child: Text(doc['content'],
               //               maxLines: 1,
               //               overflow: TextOverflow.ellipsis,style: new TextStyle(
               //                 fontSize: 13.0,)),
               //         ),
               //         //  subtitle: Text('SlidableDrawerDelegate'),
               //       ),
               //     ),
               //   ),
               //   actions: <Widget>[
               //     IconSlideAction(
               //       caption: 'Archive',
               //       color: Colors.blue,
               //       icon: Icons.archive,
               //       // onTap: () => _showSnackBar('Archive'),
               //     ),
               //     IconSlideAction(
               //       caption: 'Share',
               //       color: Colors.indigo,
               //       icon: Icons.share,
               //       // onTap: () => _showSnackBar('Share'),
               //     ),
               //   ],
               //   secondaryActions: <Widget>[
               //     IconSlideAction(
               //       caption: 'More',
               //       color: Colors.black45,
               //       icon: Icons.more_horiz,
               //       // onTap: () => _showSnackBar('More'),
               //     ),
               //     IconSlideAction(
               //       caption: 'Delete',
               //       color: Colors.red,
               //       icon: Icons.delete,
               //       // onTap: () => _showSnackBar('Delete'),
               //     ),
               //   ],
               // )
               Container(
                 //   color: Colors.white,
                 child: InkWell(
                   onLongPress: (){
                     setState(() {
                       id=doc.id;
                       appbaritemchoose=true;
                     });
                   },
                   onTap: () {
                     Get.to(PDFScreen(path: remotePDFpath));
                     // Get.to(PDFFILESHOW(pdflink: doc['file'],));
                     createFileOfPdfUrl(doc['file']).then((f) {
                       setState(() {
                         remotePDFpath = f.path;
                       });
                       Timer(Duration(seconds: 3), () =>
                           CircularProgressIndicator()
                       );

                     });
                   },

                   child: ListTile(

                     leading: CircleAvatar(
                       backgroundColor: Colors.indigoAccent,
                       child: Icon(Icons.description),
                       //  foregroundColor: Colors.white,
                     ),
                     title:  Flexible(
                       flex: 1,
                       child: Text(doc['content'],
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,style: new TextStyle(
                             fontSize: 13.0,)),
                     ),
                     //  subtitle: Text('SlidableDrawerDelegate'),
                   ),
                 ),
               ) :
             InkWell(
               onLongPress: (){
                 setState(() {
                   appbaritemchoose=true;
                   id=doc.id;
                 });
               },
                 onTap: (){
                   Get.to(ImageShow(imageFile: doc['imageshare'],));
                 },
                 child: Padding(
                     padding: const EdgeInsets.all(10.0),
                     child:  Column(
                       children: [
                         Container(
                           height: 250,
                           width: 150,
                           decoration: BoxDecoration(
                          //   color: Colors.red,
                              //borderRadius: BorderRadius.circular(120),

                               image: DecorationImage(image: NetworkImage(doc['imageshare']),fit: BoxFit.cover)
                           ),
                         ),
                         Text(doc["content"],style: TextStyle(fontSize: 18),),
                       ],
                     )
                 ),
               ):
               InkWell(
                   onLongPress: (){
                     setState(() {
                       id=doc.id;
                       appbaritemchoose=true;
                     });
                   },
                   child: AudioPlayerMessage(source:doc["audioMessage"]))),
           //     Container(
           //                 color: Colors.black12,
           //                  width: double.infinity,
           //                  height: 60,
           //                 child:
           //                 Row(
           //                 mainAxisAlignment: MainAxisAlignment.center,
           //                children: <Widget>[
           //                 audiogetplay?  IconButton(
           //                  icon: Icon(Icons.play_arrow),
           //                 onPressed: () {
           //                setState(() {
           //               audiogetplay=!audiogetplay;
           //               audio.play(doc['audioMessage']);
           //                // print(doc["audioMessage"]) ;
           //               });
           //
           //               }):
           //                 IconButton(
           //                  icon: Icon(Icons.pause),
           //                onPressed: () {
           //                 setState(() {
           //                 audiogetplay=!audiogetplay;
           //                 audio.pause();
           //                 });
           //
           //            }),
           //         IconButton(
           //          icon: Icon(Icons.stop),
           //          onPressed: () {
           //            setState(() {
           //              audio.stop();
           //            });
           //
           //         }),
           //      //   audio.seek(position)
           //         ],
           //      ),
           //   )
           // ),
           Text((timeago.format(doc['createdon'].toDate()).toString()),style: TextStyle(fontSize: 11)),
           SizedBox(height: 20,)
         ],
       ):Column(
     mainAxisAlignment: MainAxisAlignment.end,
     crossAxisAlignment: CrossAxisAlignment.end,
     children: [
       Container(
           decoration: BoxDecoration(
               color: Colors.teal,
               borderRadius: BorderRadius.circular(10)
           ),
           child:doc["audioMessage"]==null?doc["imageshare"]==null?doc["file"]==null?
           InkWell(
             onLongPress: (){
               setState(() {
                 id=doc.id;
                 appbaritemchoose=true;
               });
             },
             child: Padding(
                 padding: const EdgeInsets.all(10.0),
                 child:  Text(doc["content"],style: TextStyle(fontSize: 18),)
             ),
           ):
           // Slidable(
           //   actionPane: SlidableDrawerActionPane(),
           //   actionExtentRatio: 0.25,
           //   child: Container(
           //  //   color: Colors.white,
           //     child:
           //       InkWell(
           //         onTap: () {
           //           Get.to(PDFScreen(path: remotePDFpath));
           //           // Get.to(PDFFILESHOW(pdflink: doc['file'],));
           //           createFileOfPdfUrl(doc['file']).then((f) {
           //             setState(() {
           //               remotePDFpath = f.path;
           //             });
           //             Timer(Duration(seconds: 3), () =>
           //                 CircularProgressIndicator()
           //             );
           //
           //           });
           //         },
           //
           //       child: ListTile(
           //
           //         leading: CircleAvatar(
           //           backgroundColor: Colors.indigoAccent,
           //           child: Icon(Icons.description),
           //         //  foregroundColor: Colors.white,
           //         ),
           //         title:  Flexible(
           //           flex: 1,
           //           child: Text(doc['content'],
           //               maxLines: 1,
           //               overflow: TextOverflow.ellipsis,style: new TextStyle(
           //                 fontSize: 13.0,)),
           //         ),
           //       //  subtitle: Text('SlidableDrawerDelegate'),
           //       ),
           //     ),
           //   ),
           //   actions: <Widget>[
           //     IconSlideAction(
           //       caption: 'Archive',
           //       color: Colors.blue,
           //       icon: Icons.archive,
           //       // onTap: () => _showSnackBar('Archive'),
           //     ),
           //     IconSlideAction(
           //       caption: 'Share',
           //       color: Colors.indigo,
           //       icon: Icons.share,
           //       // onTap: () => _showSnackBar('Share'),
           //     ),
           //   ],
           //   secondaryActions: <Widget>[
           //     IconSlideAction(
           //       caption: 'More',
           //       color: Colors.black45,
           //       icon: Icons.more_horiz,
           //       // onTap: () => _showSnackBar('More'),
           //     ),
           //     IconSlideAction(
           //       caption: 'Delete',
           //       color: Colors.red,
           //       icon: Icons.delete,
           //       // onTap: () => _showSnackBar('Delete'),
           //     ),
           //   ],
           // )
           Container(
             //   color: Colors.white,
             child:
             InkWell(
               onLongPress: (){
                 setState(() {
                   id=doc.id;
                   appbaritemchoose=true;
                 });
               },
               onTap: () {
                 Get.to(PDFScreen(path: remotePDFpath));
                 // Get.to(PDFFILESHOW(pdflink: doc['file'],));
                 createFileOfPdfUrl(doc['file']).then((f) {
                   setState(() {
                     remotePDFpath = f.path;
                   });
                   Timer(Duration(seconds: 3), () =>
                       CircularProgressIndicator()
                   );

                 });
               },

               child: ListTile(

                 leading: CircleAvatar(
                   backgroundColor: Colors.indigoAccent,
                   child: Icon(Icons.description),
                   //  foregroundColor: Colors.white,
                 ),
                 title:  Flexible(
                   flex: 1,
                   child: Text(doc['content'],
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,style: new TextStyle(
                         fontSize: 13.0,)),
                 ),
                 //  subtitle: Text('SlidableDrawerDelegate'),
               ),
             ),
           )
               :
           Padding(
               padding: const EdgeInsets.all(10.0),
               child: Column(
                 children: [
                   InkWell(
                     onLongPress: (){
                       setState(() {
                         id=doc.id;
                         appbaritemchoose=true;
                       });
                     },
                     onTap: (){
                       Get.to(ImageShow(imageFile: doc['imageshare'],));
                     },
                     child: Container(
                       height: 250,
                       width: 150,
                       decoration: BoxDecoration(
                           //borderRadius: BorderRadius.circular(120),
                           image: DecorationImage(image: NetworkImage(doc["imageshare"]),fit: BoxFit.cover)
                       ),
                     ),
                   ),
                   Text(doc["content"],style: TextStyle(fontSize: 18),)
                 ],
               )
           ):
           InkWell(
               onLongPress: (){
                 setState(() {
                   id=doc.id;
                   appbaritemchoose=true;
                 });
               },
               child: AudioPlayerMessage(source: doc["audioMessage"]))
           // Container(
           //   color: Colors.black12,
           //   width: double.infinity,
           //   height: 40,
           //   child: Row(
           //     mainAxisAlignment: MainAxisAlignment.center,
           //     children: <Widget>[
           //       audiogetplay?  IconButton(
           //   icon: Icon(Icons.pause),
           //     onPressed: () {
           //       setState(() {
           //        duration=doc['audiotime'];
           //         audiogetplay=!audiogetplay;
           //         audio.pause();
           //       });
           //     }):IconButton(
           //           icon: Icon(Icons.play_arrow),
           //           onPressed: () {
           //             setState(() {
           //               audiogetplay=!audiogetplay;
           //               audio.play(doc['audioMessage']);
           //               _duration=doc['audiotime'];
           //             });
           //           }),
           //          Slider(
           //          onChanged: (double value) {
           //          setState(() {
           //          audio.seek(Duration(seconds: value.toInt()));
           //          audio.onDurationChanged.listen((Duration d) {
           //            print('Max duration: $d');
           //            setState(() => _duration = d);
           //          });
           //          });
           //          },
           //          min: 0.0,
           //          max: _duration.inSeconds.toDouble(),
           //          value:0,
           //          ),
           //       Text(doc['audiotime'])
           //     ],
           //   ),
           // )
       ),
          Text((timeago.format(doc['createdon'].toDate()).toString()),style: TextStyle(fontSize: 11)),
       SizedBox(height: 20,),
     ],
   )
       // new ListTile(
       //   tileColor: doc["msgstatus"]=="send"?Colors.white:Colors.indigo,
       //     leading: CircleAvatar(
       //       radius: 18,
       //       backgroundImage: NetworkImage(url),
       //     ),
       //   //  title: new Text(doc["content"]),
       //     subtitle:new Text(doc["content"].toString()))
   ).toList();

 }
  String remotePDFpath = "";
  Future<File> createFileOfPdfUrl(downloadurl) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = downloadurl;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
  double duration=0.0;
   Duration _duration=Duration() ;
 bool audiogetplay=false;
  var audio = AudioPlayer();

  _init() async {
    try {
      bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;
      // if (hasPermission) {
      String customPath = '/flutter_audio_recorder_';
      io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
      if (io.Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = (await getExternalStorageDirectory())!;
      }
      customPath = appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();
      _recorder = FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.WAV,);
      await _recorder!.initialized;
      // after initialization
      var current = await _recorder!.current(channel: 0);
      print(current);
      // should be "Initialized", if all working fine
      setState(() {
        _current = current;
        _currentStatus = current!.status!;
        print(_currentStatus);
      });
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: new Text("You must accept permissions")));
      // }
    } catch (e) {
      print(e);
    }
  }
  _start() async {
    try {
      await _recorder!.start();
      var recording = await _recorder!.current(channel: 0);
      setState(() {
        _current = recording;
      });
      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          // audioplay=!audioplay;
          // contentshare=!contentshare;
          t.cancel();
        }
        var current = await _recorder!.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch  (e) {
      print(e);
    }
  }
  _resume() async {
    await _recorder!.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder!.pause();
    setState(() {});
  }
  File? fileaudio;
  _stop() async {
    var result = await _recorder!.stop();
    print("Stop recording: ${result!.path}");
    print("Stop recording: ${result.duration}");
    fileaudio = widget.localFileSystem.file(result.path);
   print("File length: ${await fileaudio!.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
     // uploadAudioToStorage(fileaudio,widget.uid);
    });
  }
  Widget _buildText(RecordingStatus status) {
    var text = "";
    Icon icon;
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          return  Icon(Icons.mic,size: 35,color: Colors.deepPurpleAccent,);
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          return  Icon(Icons.pause,size: 35,color: Colors.deepPurpleAccent,);
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          return  Icon(Icons.play_arrow,size: 35,color: Colors.deepPurpleAccent,);
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
        return  Icon(Icons.cancel,size: 35,color: Colors.deepPurpleAccent,);
        audioplay=!audioplay;
        contentshare=!contentshare;
          text = 'Init';
          break;
        }
      default:
        return Icon(Icons.mic,size: 35,color: Colors.deepPurpleAccent,);
        break;
    }
      //Text(text, style: TextStyle(color: Colors.white));
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();

    await audioPlayer.play(_current!.path!, isLocal: true);
  }

}
  //  getfilefromgallery(String uid)async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     File file = File(result.files.single.path.toString());
  //     getPdfAndUpload(file,uid);
  //     print('pdf file get from gallery: $file');
  //   } else {
  //     // User canceled the picker
  //   }
  // }
  Future getPdfAndUpload(uid)async{
    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String name=file.path;
      String fileNameget = name.split('/').last;
    print('your file picker result file is $file');
    String fileName = '${randomName}.pdf';
    print('your byte file is: $fileNameget');
    FirestoreDb.updatelasttextmesage("Pdf file", uid, "pdf");
    FirestoreDb.savePdf(file, fileName,uid,fileNameget,);
    } else {
    }
  }
  sendNotification(String title, String token)async{

    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try{
      http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAA3AMN2bM:APA91bHfbsdQeySBnBJ5n8LgequXEAlhnyMZCettxgR_4uidqoP0PS34S_Z1J7HeNwGS72aDSlYd-v-r7w3TCgvc6tr-DICqdxZ6bk008nveiTGW9FHsfed5iYODMMGVsvEaINAvQFjK'
      },
          body: jsonEncode(<String,dynamic>{
            'notification': <String,dynamic> {'title': title,'body': 'You are followed by someone'},
            'priority': 'high',
            'data': data,
            'to': '$token'
          })
      );
      if(response.statusCode == 200){
        print("Yeh notificatin is sended");
      }else{
        print("Error");
      }
    }catch(e){
    }
  }
  // void senddpushMessage(String title,String token)async{
  //   final data={
  //     "click_action":'FLUTTER_NOTIFICATION_CLICK',
  //     "id":'12',
  //     "status":'done',
  //     "message":title,
  //   };
  //   try{
  //     http.Response response=await  http.post(
  //         Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         headers: <String,String>{
  //           'content-Type':'application/json',
  //           'Authorization':'key=AAAA3AMN2bM:APA91bHfbsdQeySBnBJ5n8LgequXEAlhnyMZCettxgR_4uidqoP0PS34S_Z1J7HeNwGS72aDSlYd-v-r7w3TCgvc6tr-DICqdxZ6bk008nveiTGW9FHsfed5iYODMMGVsvEaINAvQFjK'
  //         },
  //         body: jsonEncode(<String,dynamic>{
  //           'notification':<String,dynamic>
  //           {
  //            'title':title,
  //             'body':'you receive new Message'
  //           },
  //           'priority':'high',
  //           'data':data,
  //           'to':'$token'
  //         })
  //     );
  //     if(response.statusCode==200){
  //       print("yea notification is send");
  //     }
  //     else
  //     {
  //       print('error a rha h $token');
  //     }
  //   }
  //   catch(e)
  //   {
  //     print(e.toString());
  //   }
  // }
  sendNotificationToTopic(String title)async{
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };
    try{
      http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAA3AMN2bM:APA91bHfbsdQeySBnBJ5n8LgequXEAlhnyMZCettxgR_4uidqoP0PS34S_Z1J7HeNwGS72aDSlYd-v-r7w3TCgvc6tr-DICqdxZ6bk008nveiTGW9FHsfed5iYODMMGVsvEaINAvQFjK'
      },
          body: jsonEncode(<String,dynamic>{
            'notification': <String,dynamic> {'title': title,'body': 'You are followed by someone'},
            'priority': 'high',
            'data': data,
            'to': '/topics/subscription'
          })
      );
      if(response.statusCode == 200){
        print("Yeh notificatin is sended");
      }else{
        print("Error");
      }
    }catch(e){
    }
  }
