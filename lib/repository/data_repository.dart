
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/user_data_model.dart';
import 'package:flutter_app/utility/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';


class DataRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('userData');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future addUserData(UserData userData) {
    return collection.doc(new DateTime.now().millisecondsSinceEpoch.toString()).set(userData.toJson());
  }

  Future<void> updateUserData(UserData userData) async {
    await collection.doc(userData.referenceId).update(userData.toJson());
  }

  Future<void> deleteUserData(UserData userData) async {
    await collection.doc(userData.referenceId).delete();
  }

  Future<void> logoutUser() async{
  await FirebaseAuth.instance.signOut();
  final myDbObj = Hive.box(Utils.dbName);
  await myDbObj.delete(Utils.userNameKey);
  }
}
