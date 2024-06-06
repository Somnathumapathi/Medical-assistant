import 'package:medical_assistant/models/report.dart';

class Patient {
  final String pId;
  final String pName;
  final List<Report> reports;
  final String breakfastTime;
  final String lunchTime;
  final String dinnerTime;
  final String language;
  final String careTakerNo;

  Patient(
      {required this.pId,
      required this.pName,
      required this.reports,
      required this.breakfastTime,
      required this.lunchTime,
      required this.dinnerTime,
      required this.language,
      required this.careTakerNo});
}
