import 'dart:typed_data';
import 'package:flutter/material.dart';

class OwnMessageCard extends StatelessWidget {
  final String? message;
  final Uint8List? imageData;
  final String time;

  OwnMessageCard({this.message, this.imageData, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight, // Align message to the right side
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75, // Set max width to 75% of screen
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 224, 216, 216),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message != null)
                Text(
                  message!,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              if (imageData != null)
                Image.memory(
                  imageData!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 5),
              Text(
                time,
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
