import 'package:disapp/model/chatmodel.dart';
import 'package:disapp/pages/indi.dart';
import 'package:flutter/material.dart';

class customcardd extends StatefulWidget {
  const customcardd({Key? key, required this.chatmodel}) : super(key: key);
  final ChatModel chatmodel;

  @override
  State<customcardd> createState() => _customcarddState();
}

class _customcarddState extends State<customcardd> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => individualpage(chatmodel: widget.chatmodel, sourcechat: widget.chatmodel)
        ));
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          child: Icon(Icons.person) ,
        ),
        title: Text(
          widget.chatmodel.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.done_all) ,
            Text(widget.chatmodel.currentMessage),
          ],
        ),
        trailing: Text(widget.chatmodel.time),
      ),
    );
  }
}
