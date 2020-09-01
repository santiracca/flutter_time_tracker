import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();
  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final ref = FirebaseFirestore.instance.doc(path);
    print("$path: $data");
    await ref.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    final ref = FirebaseFirestore.instance.collection(path);
    final snapshots = ref.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map((snapshot) => builder(snapshot.data())).toList());
  }
}
