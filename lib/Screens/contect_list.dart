import 'package:chatapp/Controller/authcontroller.dart';
import 'package:chatapp/Screens/mesges_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/firebase_auth_constant.dart';
class ContectList extends StatelessWidget {
  final String? token;
  const ContectList({Key? key,required this.token}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("user").snapshots(),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
          {
            if (!snapshot.hasData) return new Text("There is No User");
            return new ListView(
                children: getExpenseItems(snapshot)
            );
          }
      )
    );
  }
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((doc) =>
    InkWell(
      onTap: (){
        Get.to(ChatScreen(token:token,uname: doc["username"], statues: doc["statues"], url: doc["url"],uid:doc["uid"]));
      },
      child: new ListTile(
          leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(doc["url"],),),
          title: new Text(doc["username"]),
          subtitle: new Text(doc["statues"].toString())),
    )
    ).toList();
  }
}
