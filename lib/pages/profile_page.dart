import 'package:chitchat/constants/theme/theme_provider.dart';
import 'package:chitchat/pages/update_profile_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/profile_section.dart';
import 'package:get/get.dart';
import '../constants/theme/color_scheme.dart';
import '../services/auth/auth_service.dart';
import '../model/get_user_info.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    FirebaseApiii().initNotifications().then((token) {
      setState(() {
        fcmToken = token;
      });
    });
  }

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<ThemeProvider>(context, listen: false).loadThemeMode();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder<void>(
              future: UserService().fetchCurrentUser(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final Userr? currentUser = UserService.currentUser;

                  if (currentUser != null) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.sunny),
                            CupertinoSwitch(
                              value: Provider.of<ThemeProvider>(
                                context,
                              ).themeMode,
                              activeColor: AppColors.blueGreyColor,
                              onChanged: (value) {
                                Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .themeChanged();
                              },
                            ),
                            const Icon(Icons.dark_mode),
                          ],
                        ),
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
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          currentUser.username,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          currentUser.email,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.tertiary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                currentUser.bio,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () =>
                                Get.to(() => const UpdateProfileScreen()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Edit Profile",
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
                        GestureDetector(
                          child: const ProfileSection(
                            title: 'User Management',
                            icon: Icons.person,
                          ),
                        ),
                        InkWell(
                          onTap: signOut,
                          child: const ProfileSection(
                            title: 'Log out',
                            icon: Icons.logout,
                          ),
                        ),
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

class FirebaseApiii {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<String?> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print("Token: $fcmToken");
    return fcmToken;
  }
}
