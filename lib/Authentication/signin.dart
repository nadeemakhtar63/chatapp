import 'dart:io';

import 'package:chatapp/Authentication/login.dart';
import 'package:chatapp/Widget/custombotton.dart';
import 'package:chatapp/Widget/textfildfunction.dart';
import 'package:chatapp/Widget/textfileds.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../Controller/authcontroller.dart';
import '../constant/firebase_auth_constant.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController=TextEditingController();
  TextEditingController usernameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController statues=TextEditingController();
  bool namevalidate=false,psswordvalidate=false,usernamevalidate=false,statuesvalidate=false;
  File? imageFile;
  PickedFile? pickedFile;
 // final ImagePicker _picker = ImagePicker();
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
        imageFile = File(pickedFile!.path);
      });
    }
  }
  //File? imageFile;
  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { },
    );

   // setup the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Media"),
      actions: [
        IconButton(onPressed: (){
          _getFromCamera();
        }, icon: Icon(Icons.camera_alt)),
        IconButton(onPressed: (){
          _getFromGallery();
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
  @override
  void initState() {
    Get.put(AuthController());
    super.initState();
  }
// Image picker
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    title: new Text('Gallery'),
                    onTap: () => {
                     _getFromGallery(),
                      Navigator.pop(context),
                    }),
                new ListTile(
                  title: new Text('Camera'),
                  onTap: () => {
                    _getFromCamera(),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.only(top: 20.0),
           child: Container(
             child: Column(
               // mainAxisAlignment: MainAxisAlignment.center,
               // crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Container(
                   height: MediaQuery.of(context).size.height*0.2,
                   width: double.infinity,
                   child: Stack(
                     alignment: Alignment.center,
                     children: [
                       imageFile==null? Container(
                         height: 120,
                         width: 120,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(120),

                         ),
                         child:  Icon(Icons.person_pin,size: 120,),
                       ):Container(
                         height: 120,
                         width: 120,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(120),
                             color: Colors.teal,
                             image: DecorationImage(image: FileImage(imageFile!,),fit: BoxFit.cover)
                         ),
                         //child:  Image.file(imageFile!,fit: BoxFit.cover,),
                       ),
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
                                   _settingModalBottomSheet(context);
                                   //  showAlertDialog(context);
                                 },
                                 icon: Icon(Icons.camera_alt)),
                           ))
                     ],
                   ),
                 ),
                 SizedBox(height: 20,),
                 Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: TextFormField(
                     minLines: 3,
                     maxLength: 35,
                     // any number you need (It works as the rows for the textarea)
                     keyboardType: TextInputType.multiline,
                     maxLines: null,
                     controller: statues,
                     decoration: const InputDecoration(
                       prefixIcon: Icon(Icons.message_outlined, color: Colors.blue,

                         ),
                       fillColor: Colors.blue,
                       focusColor: Colors.blue,
                       hoverColor: Colors.blue,
                       labelText: 'Position',
                    //   errorText: statuesvalidate.i?"Job Title Required*":null,
                       hintStyle:
                       TextStyle(color: Colors.black54, fontSize: 12),
                       labelStyle:
                       TextStyle(color: Colors.blue, fontSize: 16),
                       disabledBorder: OutlineInputBorder(
                           borderSide:
                           BorderSide(color: Colors.blue)),
                       enabledBorder: OutlineInputBorder(
                           borderSide:
                           BorderSide(color: Colors.blue)),
                       focusedBorder: OutlineInputBorder(
                           borderSide:
                           BorderSide(color: Colors.blue)),
                       border: OutlineInputBorder(
                           borderSide:
                           BorderSide(color: Colors.blue)),
                       // hintText: label,
                     ),
                   ),
                 ),
                 textField(
                     usernameController,
                     usernamevalidate,
                     "Username",
                     TextInputType.text,
                     false,
                     Icon(Icons.person)),
                 SizedBox(height: 20,),
                 textField(
                     nameController,
                     namevalidate,
                     "Enter email",
                     TextInputType.text,
                     false,
                     Icon(Icons.email)),
                 SizedBox(height: 20,),
                 textField(
                     passwordController,
                     psswordvalidate,
                     "Enter password",
                     TextInputType.visiblePassword,
                     true,
                     Icon(Icons.lock)),
                 SizedBox(height: 20,),
                 // CustomButton(
                 //     onTap: (){
                 //      if(nameController.text.isEmpty && passwordController.text.isEmpty)
                 //        {
                 //          Get.snackbar("name and password can't be empty",'',snackPosition: SnackPosition.BOTTOM);
                 //        }
                 //      else
                 //        {
                 //          Get.snackbar("sucess",'',snackPosition: SnackPosition.BOTTOM);
                 //
                 //        }
                 //     },
                 //     symbol: "SiginUp")
                 SizedBox(height: 10,),
                 InkWell(
                   onTap: (){
                   //  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Navebar()));
                   },
                   child: Padding(
                     padding: const EdgeInsets.only(left: 10,right: 10),
                     child: Container(
                       height: MediaQuery.of(context).size.height*0.08,
                       decoration: BoxDecoration(
                         color:Colors.deepPurple,
                         borderRadius: BorderRadius.circular(10),
                       ),
                       child: InkWell(
                         onTap: (){
                           if((nameController.text.isEmpty)||(passwordController.text.isEmpty)||(usernameController.text.isEmpty)) {
                            // String datetime="";
                             setState(() {
                               usernameController.text.isEmpty?usernamevalidate=true:usernamevalidate=false;
                               nameController.text.isEmpty?namevalidate=true:namevalidate=false;
                               passwordController.text.isEmpty?psswordvalidate=true:psswordvalidate=false;

                             });

                           }
                           else if(imageFile.isNull){
                             Get.snackbar("Please Select Image", '',snackPosition: SnackPosition.BOTTOM);
                           }
                           else
                           {
                             setState(() {
                               statues.text.isEmpty?statuesvalidate=true:statuesvalidate=false;
                             });
                             authController.register(
                                 nameController.text.trim(),
                                 passwordController.text.trim(),
                                imageFile,
                               pickedFile.toString(),
                               usernameController.text.trim(),
                               statues.text.trim(),
                               statuesvalidate
                             );
                             // print("Value con't be empty");
                             // Get.snackbar("Value con't be empty", '',snackPosition: SnackPosition.BOTTOM);
                           }
                         },
                         child: Center(
                           child: Text("LogIn".tr,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),),
                         ),
                       ),
                     ),
                   ),
                 ),
                 SizedBox(height: 10,),
                 InkWell(
                     onTap: (){
                       Get.to(Login());
                     },
                     child: const Text("Login to Existing Account")),
                 SizedBox(height: 10,),
                 Padding(
                   padding: const EdgeInsets.only(left: 10,right: 10),
                   child: Text("Thanks for Joing our team please enter email and password that provide by the admin staff... ",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color: Colors.deepPurple),
                   ),
                 )
               ],
             ),
           ),
         ),
       ),
    );
  }
}
