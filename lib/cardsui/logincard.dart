import 'package:disapp/home.dart';
import 'package:disapp/model/chatmodel.dart';
import 'package:disapp/pages/indi.dart';
import 'package:flutter/material.dart';

class logincardd extends StatelessWidget{
  const logincardd({Key? key, required this.chatmodel}) : super(key: key);
  final ChatModel chatmodel;
  @override
  Widget build(BuildContext context){
    List<ChatModel> chatss=[
    ChatModel(name: "tanvi",
     id: 1,
     
     time: "10:10", 
     currentMessage: "helloo", 
      
     ),
     ChatModel(name: "mummyyy",
     
     id: 2,
     time: "10:10", 
     currentMessage: "helloo", 
      
     )
  ];
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => homescreen(chatsmodel: chatss) ));
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
        ),
        title: Text(chatmodel.name,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
        subtitle: Text(chatmodel.currentMessage),
        trailing: Text(chatmodel.time),
      ),
    );
  }

}