import 'package:flutter/material.dart';

class ProfileSection extends StatefulWidget {
  final String title;
  final IconData icon;

  const ProfileSection({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Theme.of(context).colorScheme.surface,
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
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 15,
          ),
        ),
      ),
    );
  }
}
