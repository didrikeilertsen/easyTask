import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/homeScreen.dart';
import 'package:project/screens/sign_in/sign_in_screen.dart';

import '../../services/auth.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

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

  // @override
  // Widget build(BuildContext context) {
  //   // if (_user == null) {
  //   //   return SignInScreen(
  //   //     onSignIn: _updateUser,
  //   //   );
  //   // }
  //   // return const CustomBottomNavigator();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //TODO test this
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return SignInScreen(auth: widget.auth);
          }
        },
      ),
    );
  }
}