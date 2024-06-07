// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:medical_assistant/models/report.dart';

class Patient {
  final String pId;
  final String pName;
  final String pMail;
  final List<Report> reports;
  final String breakfastTime;
  final String lunchTime;
  final String dinnerTime;
  final String language;
  final String careTakerNo;

  Patient(
      {required this.pId,
      required this.pName,
      required this.pMail,
      required this.reports,
      required this.breakfastTime,
      required this.lunchTime,
      required this.dinnerTime,
      required this.language,
      required this.careTakerNo});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pId': pId,
      'pName': pName,
      'pMail': pMail,
      'reports': reports.map((x) => x.toMap()).toList(),
      'breakfastTime': breakfastTime,
      'lunchTime': lunchTime,
      'dinnerTime': dinnerTime,
      'language': language,
      'careTakerNo': careTakerNo,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      pId: map['pId'] as String,
      pName: map['pName'] as String,
      pMail: map['pMail'] as String,
      reports: List<Report>.from(
        (map['reports'] as List<dynamic>).map<Report>(
          (x) => Report.fromMap(x as Map<String, dynamic>),
        ),
      ),
      breakfastTime: map['breakfastTime'] as String,
      lunchTime: map['lunchTime'] as String,
      dinnerTime: map['dinnerTime'] as String,
      language: map['language'] as String,
      careTakerNo: map['careTakerNo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Patient.fromJson(String source) =>
      Patient.fromMap(json.decode(source) as Map<String, dynamic>);
}
