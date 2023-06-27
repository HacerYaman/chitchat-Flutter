import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final String receiverId;
  const ChatBubble({
    super.key,
    required this.message,
    required this.receiverId,
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
          color: Colors.blue,
        ),
        child: Column(
          children: [
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        //GÖNDERİLEN MESAJ
        padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
        ),
        child: Column(
          children: [
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
  }
}
