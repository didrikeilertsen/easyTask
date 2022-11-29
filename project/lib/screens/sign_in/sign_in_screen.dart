import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/widgets/sign_in_button.dart';
import 'package:project/widgets/sign_up_button.dart';
import '../../main.dart';
import '../../services/providers.dart';

///Represents the sign-in screen for the application
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/signInBackground.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: _buildContent(context, ref),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 120, 30, 100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
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
                    _buildLogo(ref),
                    const SizedBox(height: 80.0),
                    _buildGoogleSignInButtons(ref),
                    const SizedBox(height: 15.0),
                    _buildFacebookSignInButtons(ref),
                    const SizedBox(height: 15.0),
                    _buildAppleSignInButtons(context, ref),
                    const SizedBox(height: 25.0),
                    const Text(
                      "or",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15.0),
                    SignUpButton(
                      text: "Sign up with email",
                      onPressed: () {
                        Navigator.of(context).pushNamed('/registrationScreen');
                      },
                    ),
                    const SizedBox(height: 25.0),
                    _buildLoginButton(context),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("have an account? "),
      TextButton(
        style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(
              //color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: "Comfortaa",
            )),
        onPressed: () {
          Navigator.of(context).pushNamed('/loginScreen');
        },
        child: const Text("log in"),
      ),
    ]);
  }

  Widget _buildFacebookSignInButtons(WidgetRef ref) {
    return SignInButton(
      icon: PhosphorIcons.facebookLogo,
      text: "Continue with Facebook",
      onPressed: () {},
      // onPressed: () => _signInWithFacebook(ref),
    );
  }

  Widget _buildGoogleSignInButtons(WidgetRef ref) {
    return SignInButton(
      icon: PhosphorIcons.googleLogo,
      text: "Continue with Google",
      onPressed: () => _signInWithGoogle(ref),
    );
  }

  Widget _buildAppleSignInButtons(BuildContext context, WidgetRef ref) {
    return SignInButton(
      icon: PhosphorIcons.appleLogo,
      text: "Continue with Apple",
      onPressed: () => _signInAnonymously(context, ref),
    );
  }

  Widget _buildLogo(WidgetRef ref) {

    final auth = ref.read(authenticationProvider);

    print( "current user:");
    print( auth.currentUser);

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

  Future<void> _signInAnonymously(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authenticationProvider);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final user = await auth.signInAnonymously();
      print(" user info = ${user?.uid}");
    } catch (e) {
      print(e.toString());
    } finally {
      navigatorKey.currentState!.pop();
    }
  }

  Future<void> _signInWithGoogle(WidgetRef ref) async {
    final auth = ref.read(authenticationProvider);
    try {
      final user = await auth.signInWithGoogle();
      print(" user info = ${user?.uid}");
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> _signInWithFacebook(WidgetRef ref) async {
  //   final auth = ref.read(authenticationProvider);
  //   print("h");
  //   try {
  //     final user = await auth.signInWithFacebook();
  //     print(" user info = ${user?.uid}");
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
