import 'dart:convert';
import 'dart:io';
import 'package:chitchat/components/chat_bubble.dart';
import 'package:chitchat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/get_user_info.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName,
      receiverUserEmail,
      receiverUserID,
      receiverURL,
      receiverToken;

  const ChatPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.receiverUserName,
      required this.receiverURL,
      required this.receiverToken});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ScrollController _scrollController = ScrollController();
  final Uuid uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }


  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String imageUrl = '';

      if (imageFile != null) {
        imageUrl = await uploadImage();
        imageFile = null;
      }

      await _chatService.sendMessage(
        widget.receiverUserID,
        _messageController.text,
        imageUrl,
      );
      imageUrl = '';

      sendNotification(_messageController.text, widget.receiverToken);
      _messageController.clear();
    }
  }

  //---------------------------------------
  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    var ref =
        FirebaseStorage.instance.ref().child("images").child("$fileName.jpg");
    var uploadTask = await ref.putFile(imageFile!);
    String imageUrl = await uploadTask.ref.getDownloadURL();
    print(imageUrl);
    await _chatService.sendMessage(
      widget.receiverUserID,
      _messageController.text,
      imageUrl,
    );
    imageUrl = "";
    imageFile = null;
  }

  //---------------------------------------

  sendNotification(String message, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'title': UserService.currentUser?.username,
      'body': message,
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAArjUzo-Y:APA91bGBS5WEZQjTZ70MHhlUpbngVUwQ1wFPS7KfN6RTQiqt-nRuI6SGa3s3wsoSNFl8JeQKKpC1aR1_kA4hPee45w2VEdcRQ_yO2K7Ok5mYWWABEkAp4A4kLui5zrAQUM-_410iqllc'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': UserService.currentUser?.username,
                  'body': _messageController.text
                },
                'priority': 'high',
                'data': data,
                'to': '$token'
              }));

      if (response.statusCode == 200) {
        print("notification is sent");
      } else {
        print("Error");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      widget.receiverURL,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.receiverUserName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildMessageList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    //mesaj barı
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onTertiary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autocorrect: false,
              controller: _messageController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                focusedBorder: OutlineInputBorder(
                    //text yazmaya başladığındaki hali kutunun
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                fillColor: Theme.of(context).colorScheme.onTertiary,
                filled: true,
                hintText: "Enter message",
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: getImage,
            icon: const Icon(Icons.photo, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              sendMessage();
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data["senderId"] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    var messageTime =
        DateFormat('dd/MM HH:mm').format(data["timeStamp"].toDate());

    return data["messageType"] == "text"
        ? Container(
            alignment: alignment,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
              child: Column(
                crossAxisAlignment:
                    (data["senderId"] == _firebaseAuth.currentUser!.uid)
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                mainAxisAlignment:
                    (data["senderId"] == _firebaseAuth.currentUser!.uid)
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                children: [
                  ChatBubble(
                    message: data["message"],
                    receiverId: data["receiverId"],
                    messageType: data["messageType"],
                    imageUrl: data["imageUrl"],
                    timeStamp: messageTime,
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () {
              _chatService.viewImage(context, data["imageUrl"]);
            },
            child: Container(
              alignment: alignment,
              width: 235,
              height: 235,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                child: Column(
                  crossAxisAlignment:
                      (data["senderId"] == _firebaseAuth.currentUser!.uid)
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  mainAxisAlignment:
                      (data["senderId"] == _firebaseAuth.currentUser!.uid)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  children: [
                    ChatBubble(
                      message: data["message"],
                      receiverId: data["receiverId"],
                      messageType: data["messageType"],
                      imageUrl: data["imageUrl"],
                      timeStamp: messageTime,
                    ),
                    Text(
                      messageTime,
                      style: const TextStyle(
                          fontSize: 10, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("error${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return ListView(
          reverse: true,
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }
}