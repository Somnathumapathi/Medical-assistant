import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_assistant/models/doctor.dart';

class DoctorNotifier extends ChangeNotifier {
  Doctor? _doctor;
  Doctor? get doctor => _doctor;

  setDoctor(Doctor doctor) {
    _doctor = doctor;
    notifyListeners();
  }
}

final doctorProvider = ChangeNotifierProvider((ref) => DoctorNotifier());
