import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
 // final String senderUserName;
 // final String receiverUserName;

  // buraya user namei de ekle

  Message(
      this.senderId,
      this.senderEmail,
      this.receiverId,
      this.message,
      this.timestamp,
     // this.senderUserName,
     // this.receiverUserName
      );

  //convert to a map

  Map<String, dynamic> toMap() {
    return {
      "senderEmail": senderEmail,
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "timeStamp": timestamp,
    //  "senderUserName": senderUserName,
    //  "receiverUserName": receiverUserName,
    };
  }
}
