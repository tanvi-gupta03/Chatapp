import 'package:disapp/cardsui/ownmessage.dart';
import 'package:disapp/cardsui/replycard.dart';
import 'package:disapp/model/chatmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:socket_io_client/socket_io_client.dart' as IO;
class individualpage extends StatefulWidget {
  const individualpage({Key? key, required this.chatmodel,required this.sourcechat}) : super(key: key);

  final ChatModel chatmodel;
  final ChatModel sourcechat;
  @override
  State<individualpage> createState() => _individualpageState();
}

class _individualpageState extends State<individualpage> {
 TextEditingController _controller= TextEditingController();
 bool show = false;
 bool showattachment = false;
 late IO.Socket socket;
 bool send=false;
 Widget emojiselctor(){
  return EmojiPicker(
    onEmojiSelected: (emoji,category){
      if (emoji != null) {
    print(emoji);
    setState(() {
      _controller.text = _controller.text + emoji.name;
    });
  }
    },
  );
}
attachmentcard(){
  return Container(
            height: MediaQuery.of(context).size.height/3,
            width: MediaQuery.of(context).size.width/3,
            child: Card(
            child: Column(
            children: [
            Row(
            children: [
           Column(
        children: [
        Icon(Icons.file_copy),
            Text('Documents')
                         ],
                           ),
                    Column(
               children: [
                     Icon(Icons.camera_alt),
                                 Text('Camera')
                            ],
                                     ),
                                   Column(
                            children: [
                           Icon(Icons.photo),
                            Text('Gallery')
                                  ],
                              ),
                               ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
  children: [
             Column(
          children: [
          Icon(Icons.headphones),
  Text('Audio')
               ],
                 ),
          Column(
     children: [
           Icon(Icons.location_pin),
                       Text('Location')
                  ],
                           ),
                         Column(
                  children: [
                 Icon(Icons.contact_emergency),
                  Text('Contacts')
                        ],
                    ),
                     ],
                        ),
                             ],
                          ),
                              ),
                                        );
}
void connect() {
    socket = IO.io('http://192.168.43.116:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to server');
      socket.emit('signin', widget.chatmodel.id);
    });

    socket.onConnectError((data) {
      print('Connect error: $data');
    });

    socket.onError((data) {
      print('Error: $data');
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    socket.onAny((event, data) {
      print('Event received: $event, data: $data');
    });

    Future.delayed(Duration(seconds: 2), () {
      print('Socket connected status: ${socket.connected}');
    });
  }
  void sendmessage(String message,int sourceid,int targetid){
      socket.emit("message",{"message":message,"sourceid":sourceid,"targetid":targetid});
  }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            CircleAvatar(
              radius: 15,
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatmodel.name,style: TextStyle(fontSize: 20),),
            Text(widget.chatmodel.time,style: TextStyle(fontSize: 10,fontWeight: FontWeight.w100),),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.phone),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.video_call),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside the text field
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height -140,
                child: ListView(
                  children: [
                    ownmessagepage(),
                    replypage(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                          
                              margin: EdgeInsets.only(left: 2,right: 2,bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: TextFormField(
                                onChanged: (value){
                                  if(value.length >0){
                                    setState(() {
                                      send=true;
                                    });
                                  }
                                  else{
                                    setState(() {
                                      send=false;
                                    });
                                  }
                                },
                            cursorColor: Colors.blue, 
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.text,
                                controller: _controller,
                                decoration: InputDecoration(
                                  
                                  prefixIcon: IconButton(onPressed: (){
                                    setState(() {
                                      show = !show;
                                    });
                                  }, 
                                  icon: Icon(Icons.emoji_emotions_rounded),),
                                  hintText: 'Type your message',
                      border: InputBorder.none,
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(onPressed: (){
                                       setState(() {
                                         showattachment = ! showattachment;
                                       });
                                      }, icon: Icon(Icons.attachment_sharp),),
                                      SizedBox(width: 20),
                                      Icon(Icons.camera_alt),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if(send){
                                sendmessage(_controller.text,widget.chatmodel.id, widget.sourcechat.id);
                              }
                            },
                            icon: send ? Icon(Icons.send):Icon(Icons.mic_rounded),
                          ),
                        ],
                      ),
                      show ? emojiselctor() : Container(),
                      showattachment? attachmentcard() : Container()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}