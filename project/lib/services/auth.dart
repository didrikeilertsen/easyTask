import 'package:firebase_auth/firebase_auth.dart';

///Creates an interface for authentication services
abstract class AuthBase {
  User? get currentUser;

  Future<User?> signInAnonymously();

  Future<void> signOut();
}

///A Firebase authentication service which implements the AuthBase interface
class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  @override
  Future<void> signOut() async {
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
