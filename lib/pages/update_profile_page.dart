import 'dart:io';
import 'package:chitchat/model/get_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

UserService userService= new UserService();

//userService.fetchCurrentUser();

Userr? currentUserrr = UserService.currentUser;

String? new_bio = currentUserrr?.bio,
    new_userName = currentUserrr?.username,
    new_password = currentUserrr?.password,
    new_url= currentUserrr?.photoURL;

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 // final TextEditingController _bio_controller = TextEditingController();
  final TextEditingController _userName_controller = TextEditingController();
  final TextEditingController _password_controller = TextEditingController();

  void _saveChanges() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (_userName_controller.toString().isEmpty) {
          const SnackBar(content: Text("Username cannot be empty"));
          print("Username cannot be empty");
        } else {
          final userDocRef = _firestore.collection('users').doc(user.uid);
          await userDocRef.update({
            'bio': new_bio,
            "username": new_userName,
            "password": new_password,
            "photoURL": new_url,
          });
          Navigator.popAndPushNamed(context, '/profile');
        }
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

//-----

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    // Future<String> uploadImage() async {
    String fileName = const Uuid().v1();
    var ref =
    FirebaseStorage.instance.ref().child("images").child("$fileName.jpg");
    var uploadTask = await ref.putFile(imageFile!);
    String imageUrl = await uploadTask.ref.getDownloadURL();
    print(imageUrl);

    new_url=imageUrl;

    imageUrl = "";
    imageFile = null;
  }

  //---------------------------------------


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder(
              future: UserService().fetchCurrentUser(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final Userr? currentUser = UserService.currentUser;

                  if (currentUser != null) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
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
                                child: IconButton(
                                  onPressed: () {
                                    getImage();
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Save Changes",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        Form(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                      label: const Text("Bio"),
                                      prefixIcon: const Icon(Icons.text_snippet),
                                      prefixIconColor: Colors.black,
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                          ))),
                                ),
                              ),
                              const SizedBox(
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
                                    return (value != null &&
                                            value.contains('@'))
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
                                      label: const Text("User Name"),
                                      prefixIcon: const Icon(Icons.person),
                                      prefixIconColor: Colors.black,
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                          ))),
                                ),
                              ),
                              const SizedBox(
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
                                      label: const Text("Password"),
                                      prefixIcon: const Icon(Icons.fingerprint),
                                      prefixIconColor: Colors.black,
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: const BorderSide(
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
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
