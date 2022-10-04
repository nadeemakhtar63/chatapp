
// This is a Custom TextField Widget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  // In the Constructor onChanged and hint fields are added.
  const CustomTextField({ Key? key,required this.helperText,  required this.hint,required this.controller}) : super(key: key);

  // It requires the onChanged Function
  // and the hint to be Shown
 final TextEditingController controller;
  final String hint;
  final String helperText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: Color(0x3b211f1f),
            offset: Offset(0, 0.1),
            blurRadius: 1,
          ),
        ],
      ),
      child:TextField(
          controller: controller,
        // onChanged Function is used here.
       // onChanged: onChanged,
        style: TextStyle(color: Color(0xff3D4864)),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),

            // hint String is used here.

            helperText: helperText,
            hintText: hint,
            fillColor: Color(0xFFFFFFFF),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: new BorderSide(color: Color(0xff3D4864))
            ),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:  BorderSide(color: Color(0xff3D4864), width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:  BorderSide(color: Color(0xff3D4864), width: 0.0),
            )

      ),
    ),
    );
  }
}