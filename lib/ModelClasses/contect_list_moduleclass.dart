import 'package:cloud_firestore/cloud_firestore.dart';

class ContectModel {
 late String username;
  late String imagelink;
  late String statues;
  // late bool isDone;

  ContectModel({
    required this.username,
    required this.imagelink,
    required this.statues
//     required this.createdOn,
  });

  ContectModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    username = documentSnapshot["username"];
    imagelink = documentSnapshot["url"];
    statues = documentSnapshot["statues"];
  }
}