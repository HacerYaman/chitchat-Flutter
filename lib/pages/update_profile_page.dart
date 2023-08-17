import 'package:chitchat/model/get_user_info.dart';
import 'package:chitchat/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final TextEditingController _bio_controller = TextEditingController();
    final TextEditingController _userName_controller = TextEditingController();
    final TextEditingController _password_controller = TextEditingController();

    UserService().fetchCurrentUser();
    Userr? currentUser = UserService.currentUser;

    String? new_bio = currentUser?.bio,
        new_userName = currentUser?.username,
        new_password = currentUser?.password;

    void _saveChanges() async {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          if (_userName_controller.toString().isEmpty) {
            SnackBar(content: Text("Username cannot be empty"));
            print("Username cannot be empty");
          } else {
            final userDocRef = _firestore.collection('users').doc(user.uid);
            await userDocRef.update({
              'bio': new_bio,
              "username": new_userName,
              "password": new_password,
            });
            Navigator.popAndPushNamed(context, '/profile');
          }
        }
      } catch (e) {
        print("Error updating profile: $e");
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: FutureBuilder(
            future: UserService().fetchCurrentUser(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final Userr? currentUser = UserService.currentUser;

                if (currentUser != null) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                currentUser.photoURL,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.amber,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Save Changes",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side: BorderSide.none,
                            shape: StadiumBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Shortcuts(
                              shortcuts: const <ShortcutActivator, Intent>{
                                // Pressing enter in the field will now move to the next field.
                                SingleActivator(LogicalKeyboardKey.enter):
                                    NextFocusIntent(),
                              },
                              child: TextFormField(
                                //controller: _bio_controller,
                                onChanged: (text) {
                                  new_bio = text;
                                },
                                cursorColor: Colors.amber,
                                initialValue: currentUser.bio,
                                decoration: InputDecoration(
                                    label: Text("Bio"),
                                    prefixIcon: Icon(Icons.text_snippet),
                                    prefixIconColor: Colors.black,
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ))),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Shortcuts(
                              shortcuts: const <ShortcutActivator, Intent>{
                                // Pressing space in the field will now move to the next field.
                                SingleActivator(LogicalKeyboardKey.enter):
                                    NextFocusIntent(),
                              },
                              child: TextFormField(
                                validator: (String? value) {
                                  return (value != null && value.contains('@'))
                                      ? 'Do not use the @ char.'
                                      : null;
                                },
                                //controller: _userName_controller,
                                onChanged: (text) {
                                  new_userName = text;
                                },
                                initialValue: currentUser.username,
                                cursorColor: Colors.amber,
                                decoration: InputDecoration(
                                    label: Text("User Name"),
                                    prefixIcon: Icon(Icons.person),
                                    prefixIconColor: Colors.black,
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ))),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Shortcuts(
                              shortcuts: const <ShortcutActivator, Intent>{
                                // Pressing space in the field will now move to the next field.
                                SingleActivator(LogicalKeyboardKey.enter):
                                    NextFocusIntent(),
                              },
                              child: TextFormField(
                                controller: _password_controller,
                                cursorColor: Colors.amber,
                                decoration: InputDecoration(
                                    label: Text("Password"),
                                    prefixIcon: Icon(Icons.fingerprint),
                                    prefixIconColor: Colors.black,
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ))),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  );
                }
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
