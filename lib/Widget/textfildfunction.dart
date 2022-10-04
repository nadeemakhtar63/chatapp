import 'package:flutter/material.dart';

textField(emailEditingController,bool emailvalidate,
    hintText,textInputType,bool check,Icon icon)
{
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child:      Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(80),
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: 4,
            color: Color(0x3b211f1f),
            offset: Offset(2, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: TextField(
        autocorrect: true,
        obscureText: check,
        keyboardType: textInputType,
        controller: emailEditingController,
        style: TextStyle(color: Color(0xff3D4864)),
        decoration: InputDecoration(
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
            ),
            hintText: hintText,
            prefixIcon: icon,
            hintStyle: TextStyle(color: Color(0xff3D4864)),
            errorText: emailvalidate?"$hintText Required*":null
        ),

      ),
    ),
  );
}