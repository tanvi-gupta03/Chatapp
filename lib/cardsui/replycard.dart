import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class replypage extends StatelessWidget{
  const replypage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width -45,
      ),
      child: Card(
        color: Colors.grey,
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10,left: 10,right: 80,bottom: 20),
              child: Text("hey"),
            ),
            SizedBox(width: 10,),
            Text("10:10"),
          ],
        ),
      ),
      ),
    );
  }

}