import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../ModelClasses/mesg_module.dart';
import '../constant/firebase_auth_constant.dart';
import '../firebaseCud/firebasedatabase.dart';
class ImageShare extends StatefulWidget {
  final File? imageFile;
  final String uid;
  final String idkey;
  const ImageShare({Key? key,required this.imageFile,required this.uid,required this.idkey}) : super(key: key);
  @override
  _ImageShareState createState() => _ImageShareState();
}
class _ImageShareState extends State<ImageShare> {
  initState()
  {
    super.initState();
    print('image file recived ${widget.imageFile}');
    print("next user id is ${widget.uid}");
  }
  TextEditingController contentTextEditorController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.lightBlueAccent,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  //  borderRadius: BorderRadius.circular(120),
                    color: Colors.teal,
                    image: DecorationImage(image: FileImage(widget.imageFile!,),fit: BoxFit.cover)
                ),
                //child:  Image.file(imageFile!,fit: BoxFit.cover,),
              ),
            ),
            TextField(
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                  hintText: "Text here..",
 
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: ()async{
                          final todoModel = TodoModel(
                              content: contentTextEditorController.text.trim(),
                              isDone: false,
                              uid: widget.uid
                          );
                          FirestoreDb.updatelasttextmesage("Image Share", widget.uid, "img");
                          await widget.idkey=="msg"? FirestoreDb.addImageData(todoModel,widget.imageFile!,widget.uid):
                          FirestoreDb.addStatuesImageData(todoModel,widget.imageFile!,widget.uid);

                          await FirestoreDb.updatelasttextmesage(contentTextEditorController.text.trim(),widget.uid,"img");
                          contentTextEditorController.clear();
                          Navigator.pop(context);
                        }, icon: Icon(Icons.send,size: 35,)),
                  ) ,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
             controller: contentTextEditorController,
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
