import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/customBottomNavigator.dart';
import 'package:project/screens/sign_in/sign_in_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _updateUser(FirebaseAuth.instance.currentUser);
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
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomBottomNavigator();
        } else {
          return SignInScreen(onSignIn: _updateUser);
        }
      },
    );
  }
}
