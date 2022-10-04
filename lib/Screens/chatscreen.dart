import 'dart:ffi';

import 'package:chatapp/Screens/contect_list.dart';
import 'package:chatapp/constant/firebase_auth_constant.dart';
import 'package:chatapp/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mesges_screen.dart';
class HomeScreen extends StatefulWidget {
  final String? token;
  const HomeScreen({Key? key,required this.token}) : super(key: key);
  @override
  State<HomeScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<HomeScreen> {
 // getUserIDData()async {
 //    List<String> growableList = [];
 //    List<String> userAnswerList = [];
 //    String adminQuestion = "What is the reason of life?";
 //    FirebaseFirestore.instance.collection("user").get().then((snapshot) async {
 //      snapshot.docs.forEach((element) {
 //        growableList.add(element.id);
 //      });
 //      for (int i = 0; i < growableList.length; i++) {
 //        DocumentSnapshot snap=(await FirebaseFirestore.instance.collection("user").doc(growableList[i])
 //            .collection("profile").doc().get());
 //         //   .where("adminQuestion", isEqualTo: adminQuestion)
 //
 //        userAnswerList.add(snap['email']);
 //        //     .then((snapshot) {
 //        //   snapshot.docs.forEach((lement) {
 //        //     String email;
 //        //
 //        //     email=lement['email'];
 //        //     userAnswerList.add(lement.data()['email']);
 //        //
 //        //     print("emails is ${email}");
 //        //   });
 //        // });
 //        print(i);
 //      }
 //    });
 //    return userAnswerList;
 //  }
  String  userid='';
  @override
  void initState() {
    super.initState();
    Fiberchat.internetLookUp();
 //   getlastmessage();
  }
  // String uid="";
  // getlastmessage()async{
  //   var collection = FirebaseFirestore.instance.collection('Messages').doc();
  //   var docSnapshot = await collection.doc('doc_id').get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     var value = data?['some_field']; // <-- The value you want to retrieve.
  //     // Call setState if needed.
  //   }
  // }
  CollectionReference collectionReference=firebaseFirestore.collection('Messages');
  List<String> messages=[];
  List<String> growableList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(ContectList(token:widget.token));
            // Add your onPressed code here!
          },
          child: Icon(Icons.email),
          backgroundColor: Colors.green,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("user").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.none)
                return new CircularProgressIndicator();
              else if (!snapshot.hasData ||snapshot.hasError)
                  return new CircularProgressIndicator();
                  final a=snapshot.data!.docs;
                  for(var i in a)
                  {
                   print('value print${i['uid']}');
                    growableList.add(i['uid']);
                    print(growableList);
                    storlistinshared(growableList);
                    }
    // if (snapshot.hasData) {
    // var output = snapshot.data!.docs;
    // for(var i in output){
    // firebaseFirestore.collection('Messages').doc(auth.currentUser!.uid).
    //       collection(((auth.currentUser!.uid)+i['uid'])).get().then((value){
    //         var res=value.docs.last;
    //         var val=res.data();
    //         print(val['content']);
    //         // for(var j in res)
    //         //   {
    //         //
    //         //  print(j['content']);
    //         //   }
    //
    //
    // //   StreamBuilder<QuerySnapshot>(
    // //       stream: firebaseFirestore.collection('Messages').doc(auth.currentUser!.uid).
    // //       collection(((auth.currentUser!.uid)+i['uid'])).orderBy('createdon', descending: false).snapshots() ,
    // //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // //         if (!snapshot.hasData) return new Text("There is No User");
    // //         var vale;
    // //         var outputs = snapshot.data!.docs;
    // //          vale = outputs[0];
    // //         print(vale['content']);
    // // return Text(vale['content']);
    //   // collectionReference.doc(auth.currentUser!.uid).
    //   //  collection(((auth.currentUser!.uid)+i['uid'])).get().then((values){
    //   //    if(values.h)
    //   //    var field=values.data();
    //   //    print(field);
    //    });
    //       }
    // };
    //  snapshot.data!.docs.map((e) =>
               // collectionReference.doc(auth.currentUser!.uid).
               //  collection(((auth.currentUser!.uid)+e['content'])).doc('content').get().then((value){
               //    var field=value.data();
               //    print(field);
                return ListView
                  (
                  reverse: false,
                    children: getExpenseItems(snapshot)
                  );
              }
              )
    );
  }
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((doc) =>
      doc['uid']==null?Container():  InkWell(
          onTap: ()async{
            var devicestate,statuestime;
            var collection = FirebaseFirestore.instance.collection('Devicestatues');
            var docSnapshot = await collection.doc(doc['uid']).get();
            if (docSnapshot.exists) {
              Map<String, dynamic>? data = docSnapshot.data();
              setState(() {
                devicestate = data?['statues'];
                statuestime = data?['time'] == null ? 0 : data?['time'];
              });
              print('device statues: $statuestime');
              print('device statues: $devicestate');
            }
            Get.to(ChatScreen(token:widget.token,uname: doc["username"],
              statues: doc["statues"], url: doc["url"],uid:doc["uid"],
              statuestime: statuestime,devicestate: devicestate,));

          },
          child:doc["uid"]==auth.currentUser!.uid?Container():
    Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width/2,
            child: ListTile(
                leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(doc["url"],),),
                title: new Text(doc["username"]),
              //  subtitle:    doc["lastmesg"]=="null"?Container(): Text(doc["lastmesg"].toString(),style: TextStyle(fontSize:11,color: Colors.black,fontWeight: FontWeight.bold  ),)

                ),
          ),
          Text(doc["statues"].toString(),style: TextStyle(fontSize: 9),),

        ],
      ),
    )
          // ListTile(
          //     leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(doc["url"],),),
          //     title: new Text(doc["username"]),
          //     subtitle: Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         new Text(doc["statues"].toString(),style: TextStyle(fontSize: 9),),
          //         doc["lastmessage"]=="null"?Container(): Text(doc["lastmessage"].toString(),style: TextStyle(fontSize:11,color: Colors.black,fontWeight: FontWeight.bold  ),)
          //       ],
          //     )),
        )
    )
        .toList();
  }

  void storlistinshared(List<String> growableList)async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("uids", growableList);
    sharedPreferences.commit();

  }
}