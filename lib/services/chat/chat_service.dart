import 'package:chitchat/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //SENDING MESSAGE
  Future<void> sendMessage(String receiverId, String message, String imageUrl) async {
    //get user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    final String messageType = imageUrl.isEmpty ? "text" : "image";

    Message newMessage = Message(
      currentUserId,
      currentUserEmail,
      receiverId,
      message,
      timestamp,
      messageType,
      imageUrl,
    );

    //construct chat room id from current userid and receiver id
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //ensures the chat room id is alwatys the same for any pair of  users
    String chatRoomId = ids.join(
        "_"); //combine the ids into a single strinog to use as a chatroom id
    // add new message to db
    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //GETTİNG MESSAGES

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }

  viewImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }
}
