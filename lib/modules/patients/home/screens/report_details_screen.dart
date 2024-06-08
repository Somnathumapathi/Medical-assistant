import 'package:flutter/material.dart';
import 'package:medical_assistant/models/report.dart';

class ReportDetailsScreen extends StatelessWidget {
  const ReportDetailsScreen({super.key, required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(title: Text(report.medicalDiagnosis ?? 'JavaDeva')),
      body: Column(children: [
        Text(report.patientName!),
        Text(report.doctorName!),
        Text(report.description!)
        // Text(report.)
      ]),
    );
  }
}
