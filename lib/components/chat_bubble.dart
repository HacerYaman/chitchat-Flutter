import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String timeStamp;
  final String message;
  final String receiverId;
  final String messageType;
  final String imageUrl;

  const ChatBubble({
    super.key,
    required this.message,
    required this.receiverId,
    required this.messageType,
    required this.imageUrl,
    required this.timeStamp,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_firebaseAuth.currentUser!.uid == widget.receiverId) {
      return Container(   //GELEN MESAJ
        padding: EdgeInsets.only(left: 10,right: 10,top:8, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Visibility(
              visible: widget.messageType == "image" ? false : true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.timeStamp,
                    style: TextStyle(
                        fontSize: 8,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.messageType=="image"? true :false,
              child: Image.network(
                widget.imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        //GÖNDERİLEN MESAJ
        padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber.shade300,
        ),
        child: Column(
          children: [
            Visibility(
              visible: widget.messageType == "image" ? false : true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    widget.timeStamp,
                    style: TextStyle(
                        fontSize: 8,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.messageType=="image"? true :false,
              child: Image.network(
                widget.imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      );
    }
  }
}