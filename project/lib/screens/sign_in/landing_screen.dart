import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/homeScreen.dart';
import 'package:project/screens/sign_in/sign_in_screen.dart';
import '../../services/providers.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  LandingScreenState createState() => LandingScreenState();
}

class LandingScreenState extends ConsumerState<LandingScreen> {


  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authenticationProvider);

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: auth.authStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return const SignInScreen();
            }
            return const HomeScreen();
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
