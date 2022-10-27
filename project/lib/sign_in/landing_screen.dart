import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/project_overview_screen.dart';
import 'package:project/screens/sign_in_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  User? _user;
  
  void _updateUser(User? user){
    print("user id: ${_user?.uid}");

    setState(() {
      _user = user;
    });

  }

  @override
  Widget build(BuildContext context) {
    if(_user == null) {
      return SignInScreen(
        onSignIn: _updateUser,
      );
    }
    return const ProjectOverviewScreen();
    }
}
