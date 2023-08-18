import 'dart:io';
import 'package:chitchat/components/chat_bubble.dart';
import 'package:chitchat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName, receiverUserEmail, receiverUserID, receiverURL;


  const ChatPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.receiverUserName, required this.receiverURL});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Uuid uuid = Uuid();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String imageUrl = '';

      if (imageFile != null) {
        imageUrl = await uploadImage();
        imageFile = null; // Resim dosyasını sıfırla
      }

      await _chatService.sendMessage(
        widget.receiverUserID,
        _messageController.text,
        imageUrl,
      );

      _messageController.clear();
      imageUrl = ''; // URL'yi sıfırla
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
    // Future<String> uploadImage() async {
    String fileName = Uuid().v1();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
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
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.receiverUserName,
                    style: TextStyle(
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
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                focusedBorder: OutlineInputBorder(
                    //text yazmaya başladığındaki hali kutunun
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter message",
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: getImage,
            icon: Icon(Icons.photo),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.arrow_forward_ios),
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
                  ),
                  Text(
                    messageTime,
                    style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
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
                    ),
                    Text(
                      messageTime,
                      style:
                          TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
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
          return CircularProgressIndicator();
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }
}
