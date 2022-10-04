import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? documentId;
  late String content;
  late Timestamp createdOn;
  late bool isDone;
  late String uid;

  TodoModel({
    required this.uid,
    required this.content,
    required this.isDone,
//     required this.createdOn,
  });

  TodoModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
      documentId = documentSnapshot.id;
      content = (documentSnapshot.data() as dynamic)["content"];
      createdOn = (documentSnapshot.data() as dynamic)["createdOn"];
      isDone = (documentSnapshot.data() as dynamic)["isDone"];
      uid = (documentSnapshot.data() as dynamic)["uid"];
    }
  }
