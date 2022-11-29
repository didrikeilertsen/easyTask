import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/auth.dart';

import 'database.dart';

final authenticationProvider = Provider<Auth>((ref) {
  return Auth();
});


final databaseProvider = Provider<Database>((ref) {
  String uid = Auth().currentUser!.uid;


  print("THIS IS THE UID ----------------- $uid");

  return Database(uid: uid);
});

// final databaseProvider = Provider<Database>((ref) {
//   // if (ref.read(authenticationProvider).currentUser?.uid != null) {
//   //   String uid = ref.read(authenticationProvider).currentUser!.uid;
// // }
//   // String uid = Auth().currentUser!.uid;
//   // return null;
//
//
//   String uid = "";
//
//   uid = ref.read(authenticationProvider).currentUser!.uid;
//
//   ref.read(authenticationProvider).authStateChange.first.then((value) => uid = value!.uid);
//
//
//     return Database(uid: uid);
//
// });


final uidProvider = Provider<String>((ref) {
  String uid = "";

  uid = ref.read(authenticationProvider).currentUser!.uid;

  ref.read(authenticationProvider).authStateChange.first.then((value) => uid = value!.uid);


  return uid;
});




final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authenticationProvider).authStateChange;
});

final fireBaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
