// import 'package:medical-assistant/lib/models/patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/patient.dart';

class PatientService {
  final CollectionReference patientCollection =
      FirebaseFirestore.instance.collection('patients');

  Future<void> createPatient(Patient patient) async {
    await patientCollection.add(patient.toMap());
  }

  Future<Patient?> readPatient(String id) async {
    DocumentSnapshot snapshot = await patientCollection.doc(id).get();
    if (snapshot.exists) {
      return Patient.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updatePatient(String id, Patient patient) async {
    await patientCollection.doc(id).update(patient.toMap());
  }

  Future<void> deletePatient(String id) async {
    await patientCollection.doc(id).delete();
  }
}
