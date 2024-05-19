import 'package:disapp/home.dart';
import 'package:flutter/material.dart';
import 'package:disapp/model/chatmodel.dart';

import 'package:disapp/cardsui/logincard.dart';

class loginscreenpage extends StatefulWidget {
  const loginscreenpage({Key? key}) : super(key: key);

  @override
  State<loginscreenpage> createState() => _loginscreenpageState();
}

class _loginscreenpageState extends State<loginscreenpage> {
  List<ChatModel> chatss = [
    ChatModel(name: "tanvi", id: 1, time: "", currentMessage: ""),
    ChatModel(name: "mummyyy", id: 2, time: "", currentMessage: "")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chatss.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            // Remove the item at the current index
            setState(() {
              chatss.removeAt(index);
            });

            // Navigate to the homescreen after updating the state
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => homescreen(chatsmodel: List.from(chatss)),
              ),
            );
          },
          child: logincardd(chatmodel: chatss[index]),
        ),
      ),
    );
  }
}

