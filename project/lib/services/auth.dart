import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

///Creates an interface for authentication services
abstract class AuthBase {
  User? get currentUser;

  Future<User?> signInAnonymously();

  Future<User?> signInWithGoogle();

  Future<void> signOut();
}

///A Firebase authentication service which implements the AuthBase interface
class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  final _googleSignIn = GoogleSignIn();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }


  @override
  Future<User?> signInWithGoogle() async {
    // final googleSignIn = GoogleSignIn();
    final googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          code: "ERROR_MISSING_GOOGLE_TOKEN",
          message: "Missing Google Token",
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR',
        message: "Sign in aborted by user",
      );
    }
  }

//todo google signout doesnt work
  @override
  Future<void> signOut() async {
    //final googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

// Future<void> _signInWithApple() async {
//   try {
//     //FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
//     final userCredentials = await FirebaseAuth.instance.signInAnonymously();
//     onSignIn(userCredentials.user);
//     print(" user info = ${userCredentials.user?.uid}");
//   } catch (e) {
//     print(e.toString());
//   }
// }

}
