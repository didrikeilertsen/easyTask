import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/homeScreen.dart';
import 'package:project/screens/sign_in/sign_in_screen.dart';

import '../../services/auth.dart';
import '../../services/database.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key, required this.auth}) : super(key: key);

  //const LandingScreen({Key? key, required this.auth, required this.database}) : super(key: key);
  //final Database database;

  final Auth auth;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _updateUser(widget.auth.currentUser);
  }

  void _updateUser(User? user) {
    setState(() {
      _user = user;
    });
    print("user id: ${_user?.uid}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
