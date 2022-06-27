
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/user_data_model.dart';


class DataRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('userData');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addUserData(UserData userData) {
    return collection.add(userData.toJson());
  }

  Future<void> updateUserData(UserData userData) async {
    await collection.doc(userData.referenceId).update(userData.toJson());
  }

  Future<void> deleteUserData(UserData userData) async {
    await collection.doc(userData.referenceId).delete();
  }
}
