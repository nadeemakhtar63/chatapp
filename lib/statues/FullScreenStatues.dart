import 'package:chatapp/constant/firebase_auth_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
class FullScreenStatues extends StatefulWidget {
  final  statusitems;
  final  statusimgpic;
  final uids;
  final clr;
  final img;
  FullScreenStatues({Key? key, required this.statusitems, this.uids,this.statusimgpic,this.clr, this.img}):super(key: key);
  @override
  State<FullScreenStatues> createState() => _FullScreenStatuesState();
}
class _FullScreenStatuesState extends State<FullScreenStatues> {
  final StoryController controller = StoryController();
  List<StoryItem?> statusitemslist = [];
 var documentsid;
 var totalview;
 int updateviews=0;
 void viewsget()async {
   await FirebaseFirestore.instance.collection("statues").doc(auth.currentUser!.uid)
       .collection('views').get().then((value) {
     value.docs.forEach((element) {
       documentsid= element.id;
       print('how many views:${element}');
     });
   });
 }
 void getimages()async{
   await FirebaseFirestore.instance.collection("statues").doc(widget.uids)
       .collection('collectionPath').get().then((value) {
         value.docs.forEach((element) {
       documentsid= element.id;
       print('value value:${element.id}');
       updateviews=element.data()['views'];
      // updateviews=int.parse(totalview);
       element.data()['imageshare']==null?statusitemslist.add(
           StoryItem.text(title: element.data()['content'],
               backgroundColor: Color(int.parse(element.data()['colorchoose'],radix: 16)))
       ) :statusitemslist.add(
           StoryItem.inlineImage(
               url: element.data()['imageshare'],
               controller: controller,
               duration: Duration(seconds: 7)
           )
       );
       print('image urls ${element.id}');
     }
     );
   }
     );
   }
  void initState() {
    super.initState();
    getimages();
    viewsget();
 widget.statusimgpic=='txt'?statusitemslist.add(
   StoryItem.text(title: widget.statusitems,
       backgroundColor: Color(int.parse(widget.clr,radix: 16)))
 ) :  statusitemslist.add(
        StoryItem.inlineImage(
            url: widget.statusitems,
            controller: controller,
            duration: Duration(seconds: 7)
        )
    );
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
                   // margin: EdgeInsets.all(8,),
                    child: Stack(
                      children:[ StoryView(
                          storyItems: statusitemslist,
                          onComplete: () {
                            if(widget.uids!=auth.currentUser!.uid) {
                              FirebaseFirestore.instance.collection("statues")
                                  .doc(widget.uids)
                                  .collection('collectionPath').doc(documentsid)
                                  .update({'views': updateviews + 1});

                              FirebaseFirestore.instance.collection("statues")
                                  .doc(widget.uids)
                                  .collection('views')
                                  .add({'userview': auth.currentUser!.uid});
                            }
                            // if (widget.currentUserNo == widget.statusDoc[Dbkeys.statusPUBLISHERPHONE]) {
                              Navigator.maybePop(context);
                            //} else {
                             // Navigator.maybePop(context);
                            //  widget.callback!(widget.statusDoc[Dbkeys.statusPUBLISHERPHONE]);
                           // }
                          },
                          progressPosition: ProgressPosition.top,
                          repeat: false,
                          controller: controller),
                        Positioned(
                          top: 5,
                          child: Container(
                            height: 140,
                            width: MediaQuery.of(context).size.width,
                            decoration: new BoxDecoration(
                              gradient: new LinearGradient(
                              begin: Alignment.topCenter,
                               end: Alignment.bottomCenter,
                              colors: <Color>[
                               Colors.black.withOpacity(0.5),
                                Colors.transparent
                              ],
                              ),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: (){Navigator.pop(context);},
                                    child: Icon(Icons.arrow_back,color: Colors.white,)),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius
                                          .circular(50),
                                      image: DecorationImage(
                                          image: NetworkImage(widget.img)
                                          , fit: BoxFit.cover)
                                  ),
                                ),
                              ],),
                          ),
                        ),
                        Positioned(
                         bottom: -40,
                          child: Container(
                            height: 140,
                            width: MediaQuery.of(context).size.width,
                            decoration: new BoxDecoration(
                             // gradient: new LinearGradient(
                               // begin: Alignment.topCenter,
                              //  end: Alignment.bottomCenter,
                               // colors: <Color>[
                                //  Colors.black.withOpacity(0.5),
                               //   Colors.transparent
                               // ],
                              //),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              Icon(Icons.remove_red_eye_outlined),
                                Text(updateviews.toString())
                            ],),
                          ),
                        ),

        ]
        )
    //                 ListView(
    //                     children: [
    //                        Container(
    //                         height: MediaQuery
    //                             .of(context)
    //                             .size
    //                             .height,
    //                         child: StoryView(
    //                           controller: controller,
    //                           storyItems: [
    //                             StoryItem.text(
    //                               title:
    //                               "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
    //                               backgroundColor: Colors.orange,
    //                               roundedTop: true,
    //                             ),
    //
    //                            ]
    //
    //                             // StoryItem.inlineImage(
    //                             //   NetworkImage(
    //                             //       "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
    //                             //   caption: Text(
    //                             //     "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
    //                             //     style: TextStyle(
    //                             //       color: Colors.white,
    //                             //       backgroundColor: Colors.black54,
    //                             //       fontSize: 17,
    //                             //     ),
    //                             //   ),
    //                             // ),
    //                         //     StoryItem.inlineImage(
    //                         //       url:statusitemslist,
    //                         //      controller: controller,
    //                         //       caption: Text(
    //                         //         "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
    //                         //         style: TextStyle(
    //                         //           color: Colors.white,
    //                         //           backgroundColor: Colors.black54,
    //                         //           fontSize: 17,
    //                         //         ),
    //                         //       ),
    //                         //     ),
    //                         //     StoryItem.inlineImage(
    //                         //       url:
    //                         //       "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
    //                         //       controller: controller,
    //                         //       caption: Text(
    //                         //         "Hektas, sektas and skatad",
    //                         //         style: TextStyle(
    //                         //           color: Colors.white,
    //                         //           backgroundColor: Colors.black54,
    //                         //           fontSize: 17,
    //                         //         ),
    //                         //       ),
    //                         //     )
    //                         //   ],
    //                         //   onStoryShow: (s) {
    //                         //     print("Showing a story");
    //                         //   },
    //                         //   onComplete: () {
    //                         //     print("Completed a cycle");
    //                         //   },
    //                         //   progressPosition: ProgressPosition.bottom,
    //                         //   repeat: false,
    //                         //   inline: true,
    //                         // ),
    //                       )
    // ]
    //                 ),
                    // Material(
                    //   child: InkWell(
                    //     onTap: () {
                    //       // Navigator.of(context).push(
                    //       //     MaterialPageRoute(builder: (context) => MoreStories()));
                    //     },
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //           color: Colors.black54,
                    //           borderRadius:
                    //           BorderRadius.vertical(bottom: Radius.circular(8))),
                    //       padding: EdgeInsets.symmetric(vertical: 8),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           Icon(
                    //             Icons.arrow_forward,
                    //             color: Colors.white,
                    //           ),
                    //           SizedBox(
                    //             width: 16,
                    //           ),
                    //           Text(
                    //             "View more stories",
                    //             style: TextStyle(fontSize: 16, color: Colors.white),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
  )
                  );
  }
}