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
    final auth = ref.read(authenticationProvider);
    final firebase = ref.read(fireBaseAuthProvider);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("profile", textAlign: TextAlign.center),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              //TODO: stretch-goal

              auth.currentUser?.photoURL != null
                  ? CircleAvatar(
                      backgroundColor: Themes.primaryColor,
                      radius: 115,
                      child: CircleAvatar(
                        radius: 110,
                        backgroundImage:
                            NetworkImage(auth.currentUser!.photoURL!),
                      ),
                    )
                  : Image.asset(
                      "assets/images/empty_profile_pic_large.png",
                      height: 200,
                      color: Themes.primaryColor,
                    ),
              const SizedBox(height: 70),
              StreamBuilder<User?>(
                  stream: firebase.userChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.displayName != null) {
                        return Text(snapshot.data!.displayName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ));
                      }
                    }
                    if (!snapshot.hasData) {
                      return const Text("");
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text("Some error occurred"));
                    }
                    return const Center(child: SizedBox(height: 10));
                  }),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/editProfile');
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  side: BorderSide(width: 1.5, color: Themes.primaryColor),
                ),
                child: const Text(
                  'edit profile',
                  style: TextStyle(color: Colors.black87),
                ),
              ),

              OutlinedButton(
                onPressed: () => _signOut(ref),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  side: BorderSide(width: 1.5, color: Themes.primaryColor),
                ),
                child: const Text(
                  'log out',
                  style: TextStyle(color: Colors.black87),
                ),
              ),

              // OutlinedButton(
              //   onPressed: () {},
              //
              //   style: ButtonStyle(
              //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30.0))
              //     ),
              //   ),
              //
              //   child: const Text("edit profile"),
              // ),
              // OutlinedButton(
              //   onPressed: () {},
              //
              //   style: ButtonStyle(
              //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30.0))
              //     ),
              //   ),
              //
              //   child: const Text("log out"),
              // ),
            ],
          ),
        ));
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
