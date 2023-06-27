import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
class ProfileSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;

  const ProfileSection({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
  });

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.amber,
          ),
          child: Icon(
            widget.icon,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: Text(widget.title),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 15,
          ),
        ),
      ),
    );
  }
}