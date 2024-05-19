import 'package:disapp/cardsui/customcard.dart';
import 'package:disapp/model/chatmodel.dart';
import 'package:disapp/pages/contact.dart';
import 'package:flutter/material.dart';

class chatpage extends StatefulWidget {
  const chatpage({Key? key, required this.chatmodel}) : super(key: key);
  final List<ChatModel> chatmodel;

  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => contactpage()));
        },
        child: Icon(Icons.chat),
      ),
      body: ListView.builder(
        itemCount: widget.chatmodel.length,
        itemBuilder: (context, index) {
          return customcardd(chatmodel: widget.chatmodel[index]);
        },
      ),
    );
  }
}
