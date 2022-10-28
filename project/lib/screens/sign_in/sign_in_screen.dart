import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/services/auth.dart';
import 'package:project/widgets/sign_in_button.dart';
import 'package:project/widgets/sign_up_button.dart';

import '../../main.dart';
import '../../models/project.dart';
import '../../static_data/example_data.dart';
import '../profile/create_profile_screen.dart';

///Represents the sign-in screen for the application
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, required this.auth});

  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/signInBackground.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    Project project = ExampleData.projects[0];
    //TODO: fra espen sin commit List<Project> projects = ExampleData.projects;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 120, 30, 100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildLogo(),
                    // _buildSignInWithExistingAccountButton(),
                    // _buildSignUpButton(),
                    const SizedBox(height: 80.0),
                    _buildGoogleSignInButtons(context, project),
                    const SizedBox(height: 15.0),
                    _buildFacebookSignInButtons(context, project),
                    const SizedBox(height: 15.0),
                    _buildAppleSignInButtons(context, project),
                    const SizedBox(height: 25.0),

                    const Text(
                      "or",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15.0),
                    SignUpButton(
                      text: "Sign up with email",
                      onPressed: () {},
                    ),
                    const SizedBox(height: 25.0),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("have an account? "),
                      TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft,
                            //TODO: Check why foregroundColor makes error.
                            foregroundColor: Colors.black,
                            textStyle: const TextStyle(
                              //color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Comfortaa",
                            )),
                        onPressed: () {
                          //TODO: espen sin commit Navigator.pushNamed(context, ProjectOverviewScreen.routeName, arguments: projects);
                        },
                        child: const Text("log in"),
                      ),
                      //Text("log in", style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFacebookSignInButtons(BuildContext context, Project project) {
    return SignInButton(
      icon: PhosphorIcons.facebookLogo,
      text: "Continue with Facebook",
      onPressed: () => Navigator.of(context)
          .pushReplacementNamed(CreateProfileScreen.routeName),
    );
  }

  //TODO buildcontext and project parameters?
  Widget _buildGoogleSignInButtons(BuildContext context, Project project) {
    return SignInButton(
      icon: PhosphorIcons.googleLogo,
      text: "Continue with Google",
      onPressed: () => _signInWithGoogle(context),
    );
  }

  Widget _buildAppleSignInButtons(BuildContext context, Project project) {
    return SignInButton(
      icon: PhosphorIcons.appleLogo,
      text: "Continue with Apple",
      onPressed: () => _signInAnonymously(context),
    );
  }

//TODO: finish refactoring

  Widget _buildLogo() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
      Text(
        "easy",
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.w100,
          color: Colors.black,
        ),
      ),
      Text(
        "Task",
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      )
    ]);
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      //final userCredentials =
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: "test@test.com", password: "test"
              // email: emailController.text.trim(),
              // password: passwordController.text.trim()
              );
      //print(" user info = ${userCredentials.user?.uid}");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      final user = await auth.signInAnonymously();
      print(" user info = ${user?.uid}");

      //await Future.delayed(const Duration(seconds: 3));

    } catch (e) {
      print(e.toString());
    } finally {
      navigatorKey.currentState!.pop();
    }
    //navigatorKey.currentState!.popUntil((route) => route.isActive);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => const Center(child: CircularProgressIndicator(),
    //     ));

    try {
      final user = await auth.signInWithGoogle();
      print(" user info = ${user?.uid}");

      //await Future.delayed(const Duration(seconds: 3));

    } catch (e) {
      print(e.toString());
    }

    // finally {
    //   navigatorKey.currentState!.pop();
    // }
  }
}
