import 'package:disapp/cardsui/contactcard.dart';
import 'package:disapp/model/contactmodel.dart';
import 'package:flutter/material.dart';

class contactpage extends StatefulWidget{
  const contactpage({Key? key}) : super(key: key);
  

  @override
  State<contactpage> createState() => _contactpageState();
}

class _contactpageState extends State<contactpage> {
  List<ContactModel> contacts=[
    ContactModel(name: 'Tanvi', bio: 'Hey there i am using whatsapp',id: 1),
    ContactModel(name: 'mummyyy', bio: 'Hey there i am using whatsapp',id: 2)
  ];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 134, 235, 18),
        elevation: 5,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Text("Select Contacts"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          PopupMenuButton(itemBuilder: (BuildContext context){
            return [
              PopupMenuItem(child: Text("New Group"),value: "new group",),
              PopupMenuItem(child: Text("New Broadcast"),value: "new broadcast",),
              PopupMenuItem(child: Text("Whatsapp Web"),value: "whatsapp web",),
              PopupMenuItem(child: Text("Settings"),value: "settings",),
            ];
          })
        ],
    ),
    body: ListView.builder(
        itemCount: contacts.length,
       itemBuilder: (context, index) {
         return contactcardd(contactmodel: contacts[index],);
       },
      )
    );
  }
}