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
}
