import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              //       // Image.asset(
              //       //   "assets/images/profile_pictuer_placeholder.png",
              //       //   height: 200,
              //       // ),

              const Text("username:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  )),

              StreamBuilder<User?>(
                  stream: firebase.userChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.displayName != null) {
                        return Text(
                            snapshot.data!.displayName!,
                        style: TextStyle(
                          fontSize: 17,
                        )

                        );
                      }
                    }
                    if (!snapshot.hasData) {
                      return const Text("");
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text("Some error occurred"));
                    }
                    return const Center(
                        child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ));
                  }),
              const SizedBox(height: 15,),
              const Text("email:",
                  style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 17)
              ),
              Text(auth.currentUser!.email.toString(), style: TextStyle(
                fontSize: 17,
              ),),
              const SizedBox(height: 15,),
              Text("phone number:${auth.currentUser!.phoneNumber}"),

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
