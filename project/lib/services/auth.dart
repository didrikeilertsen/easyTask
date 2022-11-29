import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

///A Firebase authentication service
class Auth {
  final _firebaseAuth = FirebaseAuth.instance;

  final _googleSignIn = GoogleSignIn();

  // final _fb = FacebookLogin();

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  Future<User?> signInWithGoogle() async {
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
  //
  // Future<User?> signInWithFacebook() async {
  //   print("hallo");
  //
  //   // final response = await _fb.logIn();
  //
  //   final response = await _fb.logIn(permissions: [
  //     FacebookPermission.publicProfile,
  //     FacebookPermission.email
  //   ]);
  //
  //   print("hei");
  //
  //   print(response.toString());
  //   print(response.accessToken);
  //   print(response.status);
  //   print(response.error);
  //
  //   switch (response.status) {
  //     case FacebookLoginStatus.success:
  //       final accessToken = response.accessToken;
  //       final userCredential = await _firebaseAuth.signInWithCredential(
  //         FacebookAuthProvider.credential(accessToken!.token),
  //       );
  //       return userCredential.user;
  //     case FacebookLoginStatus.cancel:
  //       throw FirebaseAuthException(
  //           code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  //     case FacebookLoginStatus.error:
  //       throw FirebaseAuthException(
  //         code: 'ERROR_FACEBOOK_LOGIN_FAILED',
  //         message: response.error!.developerMessage,
  //       );
  //     default:
  //       throw UnimplementedError();
  //   }
  // }

  Future<void> signOut() async {
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.signOut();
    }
    if (_firebaseAuth.currentUser != null) {
      await _firebaseAuth.signOut();
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print(" user info = ${userCredentials.user?.uid}");

    return userCredentials.user;
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    print(" user info = ${userCredentials.user?.uid}");
    return userCredentials.user;
  }
}
