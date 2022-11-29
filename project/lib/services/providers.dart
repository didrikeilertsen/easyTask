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

final fireBaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
