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

  ///Helper method which uploads data to the database
  Future<void> addData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.collection(path);
    print('$path: $data');
    await reference.add(data);
  }

  ///Helper method which uploads data to the database
  Future<void> removeData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('deleting $path');
    await reference.delete();
  }

  ///Helper method which creates a generic stream from a given database-path
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => (snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data(), snapshot.id),
    )
        .toList()));
  }
}
