
import 'dart:convert';
import 'dart:io';
import 'package:disapp/cardsui/ownmessage.dart';
import 'package:disapp/cardsui/replycard.dart';
import 'package:disapp/model/chatmodel.dart';
import 'package:disapp/model/messagemodel.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
class IndividualPage extends StatefulWidget {
  IndividualPage({Key? key, required this.chatModel, required this.sourchat}) : super(key: key);
  final ChatModel chatModel;
  final ChatModel sourchat;

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late IO.Socket socket;
final ImagePicker _picker = ImagePicker();
html.File? _imageFile;
  String? _uploadedImageUrl;
  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    connect();
    loadMessages();  // Load messages when the page is initialized
  }
  Future<void> _pickImage() async {
  try {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) return;

      final file = files[0];
      final base64Image = await convertImageToBase64(file);

      // Use the method to send the image
      sendImageMessage(base64Image);
    });
  } catch (e) {
    print('Error picking image: $e');
  }
}

Future<String> convertImageToBase64(html.File imageFile) async {
  final reader = html.FileReader();
  reader.readAsDataUrl(imageFile); // Read the file as Data URL

  await reader.onLoadEnd.first; // Wait until the file is fully loaded

  final dataUrl = reader.result as String;

  // Extract the Base64 part of the Data URL
  if (!dataUrl.contains(',')) {
    throw Exception('Invalid Data URL format: missing comma');
  }

  return dataUrl.split(',').last; // Extract only the Base64 part
}



  void sendImageMessage(String base64Image) {
    sendMessage("IMAGE:$base64Image", widget.sourchat.id, widget.chatModel.id);
  }


  void connect() {
    socket = IO.io("http://192.168.43.116:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket.connect();

    socket.onConnect((_) {
      print("Connected to server");
      socket.emit("signin", widget.sourchat.id);
      socket.on("message", (msg) {
        print("Received message: $msg");
        setMessage("destination", msg["message"]);
      });
    });

    socket.onDisconnect((_) => print('Disconnected from server'));
    socket.onConnectError((err) => print('Connect error: $err'));
    socket.onError((err) => print('Error: $err'));
  }

  void sendMessage(String message, int sourceId, int targetId) {
    setMessage("source", message);
    print("Sending message: $message from $sourceId to $targetId");
    socket.emit("message", {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
    });
  }

  void setMessage(String type, String message) {
    MessageModel messageModel = MessageModel(
      type: type,
      message: message,
      time: DateTime.now().toString().substring(10, 16),
    );
    print("Adding message: $message of type: $type");
    setState(() {
      messages.add(messageModel);
    });
    saveMessages();  // Save messages after adding a new one
  }

  Future<void> loadMessages() async {
    final chatStorage = ChatStorage();
    List<MessageModel> savedMessages = await chatStorage.getMessages();
    setState(() {
      messages = savedMessages;
    });
  }

  Future<void> saveMessages() async {
    final chatStorage = ChatStorage();
    await chatStorage.saveMessages(messages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          leadingWidth: 70,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back, size: 24),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueGrey,
                ),
              ],
            ),
          ),
          title: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatModel.name,
                    style: TextStyle(
                      fontSize: 18.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "last seen today at 12:05",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
            IconButton(icon: Icon(Icons.call), onPressed: () {}),
            PopupMenuButton<String>(
              padding: EdgeInsets.all(0),
              onSelected: (value) {
                print(value);
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Text("View Contact"),
                    value: "View Contact",
                  ),
                  PopupMenuItem(
                    child: Text("Media, links, and docs"),
                    value: "Media, links, and docs",
                  ),
                  PopupMenuItem(
                    child: Text("Whatsapp Web"),
                    value: "Whatsapp Web",
                  ),
                  PopupMenuItem(
                    child: Text("Search"),
                    value: "Search",
                  ),
                  PopupMenuItem(
                    child: Text("Mute Notification"),
                    value: "Mute Notification",
                  ),
                  PopupMenuItem(
                    child: Text("Wallpaper"),
                    value: "Wallpaper",
                  ),
                ];
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WillPopScope(
          onWillPop: () {
            if (show) {
              setState(() {
                show = false;
              });
              return Future.value(false);
            } else {
              Navigator.pop(context);
              return Future.value(true);
            }
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return Container(height: 70);
                    }
                    if (messages[index].type == "source") {
        if (messages[index].message.startsWith("IMAGE:")) {
          String base64Image = messages[index].message.substring(6);
          Uint8List imageData = base64Decode(base64Image);
          return OwnMessageCard(
            message: null,
            imageData: imageData,
            time: messages[index].time,
          );
        } else {
          return OwnMessageCard(
            message: messages[index].message,
            time: messages[index].time,
          );
        }
      } else {
        if (messages[index].message.startsWith("IMAGE:")) {
    String base64Image = messages[index].message.substring(6);
    Uint8List imageData = base64Decode(base64Image);
    return ReplyCard(
      message: null,
      imageData: imageData,
      time: messages[index].time,
    );
  } else {
    return ReplyCard(
      message: messages[index].message,
      time: messages[index].time,
    );
  }
      }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 60,
                            child: Card(
                              margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextFormField(
                                controller: _controller,
                                focusNode: focusNode,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
                                onChanged: (value) {
                                  setState(() {
                                    sendButton = value.isNotEmpty;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                      show ? Icons.keyboard : Icons.emoji_emotions_outlined,
                                    ),
                                    onPressed: () {
                                      if (!show) {
                                        focusNode.unfocus();
                                        focusNode.canRequestFocus = false;
                                      }
                                      setState(() {
                                        show = !show;
                                      });
                                    },
                                  ),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.attach_file),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (builder) => bottomSheet(),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.camera_alt),
                                        onPressed: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (builder) =>
                                          //             CameraApp()));
                                        },
                                      ),
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFF128C7E),
                              child: IconButton(
                                icon: Icon(
                                  sendButton ? Icons.send : Icons.mic,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (sendButton) {
                                    _scrollController.animateTo(
                                      _scrollController.position.maxScrollExtent,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                    sendMessage(
                                      _controller.text,
                                      widget.sourchat.id,
                                      widget.chatModel.id,
                                    );
                                    _controller.clear();
                                    setState(() {
                                      sendButton = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      show
                          ? SizedBox(
                              height: 256,
                              child: EmojiPicker(
                                onEmojiSelected: (category, emoji) {
                                  setState(() {
                                    _controller.text += emoji.emoji;
                                  });
                                },
                                config: Config(
                                  
                                ),
                              ),
                            )
                          : Container(),
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

  Widget bottomSheet() {
    return Container(
      height: 120,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.attach_file),
              ),
              TextButton(
                onPressed: (){

                },
                child: Text("Document")),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.camera_alt),
              ),
              TextButton(
                onPressed: (){},
                child: Text("Camera")),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.image),
              ),
              TextButton(
                onPressed: _pickImage,
                child: Text("Gallery")),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatStorage {
  Future<void> saveMessages(List<MessageModel> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encodedMessages = messages.map((msg) => jsonEncode(msg.toJson())).toList();
    await prefs.setStringList('messages', encodedMessages);
  }

  Future<List<MessageModel>> getMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encodedMessages = prefs.getStringList('messages');
    if (encodedMessages == null) {
      return [];
    }
    return encodedMessages.map((msg) => MessageModel.fromJson(jsonDecode(msg))).toList();
  }
}
