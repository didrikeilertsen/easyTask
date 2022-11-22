import 'package:cloud_firestore/cloud_firestore.dart';


///A singleton-class which seperates the firestore-logic
class FirestoreService {

  FirestoreService._();
  static final instance = FirestoreService._();


  ///Helper method which uploads data to the database
  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  ///Helper method which updates data in the database
  Future<void> updateData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.update(data);
  }

  ///Helper method which creates a generic stream from a given database-path
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();

    return snapshots.map((snapshot) => (snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data()),
    )
        .toList()));
  }



}