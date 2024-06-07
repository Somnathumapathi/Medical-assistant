// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Doctor {
  final String dname;
  final String dId;
  final String dNumber;

  Doctor({required this.dname, required this.dId, required this.dNumber});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dname': dname,
      'dId': dId,
      'dNumber': dNumber,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      dname: map['dname'] as String,
      dId: map['dId'] as String,
      dNumber: map['dNumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Doctor.fromJson(String source) => Doctor.fromMap(json.decode(source) as Map<String, dynamic>);
}
