import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

///Creates an interface for authentication services
abstract class AuthBase {
  User? get currentUser;

  Future<User?> signInAnonymously();

  Future<User?> signInWithGoogle();

  Future<User?> signInWithFacebook();

  Future<User?> signInWithEmailAndPassword(String email, String password);

  Future<User?> createUserWithEmailAndPassword(String email, String password);

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

  @override
  Future<User?> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken!.token),
        );
        return userCredential.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.error!.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

//todo google signout doesnt work properly. needs hot restart to get sign-in prompt after logging out with google
  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    // final facebookLogin = FacebookLogin();
    // await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print(" user info = ${userCredentials.user?.uid}");

    return userCredentials.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    print(" user info = ${userCredentials.user?.uid}");
    return userCredentials.user;
  }
}
