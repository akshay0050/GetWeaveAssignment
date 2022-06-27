
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String name = '';
  String gender;
  double weight;
  DateTime? date = DateTime.now();
  String? referenceId;

  // ignore: sort_constructors_first
  UserData(this.name, this.gender, this.weight,{this.date , this.referenceId,});

  factory UserData.fromSnapshot(DocumentSnapshot snapshot) {
    final userData = UserData.fromJson(snapshot.data() as Map<String, dynamic>);
    userData.referenceId = snapshot.reference.id;
    return userData;
  }

  // ignore: sort_constructors_first
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _userDataFromJson(json);

  Map<String, dynamic> toJson() => _userDataToJson(this);

  @override
  String toString() => 'UserData<$name>';
}

UserData _userDataFromJson(Map<String, dynamic> json) {
  return UserData(
    json['name'] as String,
    json['gender'] as String,
    json['weight'] as double,
      date: (json['date'] as Timestamp).toDate()
  );
}

Map<String, dynamic> _userDataToJson(UserData userData) =>
    <String, dynamic>{
      'name': userData.name,
      'gender': userData.gender,
      'weight': userData.weight,
      'date': userData.date,
    };


