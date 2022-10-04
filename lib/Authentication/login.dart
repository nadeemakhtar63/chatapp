import 'dart:io';
import 'package:chatapp/Widget/custombotton.dart';
import 'package:chatapp/Widget/textfildfunction.dart';
import 'package:chatapp/Widget/textfileds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';
import '../Controller/authcontroller.dart';
import '../constant/firebase_auth_constant.dart';
class Login extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Login> {
  TextEditingController nameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool namevalidate=false,psswordvalidate=false;
  @override
  void initState() {
    Get.put(AuthController());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Container(
                height: MediaQuery.of(context).size.height*0.08,
                decoration: BoxDecoration(
                  color:Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: (){
                    if((nameController.text.isEmpty)||(passwordController.text.isEmpty)) {
                      setState(() {
                        nameController.text.isEmpty?namevalidate=true:namevalidate=false;
                        passwordController.text.isEmpty?psswordvalidate=true:psswordvalidate=false;

                      });

                    }
                    else
                    {
                      authController.login(
                          nameController.text.trim(),
                          passwordController.text.trim(),
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
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Text("Thanks for Joing our team please enter email and password that provide by the admin staff... ",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color: Colors.deepPurple),
              ),
            )
          ],
        ),
      ),
    );
  }
}
