import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16)
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        cursorColor: Colors.black,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          hintText: "Search for...",
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
            },
          )
        ),
      ),
    );
  }
}

