import 'package:disapp/model/contactmodel.dart';
import 'package:disapp/pages/contact.dart';
import 'package:flutter/material.dart';

class contactcardd extends StatelessWidget{
  const contactcardd({Key? key, required this.contactmodel}) : super(key: key);
  final ContactModel contactmodel;
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
       Navigator.push(context, MaterialPageRoute(builder: (context) => contactpage() ));
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          child: Icon(Icons.person) ,
        ),
        title: Text(contactmodel.name,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
        subtitle: Text(contactmodel.bio),
      ),
    );
  }

}