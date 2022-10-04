import 'dart:io';
import 'package:chatapp/Screens/VideoPlayerApp.dart';
import 'package:chatapp/statues/components/TextStatus/textStatus.dart';
import 'package:chatapp/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/constant/firebase_auth_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import '../Screens/imageshare.dart';
import '../constant/Dbkeys.dart';
import 'FullScreenStatues.dart';
import 'components/circleBorder.dart';
class Statues_Screeb extends StatefulWidget {
  const Statues_Screeb({Key? key}) : super(key: key);
  @override
  _Statues_ScreebState createState() => _Statues_ScreebState();
}
class _Statues_ScreebState extends State<Statues_Screeb> {
  PickedFile? pickedFile;
  File? imageFile;
  DateFormat df = new DateFormat('yyyy-MM-dd HH:mm:ss');
  dynamic data;
   var firebasequry;
  List<String> growableList = [];
  List<String> userisList = [];
  String adminQuestion = "What is the reason of life?";
   getListData() async {
     SharedPreferences myPrefs = await SharedPreferences.getInstance();
     userisList = myPrefs.getStringList("uids")!;
     // for (var vl in userisList) {
     //   print('value of shared pref: $vl');
     //   for (int i = 0; i < growableList.length; i++) {
     //     firebaseFirestore.collection("statues").doc(vl).collection(
     //         "collectionPath")
     //         .then((snapshot) {
     //       snapshot.docs.map
     //         ((e) => print(e['name']));
     //     });
     //     //print(i);
     //     // }
     //   }
     // }
   }
void initState()
{
  getListData();
  super.initState();
  getImage();
  Fiberchat.internetLookUp();

}
  _getFromGallery() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    ) ;
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile!.path);
      });
      if(imageFile!=null)
      {
        Get.to(ImageShare(imageFile: imageFile,uid: auth.currentUser!.uid,idkey: "statues",));
      }
    }
  }
  //statues video upload
  _getVideo() async {
  var  imageFiles = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: Duration(minutes: 1),
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = (File(imageFiles!.path));
      });
      if(imageFile!=null)
      {
      //  Get.to(videoplay(imageFile: imageFile,uid: auth.currentUser!.uid,idkey: "statues",));
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
        Get.to(ImageShare(imageFile: imageFile,uid: auth.currentUser!.uid,idkey: "statues",));
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
  var imageshare;
  void getImage()async{
    var collection = FirebaseFirestore.instance.collection('user');
    var docSnapshot = await collection.doc(auth.currentUser!.uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      imageshare = data?['url'];
      print('name show statues: $imageshare');
    }
  }
  final StoryController controller = StoryController();
  int _counter=0;
  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Colors.teal,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(Icons.note_add),
            backgroundColor: Colors.teal,
            onTap: ()
            {
              Get.to(TextStatus(currentuserNo: auth.currentUser!.uid,));
            },
            label: 'Text',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.teal),
        SpeedDialChild(
            child: Icon(Icons.add_chart),
            backgroundColor: Colors.teal,
            onTap: () {
              _getFromGallery(); },
            label: 'Gallery',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.teal),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.teal,
            onTap: () {

               _getFromCamera();
              setState(() {
                _counter = 0;
              });
            },
            label: 'Camera',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.teal)
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
  return  Scaffold(
        floatingActionButton:
        FloatingActionButton(
          onPressed: () {
            //_getFAB();
            //showAlertDialog(context);
           // Get.to(ContectList(token:widget.token));
            // Add your onPressed code here!
          },
          child: _getFAB()
          // Icon(Icons.camera),
          // backgroundColor: Colors.green,
        ),
        body:
        Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:  FirebaseFirestore.instance.collection("statues").doc(auth.currentUser!.uid)
                      .collection('collectionPath').orderBy('createdon', descending: false).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
                if (!snapshots.hasData || snapshots.hasError)
                  return new Text("${snapshots.error}" );
                print(snapshots.data!.docs.length,);
                switch (snapshots.connectionState) {
                  case ConnectionState.waiting:
                    return new Text("Loading...");
                  default:
                    print(snapshots.data!.docs.length,);

                  //  final docs = snapshot.data!.docs;
                    return Column(
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              // Container(
                              //   height: MediaQuery.of(context).size.height * 0.1,
                              //   // decoration: const BoxDecoration(
                              //   //     color: Colors.indigo,
                              //   //     boxShadow: [BoxShadow(
                              //   //         color: Colors.black12,
                              //   //         offset: Offset(2, 1),
                              //   //         blurRadius: 2,
                              //   //         spreadRadius: 2
                              //   //     )
                              //   //     ]
                              //   // ),
                              //   width: double.infinity,
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(5.0),
                              //     child: Stack(
                              //         children: [
                              //           Row(
                              //             children: [
                              //               Container(
                              //                   height: 70,
                              //                   width: 70,
                              //                   decoration: BoxDecoration(
                              //                     borderRadius: BorderRadius.circular(70),
                              //                     // image: DecorationImage(
                              //                     //     image:NetworkImage("https://firebasestorage.googleapis.com/v0/b/chatingapp-54fe0.appspot.com/o/1140738849793282775660422760194261171?alt=media&token=3eafaf5e-07e8-4ebe-910b-fe87750fb63e")
                              //                     //     ,fit: BoxFit.cover)
                              //                   ),
                              //                   child: ListView.builder(
                              //                       itemCount: snapshot.data!.docs
                              //                           .length,
                              //                       itemBuilder: (context, item) {
                              //                         print(
                              //                             "url of statues${snapshot
                              //                                 .data!
                              //                                 .docs[item]['imageshare']}");
                              //                         return Container(
                              //                           height: 70,
                              //                           width: 70,
                              //                           decoration: BoxDecoration(
                              //                               borderRadius: BorderRadius
                              //                                   .circular(70),
                              //                               image: DecorationImage(
                              //                                   image: NetworkImage(
                              //                                     snapshot.data!
                              //                                         .docs[item]['imageshare'],)
                              //                                   , fit: BoxFit.cover)
                              //                           ),
                              //                         );
                              //                         // return  CircleAvatar(
                              //                         //   child: ClipRect(
                              //                         //       child: Align(
                              //                         //       alignment: Alignment.topCenter,
                              //                         //       heightFactor: 0.6,
                              //                         //       child: Image.network(snapshot.data!.docs[item]['imageshare'],fit: BoxFit.cover,),
                              //                         //       ),
                              //                         //       ),
                              //                         // );
                              //                       }
                              //                   )
                              //                 //   return Image(image: NetworkImage(index['imageshare']);
                              //                 //  },
                              //               ),
                              //               // CircleAvatar(
                              //               //   radius: 50,
                              //               //   backgroundImage:NetworkImage("https://firebasestorage.googleapis.com/v0/b/chatingapp-54fe0.appspot.com/o/1140738849793282775660422760194261171?alt=media&token=3eafaf5e-07e8-4ebe-910b-fe87750fb63e") ,
                              //               // ),
                              //               SizedBox(width: 20,),
                              //               Column(
                              //                 mainAxisAlignment: MainAxisAlignment
                              //                     .center,
                              //                 crossAxisAlignment: CrossAxisAlignment
                              //                     .center,
                              //                 children: [
                              //                   Text("My Statues", style: TextStyle(
                              //                       fontSize: 18,
                              //                       fontWeight: FontWeight.w900),),
                              //                   Text("My Statues", style: TextStyle(
                              //                       fontSize: 14,
                              //                       fontWeight: FontWeight.w400),),
                              //                 ],
                              //               )
                              //             ],
                              //           ),
                              //           new Positioned(
                              //             // right: -5,
                              //               left: 40,
                              //               bottom: 2,
                              //               child: Container(
                              //                 alignment: Alignment.center,
                              //                 height: 35,
                              //                 width: 35,
                              //                 decoration: BoxDecoration(
                              //                     boxShadow: [
                              //                       BoxShadow(
                              //                         color: Colors.black12,
                              //                         blurRadius: 3.0,
                              //                         // soften the shadow
                              //                         spreadRadius: 3.0, //extend the shadow
                              //                         // offset: Offset(
                              //                         //   15.0, // Move to right 10  horizontally
                              //                         //   15.0, // Move to bottom 10 Vertically
                              //                         // ),
                              //                       )
                              //                       // Move to bottom 10 Vertically
                              //                     ],
                              //                     color: Colors.teal,
                              //                     borderRadius: BorderRadius
                              //                         .circular(20)
                              //                 ),
                              //                 child: Align(
                              //                   alignment: Alignment.center,
                              //                   child: IconButton(
                              //                       onPressed: () {
                              //                         showAlertDialog(context);
                              //                       },
                              //                       icon: Icon(Icons.add)),
                              //                 ),
                              //               )),
                              //         ]
                              //     ),
                              //   ),
                              // )
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height:70,
                                  child:
                          //         ListView.builder(
                          // itemCount: snapshots.data!.docs.length,
                          // itemBuilder: (context, item) {
                          //       var img=snapshots.data!.docs[item]['imageshare'];
                          //
                          //   print("url of statues${snapshots.data!.docs[0]['imageshare']}");
                          //   return
                          snapshots.data!.docs.length==0?Container(
                           child: Row(
                              children: [
                                CircularBorder(
                                  color: snapshots.data!.docs.length > 0 ? Colors.teal.withOpacity(0.8) : Colors.grey.withOpacity(0.8) ,
                                  width: 3,
                                  icon:Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius
                                            .circular(70),
                                        image: DecorationImage(
                                            image: NetworkImage(imageshare)
                                            , fit: BoxFit.cover)
                                    ),
                                  ),
                                  totalitems: 1,
                                  totalseen: 1,
                                ),
                                SizedBox(width: 10,),

                                Text("statues"),

                              ],
                              //  );
                              // }
                            ),
                          ):snapshots.data!.docs[0]['imageshare']==null?
                Row(
                children: [
                InkWell(
                onTap: (){
                Get.to(FullScreenStatues(statusitems:snapshots.data!.docs[0]['content'],
                uids: auth.currentUser!.uid,statusimgpic: 'txt',
                  clr: snapshots.data!.docs[0]['colorchoose'],
                img: imageshare,
                ));
                },
                child: CircularBorder(
                color: snapshots.data!.docs.length > 0 ? Colors.teal.withOpacity(0.8) : Colors.grey.withOpacity(0.8) ,
                width: 3,
                icon:Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                borderRadius: BorderRadius
                    .circular(60),
                color:Color(int.parse(snapshots.data!.docs[0]['colorchoose'],radix: 16))
                // image: DecorationImage(
                // image: NetworkImage(
                // snapshots.data!.docs[0]['imageshare'],)
                // , fit: BoxFit.cover)
                ),
                  child: Center(
                    child: Text(snapshots.data!.docs[0]['content'], style: TextStyle(fontSize: 9),),
                  ),
                ),
                totalitems: snapshots.data!.docs.length,
                totalseen: 1,
                ),
                ),
                SizedBox(width: 10,),
                Text("statues"),
                ],
                //  );
                // }
                )
                              :Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    Get.to(FullScreenStatues(statusitems:snapshots.data!.docs[0]['imageshare'],
                                    uids: auth.currentUser!.uid,
                                    img: imageshare,
                                    ));
                                  },
                                  child: CircularBorder(
                                    color: snapshots.data!.docs.length > 0 ? Colors.teal.withOpacity(0.8) : Colors.grey.withOpacity(0.8) ,
                                    width: 3,
                                    icon:Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                            borderRadius: BorderRadius
                                            .circular(70),
                                            image: DecorationImage(
                                            image: NetworkImage(
                                              snapshots.data!.docs[0]['imageshare'],)
                                             , fit: BoxFit.cover)
                                                 ),
                                                              ),
                                    totalitems: snapshots.data!.docs.length,
                                    totalseen: 1,
                                  ),
                                ),
                                SizedBox(width: 10,),

                                Text("statues"),

                              ],
                          //  );
                         // }
                          ),
                                ),
                              ),
                              new Positioned(
                                // right: -5,
                                  left: 10,
                                  bottom: 2,
                                  child: Container(
                                   // alignment: Alignment.center,
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 3.0,
                                            // soften the shadow
                                            spreadRadius: 3.0, //extend the shadow
                                            // offset: Offset(
                                            //   15.0, // Move to right 10  horizontally
                                            //   15.0, // Move to bottom 10 Vertically
                                            // ),
                                          )
                                          // Move to bottom 10 Vertically
                                        ],
                                        color: Colors.teal,
                                        borderRadius: BorderRadius
                                            .circular(20)
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                          onPressed: () {
                                            showAlertDialog(context);
                                          },
                                          icon: Icon(Icons.add)),
                                    ),
                                  )),
                            ],
                          ),

                        ),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12)
                            ),
                            height: 20,
                            width: double.infinity,
                            child: Text("Recent updates"),
                          ),
                        ),

                      ],
                    );
                }
              }
            ),
            for(var i in userisList)
              if(auth.currentUser!.uid!=i)
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.
                      collection("statues").doc(i).collection('collectionPath')
                          .orderBy('createdon', descending: false).limitToLast(1).snapshots(),
                      builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData )
                          return const Text("There is No statues");
                        else {
                          return new ListView(
                              reverse: false,
                              children: getExpenseItems(snapshot,i)
                          );
                        }
                      }),
                )
          ],
        )
        );
  }
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot,String ids) {
     return snapshot.data!.docs.map((doc) =>
     doc['imageshare']!=null ||doc['content']==null?
             Column(
               children: [
                 InkWell(
                   onTap: (){
                      Get.to(FullScreenStatues(statusitems: doc["imageshare"],uids: ids
                      ,img: imageshare,
                      ));
                    },
                   child:
                   ListTile(
                       leading:   CircularBorder(
                         color: snapshot.data!.docs.length > 0 ?
                         Colors.teal.withOpacity(0.8) : Colors.grey.withOpacity(0.8) ,
                         width: 3,
                         icon:Container(
                           height: 60,
                           width: 60,
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius
                                   .circular(70),
                               image: DecorationImage(
                                   image: NetworkImage(doc["imageshare"])
                                   , fit: BoxFit.cover)
                           ),
                         ),
                         totalitems: snapshot.data!.docs.length,
                         totalseen: doc["NoOfStatues"],
                       ),
                       //CircleAvatar(radius: 18, backgroundImage: NetworkImage(doc["imageshare"],),),
                       title: new Text(doc["name"]),
                       subtitle: new Text((timeago.format(doc['createdon'].toDate()).toString()),style: TextStyle(fontSize: 11))),
                 ),
               ],
             ):Container(),
         )
         .toList();
  }
}