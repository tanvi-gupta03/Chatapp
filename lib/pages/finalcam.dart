import 'dart:io';

import 'package:flutter/material.dart';

class FinalCameraPage extends StatelessWidget {
  final String imagePath;

  const FinalCameraPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Image'),
      ),
      body: Center(
        child: Image.file(
          File(imagePath), // Assuming imagePath is the path to the captured image
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
