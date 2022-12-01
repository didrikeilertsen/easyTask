import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/styles/themes.dart';

import '../../services/providers.dart';

/// Screen/Scaffold for the profile of the user.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("profile", textAlign: TextAlign.center),
        ),
        body: _buildContent(context, ref),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref){
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          _buildUserInfo(ref),
          const SizedBox(height: 60),
          _buildButtons(context, ref),
        ],
      ),
    );
  }

  Widget _buildUserInfo(WidgetRef ref) {
    final firebase = ref.read(fireBaseAuthProvider);
    return StreamBuilder<User?>(
      stream: firebase.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User? user = snapshot.data;
          return Column(
            children: [
              _buildAvatar(user),
              const SizedBox(height: 30),
              _buildUserInfoText(user)
            ],
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Can't load profile data from the database"),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildUserInfoText(User? user) {
    if (user == null || user.displayName == null) return const Text("");
    return Text(
      user.displayName!,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Themes.primaryColor,
      ),
    );
  }

  Widget _buildAvatar(User? user) {
    if (user == null || user.photoURL == null) return _buildDefaultAvatar();

    return CircleAvatar(
      backgroundColor: Themes.primaryColor,
      radius: 115,
      child: CircleAvatar(
          radius: 110,
          child: ClipOval(
            child: Image.network(
              user.photoURL!,
              width: 230,
              height: 230,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black87,
                    ),
                  );
                }
              },
            ),
          )),
    );
  }

  Widget _buildDefaultAvatar() {
    return Image.asset(
      "assets/images/empty_profile_pic_large.png",
      height: 230,
      color: Themes.primaryColor,
    );
  }

  Widget _buildButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Girts comment: here I would also probably refactor it to _buildEditProfileButton() and _buildSignOutButton()
        // Currently there is a lot of code where the developer needs to read all the code to really understand that there are two buttons
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/editProfile');
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text(
            'edit profile',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        OutlinedButton(
          onPressed: () => _signOut(ref),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text(
            'log out',
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Future<void> _signOut(WidgetRef ref) async {
    final auth = ref.read(authenticationProvider);
    try {
      await auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      if (kDebugMode) {
        print("is user logged in? null if not: ${auth.currentUser?.uid}");
      }
    }
  }
}
