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
  late ChatModel sourcechat;
  List<ChatModel> chatss = [
    ChatModel(
      name: "Tanvi", id: 1, time: "", currentMessage: "",isGroup: false, 
      status: "", icon: ""
      ),
    ChatModel(name: "chatapp", id: 2, time: "", currentMessage: "", isGroup: false, 
      status: "", icon: "")
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
               sourcechat =chatss.removeAt(index);
            });

            // Navigate to the homescreen after updating the state
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => homescreen(chatsmodel: List.from(chatss), sourchat: sourcechat,),
              ),
            );
          },
          child: ButtonCard(name: chatss[index].name, icon: Icons.person),
        ),
      ),
    );
  }
}

