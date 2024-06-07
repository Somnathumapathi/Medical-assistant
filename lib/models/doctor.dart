// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Doctor {
  final String dname;
  final String dId;
  final String dMail;

  Doctor({required this.dname, required this.dId, required this.dMail});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dname': dname,
      'dId': dId,
      'dMail': dMail,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      dname: map['dname'] as String,
      dId: map['dId'] as String,
      dMail: map['dMail'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Doctor.fromJson(String source) =>
      Doctor.fromMap(json.decode(source) as Map<String, dynamic>);
}
