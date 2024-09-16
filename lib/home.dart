import 'package:flutter/material.dart';
import 'package:disapp/model/chatmodel.dart';
import 'package:disapp/pages/call.dart';
import 'package:disapp/pages/camerap.dart';
import 'package:disapp/pages/chat.dart';
import 'package:disapp/pages/status.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key, required this.chatsmodel, required this.sourchat}) : super(key: key);
  final List<ChatModel> chatsmodel;
  final ChatModel sourchat;
  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 134, 235, 18),
        elevation: 5,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.home)),
        title: Text("WeChat"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(child: Text("New Group"), value: "new group"),
              PopupMenuItem(child: Text("New Broadcast"), value: "new broadcast"),
              PopupMenuItem(child: Text("Whatsapp Web"), value: "whatsapp web"),
              PopupMenuItem(child: Text("Settings"), value: "settings"),
            ];
          })
        ],
        bottom: TabBar(
          controller: _controller,
          tabs: [
            Tab(icon: Icon(Icons.camera_alt),text: 'Camera',),
            Tab(text: 'Chats',
            icon: Icon(Icons.message) ,
            ),
            Tab(text: 'Status',icon: Icon(Icons.camera) ,),
            Tab(text: 'Calls',icon: Icon(Icons.phone) ,),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          camerapage(),
          chatpage(
            chatmodels: widget.chatsmodel,
            sourchat: widget.sourchat,
          ),
          statuspage(),
          callpage(),
        ],
      ),
    );
  }
}

