// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:medical_assistant/models/medication.dart';

class Report {
  final String rId;
  final String rLink;
  final DateTime startDate;
  final DateTime endTime;
  final String hospitalName;
  final String doctorName;
  final String patientName;
  final String description;
  final List<String> videoLinks;
  final List<Medication> medications;

  Report(
      {required this.rId,
      required this.rLink,
      required this.startDate,
      required this.endTime,
      required this.hospitalName,
      required this.doctorName,
      required this.patientName,
      required this.description,
      required this.videoLinks,
      required this.medications});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rId': rId,
      'rLink': rLink,
      'startDate': startDate.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'hospitalName': hospitalName,
      'doctorName': doctorName,
      'patientName': patientName,
      'description': description,
      'videoLinks': videoLinks,
      'medications': medications.map((x) => x.toMap()).toList(),
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      rId: ['rId'] as String,
      rLink:  map['rLink'] as String,
      startDate:  DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endTime:  DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      hospitalName:   map['hospitalName'] as String,
      doctorName:  map['doctorName'] as String,
      patientName:  map['patientName'] as String,
      description:  map['description'] as String,
      videoLinks:  List<String>.from((map['videoLinks'] as List<String>),),
      medications: List<Medication>.from((map['medications'] as List<int>).map<Medication>((x) => Medication.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) => Report.fromMap(json.decode(source) as Map<String, dynamic>);
}
