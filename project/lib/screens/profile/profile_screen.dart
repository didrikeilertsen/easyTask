import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/services/auth.dart';
import 'package:project/widgets/appbar_button.dart';

/// Screen/Scaffold for the profile of the user.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.auth});

  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("profile", textAlign: TextAlign.center),
        actions: [
          // TODO: Add action to button.
          AppBarButton(
              handler: () {},
              tooltip: "Settings",
              icon: PhosphorIcons.gearSixLight)
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Image.asset(
              "assets/images/profile_pictuer_placeholder.png",
              height: 200,
            ),

            //TODO: get info from user
            const Text("edit profile"),
            const Text("app settings"),
            const Text("app info"),
            TextButton(
                onPressed: _signOut,
                child: const Text(
                  "log out",
                  style: TextStyle(color: Colors.black87),
                ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    try {
     await auth.signOut();

    } catch (e) {
      print(e.toString());
    } finally {
      print("is user logged in? null if not: ${auth.currentUser?.uid}");
    }
  }
}
