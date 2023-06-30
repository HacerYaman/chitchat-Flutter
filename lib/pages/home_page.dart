import 'package:chitchat/components/searchbar.dart';
import 'package:chitchat/pages/profile_page.dart';
import 'package:chitchat/pages/recent_chats_page.dart';
import 'package:chitchat/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  Widget pageSituation() {
    if (_page == 0) {
      return _buildUserList();
    }
    if (_page == 1) {
      return RecentChatsPage();
    }
    return ProfilePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: pageSituation(),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.shuffle, size: 30),
          Icon(Icons.chat, size: 30),
          Icon(Icons.person, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.grey.shade200,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 150),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  Widget _buildUserList() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 56,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Text(
                  "Meet People!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          MySearchBar(),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData) {
                return Text("No data available");
              }
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs
                      .map<Widget>((doc) => _buildUserListItem(doc))
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data["email"]) {
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
    } else {
      return Container();
    }
  }
}
