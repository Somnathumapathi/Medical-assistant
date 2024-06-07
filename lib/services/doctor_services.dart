// import 'package:medical-assistant/lib/models/doctor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/doctor.dart';

class DoctorService {
  final CollectionReference doctorCollection =
      FirebaseFirestore.instance.collection('doctors');

  Future<void> createDoctor(Doctor doctor) async {
    await doctorCollection.add(doctor.toMap());
  }

  Future<Doctor?> readDoctor(String id) async {
    DocumentSnapshot snapshot = await doctorCollection.doc(id).get();
    if (snapshot.exists) {
      return Doctor.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateDoctor(String id, Doctor doctor) async {
    await doctorCollection.doc(id).update(doctor.toMap());
  }

  Future<void> deleteDoctor(String id) async {
    await doctorCollection.doc(id).delete();
  }
}
