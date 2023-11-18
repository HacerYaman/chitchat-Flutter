import 'package:chitchat/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //SENDING MESSAGE
  Future<void> sendMessage(
      String receiverId,
      String message,
      String imageUrl,
      ) async {
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

    List<String> participants = [currentUserId, receiverId];
    participants.sort();
    String chatRoomId = participants.join("_");

    await _firebaseFirestore.collection("chat_rooms").doc(chatRoomId).set({
      'participants': participants,
    }, SetOptions(merge: true)).then((_) {
      return _firebaseFirestore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages")
          .add(newMessage.toMap());
    }).catchError((error) {
      print("Error sending message: $error");
    });
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
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }

  Future<List<String>> getRecentChats() async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final QuerySnapshot snapshot = await _firebaseFirestore
        .collection("chat_rooms")
        .where("participants", arrayContains: currentUserId)
        .get();

    List<String> recentChats = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      List<dynamic> participants = doc.get("participants");
      participants.remove(currentUserId);
      String otherUserId = participants[0];

      recentChats.add(otherUserId);
    }
    return recentChats;
  }

  viewImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(8),
            minScale: 0.5,
            maxScale: 3.0,
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }
}