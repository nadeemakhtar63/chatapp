import 'dart:io';
import 'package:chatapp/Widget/custombotton.dart';
import 'package:chatapp/Widget/textfileds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/firebase_auth_constant.dart';
import '../firebaseCud/firebasedatabase.dart';
class Profile extends StatefulWidget {
 // const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
  /// Get from camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
    File? imageFile;
  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { },
    );

    // set up the AlertDialog
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

TextEditingController namecontroller=TextEditingController();
  TextEditingController statusCotroller=TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
              children: [
          Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: firebaseFirestore.collection('user').where('uid',isEqualTo: auth.currentUser!.uid).snapshots() ,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return new Text("No record found");
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: new ListView
                (
                //controller: _controller,
                children: getExpenseItems(snapshot),
              ),
            );
          }),
    ),

    ]
    )
    )
    );
  }
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return  snapshot.data!.docs.map((doc) =>
      Container(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Container(
              height: MediaQuery.of(context).size.height*0.2,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                  children: [
                   imageFile==null?
                   Container(
                       height: 120,
                       width: 120,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(90),
                         color: Colors.teal,
                         image: DecorationImage(image: NetworkImage(doc['url']),fit: BoxFit.cover)
                       )):Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.teal,
                  image: DecorationImage(image: FileImage(imageFile!),fit: BoxFit.cover)
              ),
              //child:  Image.file(imageFile!,fit: BoxFit.cover,),
            ),
                 //        :Container(
                 //   height: 120,
                 //   width: 120,
                 //   decoration: BoxDecoration(
                 //       borderRadius: BorderRadius.circular(90),
                 //     color: Colors.teal,
                 //     image: DecorationImage(image: NetworkImage(doc['url']),fit: BoxFit.cover)
                 //   ),
                 //  //child:  Image.file(imageFile!,fit: BoxFit.cover,),
                 // ),
                    new Positioned(
                        bottom: 10,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                              color: Colors.black12,
                              blurRadius: 3.0, // soften the shadow
                              spreadRadius: 3.0, //extend the shadow
                              // offset: Offset(
                              //   15.0, // Move to right 10  horizontally
                              //   15.0, // Move to bottom 10 Vertically
                              // ),
                              )// Move to bottom 10 Vertically
                            ],
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: IconButton(
                          onPressed: (){
                            showAlertDialog(context);
                          },
                          icon: Icon(Icons.add)),
                        ))
                  ],
                ),
              ),
            Container(
              height: MediaQuery.of(context).size.height*0.4,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                    CustomTextField(
                        helperText: "username",
                      controller: namecontroller,
                        hint: doc['username']==null?"username":doc['username']),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomTextField(
                      helperText: "statues",
                      controller: statusCotroller,
                        hint: doc['statues']==null?"statues":doc['statues']),
                  ),
                ],
              )
            ),
         Container(
           height: MediaQuery.of(context).size.height*0.2,
           width: double.infinity,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomButton(onTap: (){
            if(namecontroller.text.isNotEmpty && statusCotroller.text.isNotEmpty && imageFile!=null)
              {
            FirestoreDb.updateProfile(imageFile,namecontroller.text.toString(),statusCotroller.text.toString());

                 // Get.snackbar("Response", res);
            Get.snackbar("Response", "Profile Update Sucessfully");
              }
            else if(imageFile==null)
              {
                String name= namecontroller.text.toString()==''?doc['username']:namecontroller.text.toString();
                String str=statusCotroller.text.toString()==''?doc['statues']:statusCotroller.text.toString();
                // File? file=imageFile==null?doc['url']:imageFile;
                FirestoreDb.updateProfilepreviouseimage(
                    doc['url'],
                name,
                str);
                Get.snackbar("Response", "Profile Update Sucessfully");
              }
            else{
              String name= namecontroller.text.toString()==''?doc['username']:namecontroller.text.toString();
              String str=statusCotroller.text.toString()==''?doc['statues']:statusCotroller.text.toString();
              FirestoreDb.updateProfile(
                  imageFile==null?File(doc['url']):imageFile,
              name,
              str);
              Get.snackbar("Response", "Profile Update Sucessfully");
            }
            }, symbol: "Update"),
          ),
             Padding(
               padding: const EdgeInsets.all(10.0),
               child: CustomButton(onTap: (){
                 Navigator.pop(context);
               }, symbol: "Cancel"),
             ),
           ],
           )
           )
          ],
        ),
      ),
    ).toList();;
  }
}
