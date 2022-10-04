import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ImageShow extends StatefulWidget {
  final String imageFile;
  const ImageShow({Key? key,required this.imageFile}) : super(key: key);

  @override
  _ImageShowState createState() => _ImageShowState();
}

class _ImageShowState extends State<ImageShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          width: double.infinity,

          decoration: BoxDecoration(
             // borderRadius: BorderRadius.circular(120),
              image: DecorationImage(image: NetworkImage(widget.imageFile),fit: BoxFit.cover)
          ),
        ),
      ),
    );
  }
}
