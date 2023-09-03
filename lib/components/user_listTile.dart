import 'package:flutter/material.dart';

import '../pages/chat_page.dart';
class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.data,
    required this.context,
  });

  final Map<String, dynamic> data;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.network(
          data["photoURL"],
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data["username"]),
          Text(
            data["bio"],
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Divider()
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverUserEmail: data["email"],
              receiverUserID: data["uid"],
              receiverUserName: data["username"],
              receiverURL: data["photoURL"],
              receiverToken: data['fcmToken'],
            ),
          ),
        );
      },
    );
  }
}