import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:chatapp/ModelClasses/contect_list_moduleclass.dart';
import 'package:chatapp/ModelClasses/mesg_module.dart';
import 'package:chatapp/constant/firebase_auth_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_core/src/get_main.dart';
class FirestoreDb {
  //message send
  static addTodo(TodoModel todomodel,String uid) async {

    //save messaage on send account
    await firebaseFirestore.collection('Messages').
    doc(auth.currentUser!.uid).
    collection((auth.currentUser!.uid+uid))
        .add({
      'content': todomodel.content,
      'createdon': Timestamp.now(),
      'isDone': false,
      'file':null,
      'msgstatus':"send",
      'imageshare':null,
      'audioMessage':null,
      'audiotime':null
    });
    //save message on reciver account
    await firebaseFirestore
        .collection('Messages')
        .doc(uid)
        .collection((uid+auth.currentUser!.uid))
        .add({
      'content': todomodel.content,
      'createdon': Timestamp.now(),
      'isDone': false,
      'file':null,
      'msgstatus':"recive",
      'imageshare':null,
      'audioMessage':null,
      'audiotime':null
    });
  }

  static savePdf(asset, String name,String uid,filenameget) async {

    final ref = FirebaseStorage.instance.ref(name);
    await ref.putFile(asset);
    String url = await ref.getDownloadURL();
    print("image url is =$url");
    // documentFileUpload(url,uid);
    // return  url;
    //save messaage on send account
    await firebaseFirestore.collection('Messages').
    doc(auth.currentUser!.uid).
    collection((auth.currentUser!.uid+uid))
        .add({
      'content': filenameget,
      'createdon': Timestamp.now(),
      'isDone': false,
      'file':url,
      'msgstatus':"send",
      'imageshare':null,
      'audioMessage':null,
      'audiotime':null
    });
    //save message on reciver account
    await firebaseFirestore
        .collection('Messages')
        .doc(uid)
        .collection((uid+auth.currentUser!.uid))
        .add({
      'content': filenameget,
      'createdon': Timestamp.now(),
      'isDone': false,
      'file':url,
      'msgstatus':"recive",
      'imageshare':null,
      'audioMessage':null,
      'audiotime':null
    });
  }
  //online offline statues check
  static devicestatues( bool value)async{
    await firebaseFirestore
        .collection('Devicestatues')
        .doc((auth.currentUser!.uid))
        .set({
      'statues':value,
      'time':Timestamp.now(),
    });
  }
  //text statues
  static addStatuesTextData(TodoModel c,String uid,String colorselect) async {
    var name;
    var collection = FirebaseFirestore.instance.collection('user');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      name = data?['username'];
      print('name show statues: $name');
    }
    QuerySnapshot _myDoc = await firebaseFirestore.collection('statues').doc(auth.currentUser!.uid).
    collection('collectionPath').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print(_myDocCount.length);
    await firebaseFirestore.collection('statues').
    doc(auth.currentUser!.uid).collection('collectionPath')
        .add({
      'NoOfStatues':_myDoc.size,
      'content': c.content,
      'createdon': Timestamp.now(),
      'views': "0",
      'msgstatus': "send",
      'imageshare': null,
      'name': name,
      'colorchoose':colorselect,
      'audiotime': null
    });
    //save message on reciver account
  }
  //statues
  static addStatuesImageData(TodoModel c,File? imageshare,String uid) async {
    var name;
    var collection = FirebaseFirestore.instance.collection('user');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      name = data?['username'];
      print('name show statues: $name');
    }
    //save messaage on send account
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    final ref = FirebaseStorage.instance.ref(randomName);
    await ref.putFile(imageshare!);
    String url = await ref.getDownloadURL();
    QuerySnapshot _myDoc = await firebaseFirestore.collection('statues').doc(auth.currentUser!.uid).
    collection('collectionPath').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print(_myDocCount.length);
    await firebaseFirestore.collection('statues').
    doc(auth.currentUser!.uid).collection('collectionPath')
        .add({
      'NoOfStatues':_myDoc.size,
      'content': c.content,
      'createdon': Timestamp.now(),
      'views': 0,
      'msgstatus': "send",
      'imageshare': url,
      'colorchoose':null,
      'name': name,
      'audiotime': null
    });
    //save message on reciver account
  }
  //send image
  static addImageData(TodoModel c,File? imageshare,String uid) async {
    //save messaage on send account
    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    final ref = FirebaseStorage.instance.ref(randomName);

    await ref.putFile(imageshare!);
    String url = await ref.getDownloadURL();
    await firebaseFirestore.collection('Messages').
    doc(auth.currentUser!.uid).
    collection((auth.currentUser!.uid+uid))
        .add({
      'content': c.content,
      'createdon': Timestamp.now(),
      'isDone': false,
      'file':null,
      'msgstatus':"send",
      'imageshare':url,
      'audioMessage':null,
      'audiotime':null
    });
    //save message on reciver account
    await firebaseFirestore
        .collection('Messages')
        .doc(uid)
        .collection((uid+auth.currentUser!.uid))
        .add({
      'content':c.content,
      'createdon': Timestamp.now(),
      'isDone': false,
      'file':null,
      'msgstatus':"recive",
      'imageshare':url,
      'audioMessage':null,
      'audiotime':null
    });
  }
  static uploadAudioToStorage(File audioFile,String uid,duration) async {
    try {

      final ref = FirebaseStorage.instance.ref().child('chatAudios/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(audioFile,);
      String url = await ref.getDownloadURL();
      await firebaseFirestore.collection('Messages')
          .doc(auth.currentUser!.uid).collection((auth.currentUser!.uid+uid))
          .add({
        'content': null,
        'createdon': Timestamp.now(),
        'isDone': false,
        'file':null,
        'msgstatus':"send",
        'imageshare':null,
        'audioMessage':url,
        'audiotime':duration
      });
      //save message on reciver account
      await firebaseFirestore
          .collection('Messages')
          .doc(uid)
          .collection((uid+auth.currentUser!.uid))
          .add({
        'content': null,
        'createdon': Timestamp.now(),
        'isDone': false,
        'file':null,
        'msgstatus':"recive",
        'imageshare':null,
        'audioMessage':url,
        'audiotime':duration
      });


      print("url:$url");
      return  url;

    } catch (error) {
      print("error$error");
      return error;
    }

  }
  static Stream<List<ContectModel>> contectStream() {
    return firebaseFirestore
        .collection('user')
        .snapshots()
        .map((QuerySnapshot query) {
      List<ContectModel> contects = [];
      for (var todo in query.docs) {
        final contectModel =
        ContectModel.fromDocumentSnapshot(documentSnapshot: todo);
        contects.add(contectModel);
      }
      return contects;
    });
  }

  static Stream<List<TodoModel>> todoStream() {
    return firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('todos')
        .snapshots()
        .map((QuerySnapshot query) {
      List<TodoModel> todos = [];
      for (var todo in query.docs) {
        final todoModel = TodoModel.fromDocumentSnapshot(documentSnapshot: todo);
        todos.add(todoModel);
      }
      return todos;
    });
  }
  static updatelasttextmesage(String mesg,uid,key)async
  {
    try {
      // var rng = new Random();
      // String randomName = "";
      // for (var i = 0; i < 20; i++) {
      //   print(rng.nextInt(100));
      //   randomName += rng.nextInt(100).toString();
      // }
      // final ref = FirebaseStorage.instance.ref(randomName);
      //
      // await ref.putFile(imageshare!);
      // String url = await ref.getDownloadURL();
      final response=  firebaseFirestore
          .collection('user')
          .doc(uid)
          .update(
        {
          if(key=="audio")
            'lastmesg': mesg
          else if(key=="img")
            'lastmesg': mesg
          else if(key=="videocall")
              'lastmesg': mesg
            else if(key=="pdf")
                'lastmesg': mesg
              else
                'lastmesg': mesg
        });
          final response2=  firebaseFirestore
          .collection('user')
          .doc(auth.currentUser!.uid)
          .update(
            {
              if(key=="audio")
                'lastmesg': mesg
              else if(key=="img")
                'lastmesg': mesg
              else if(key=="videocall")
                  'lastmesg': mesg
                else if(key=="pdf")
                    'lastmesg': mesg
                  else
                    'lastmesg': mesg
            },
      );
      return response;
    }
    catch(error)
    {
      print("error$error");
      return error;
    }


  }
  static updateProfile(imageshare,String usernaem,String statues)async {
  try {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    final ref = FirebaseStorage.instance.ref(randomName);

    await ref.putFile(imageshare!);
    String url = await ref.getDownloadURL();
  final response=  firebaseFirestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .update(
      {
        'statues': statues,
        'username': usernaem,
        'url': url,
      },
    );
  return response;
   }

  catch(error)
    {
      print("error$error");
      return error;
    }
  }

  static updateProfilepreviouseimage(imageshare,String usernaem,String statues)async {
    try {

      final response=  firebaseFirestore
          .collection('user')
          .doc(auth.currentUser!.uid)
          .update(
        {
          'statues': statues,
          'username': usernaem,
          'url': imageshare,
        },

      );
      return response;
    }
    catch(error)
    {
      print("error$error");
      return error;
    }

  }
  static updateStatus(bool isDone, documentId) {
    firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('todos')
        .doc(documentId)
        .update(
      {
        'isDone': isDone,
      },
    );
  }
  static deleteTodo(String documentId,String uid )async {
   var responseed=await firebaseFirestore.collection('Messages')
       .doc(auth.currentUser!.uid)
       .collection((auth.currentUser!.uid+uid))

       .doc(documentId)
        .delete();
   return responseed;
  }
  static deletereciversenderTodo(String documentId,String uid )async {
    await firebaseFirestore.collection('Messages')
        .doc(auth.currentUser!.uid)
        .collection((auth.currentUser!.uid+uid))
        .doc(documentId)
        .delete();

    await  firebaseFirestore.collection('Messages')
        .doc(uid)
        .collection((uid+auth.currentUser!.uid)).doc(documentId).delete();
  }
}