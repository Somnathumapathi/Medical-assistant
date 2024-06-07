import 'package:medical-assistant/lib/models/medication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationService {
  final CollectionReference medicationCollection =
      FirebaseFirestore.instance.collection('medications');

  Future<void> createMedication(Medication medication) async {
    await medicationCollection.add(medication.toMap());
  }

  Future<Medication?> readMedication(String id) async {
    DocumentSnapshot snapshot = await medicationCollection.doc(id).get();
    if (snapshot.exists) {
      return Medication.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateMedication(String id, Medication medication) async {
    await medicationCollection.doc(id).update(medication.toMap());
  }

  Future<void> deleteMedication(String id) async {
    await medicationCollection.doc(id).delete();
  }
}
