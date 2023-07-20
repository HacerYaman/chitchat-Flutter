import 'package:chitchat/main.dart';
import 'package:chitchat/pages/recent_chats_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> handleBackgroundMessage (RemoteMessage message) async{
  print("title: ${message.notification?.title}");
  print("body: ${message.notification?.body}");
  print("playload: ${message..data}");

  navigatorKey.currentState?.push(MaterialPageRoute(
    builder: (context) => RecentChatsPage(), // Navigate to HomePage
  ));

}

void handleMessage(RemoteMessage? message){
  if(message==null) return;

  navigatorKey.currentState?.push(MaterialPageRoute(
    builder: (context) => RecentChatsPage(), // Navigate to HomePage
  ));
}

Future initPushNotifications() async{
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage((message) => handleBackgroundMessage(message)); // Değişiklik burada

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

}

class FirebaseApi{
  final _firebaseMessaging= FirebaseMessaging.instance;

  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();
    final fCMToken= await _firebaseMessaging.getToken();
    print("token:$fCMToken"); //reg token
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage); // Değişiklik burada

   // initPushNotifications();
  }

}