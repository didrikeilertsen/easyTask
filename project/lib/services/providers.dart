import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/auth.dart';

import 'database.dart';

//  This is how you create a provider in Riverpod. Note the syntax may change in near future.
//  This is a provider which provides all the features of Authentication class we have created

//  The syntax is pretty simple.
//  you are using a Class Provider and specifiying the type of provider.
//  now this takes a function takes a providerreference ref as a parameter
//  this ref can you used to access a provider within a provider.
//  if you are not using a provider within a provdier, no worries. It's not compulosry.
//  you can use a provider without a provider.

final authenticationProvider = Provider<Auth>((ref) {
  return Auth();
});



//TODO: slett
final numberProvider = Provider<int>((ref) {
  return 42;
});



final databaseProvider = Provider<Database>((ref) {
  String uid = Auth().currentUser!.uid;


  print("THIS IS THE UID ----------------- $uid");

  return Database(uid: uid);
});



// final authStateProvider = StreamProvider<User?>((ref) {
//   return ref.read(authenticationProvider).authStateChange;
// });

final fireBaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
