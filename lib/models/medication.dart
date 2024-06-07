// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Medication {
  // final String mId;
  final String mName;
  final List<bool> mTime;
  final String mInstructions;

  Medication({required this.mId, required this.mName, required this.mTime});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mId': mId,
      'mName': mName,
      'mTime': mTime,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      mId: map['mId'] as String,
      mName: map['mName'] as String,
      mTime: List<bool>.from((map['mTime'] as List<bool>),)
    );
  }

  String toJson() => json.encode(toMap());

  factory Medication.fromJson(String source) => Medication.fromMap(json.decode(source) as Map<String, dynamic>);

}
