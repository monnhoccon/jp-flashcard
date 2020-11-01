import 'package:cloud_firestore/cloud_firestore.dart';

class CloudDatabase {
  final collection = FirebaseFirestore.instance.collection('col');

  Future updateUserData(String data) async {
    return await collection.doc("a").set({
      'data': data,
    });
  }

  Stream<QuerySnapshot> get repoList {
    return collection.snapshots();
  }
}
