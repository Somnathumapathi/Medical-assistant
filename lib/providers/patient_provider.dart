import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_assistant/models/patient.dart';

class PatientNotifier extends ChangeNotifier {
  Patient? _patient;
  Patient? get patient => _patient;

  setPatient(Patient patient) {
    _patient = patient;
    notifyListeners();
  }
}

final patientProvider =
    ChangeNotifierProvider<PatientNotifier>((ref) => PatientNotifier());
