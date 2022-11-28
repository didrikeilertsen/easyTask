import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/services/auth.dart';
import 'package:project/widgets/appbar_button.dart';

import '../../services/providers.dart';

/// Screen/Scaffold for the profile of the user.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authenticationProvider);
    final database = ref.read(databaseProvider);

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

            const Text("email:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(auth.currentUser!.email.toString()),

            const Text("username:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            _buildUsername(ref),


            const SizedBox(height: 30),

            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/editProfile');
              },
              child: const Text(
                "edit profile",
                style: TextStyle(color: Colors.black87),
              ),
            ),

            TextButton(
              onPressed: () => _signOut(ref),
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

  //TODO: bug - doesnt update displayname when user registers for first time
  Widget _buildUsername(WidgetRef ref) {
    _updateUsername(ref);
    final auth = ref.read(authenticationProvider);

    return (Text(auth.currentUser!.displayName.toString()));
  }

  void _updateUsername(WidgetRef ref) async {
    final auth = ref.read(authenticationProvider);
    User user = auth.currentUser!;
    await user.reload();

    // `currentUser` is synchronous since FirebaseAuth rework
    User? user2 = auth.currentUser;
    print(user2?.displayName);
  }

  Future<void> _signOut(WidgetRef ref) async {
    final auth = ref.read(authenticationProvider);
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    } finally {
      print("is user logged in? null if not: ${auth.currentUser?.uid}");
    }
  }
}
