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
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.asset(
          "lib/assets/default.png",
          width: 30,
          height: 30,
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
            ),
          ),
        );
      },
    );
  }
}