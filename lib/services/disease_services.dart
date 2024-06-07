import 'package:medical-assistant/lib/models/disease.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiseaseService {
  final CollectionReference diseaseCollection =
      FirebaseFirestore.instance.collection('diseases');

  Future<void> createDisease(Disease disease) async {
    await diseaseCollection.add({
      'medicalDiagnosis': disease.medicalDiagnosis,
      'description': disease.description,
    });
  }

  Future<Disease?> readDisease(String id) async {
    DocumentSnapshot snapshot = await diseaseCollection.doc(id).get();
    if (snapshot.exists) {
      return Disease(
        medicalDiagnosis: snapshot['medicalDiagnosis'],
        description: snapshot['description'],
      );
    }
    return null;
  }

  Future<void> updateDisease(String id, Disease disease) async {
    await diseaseCollection.doc(id).update({
      'medicalDiagnosis': disease.medicalDiagnosis,
      'description': disease.description,
    });
  }

  Future<void> deleteDisease(String id) async {
    await diseaseCollection.doc(id).delete();
  }
}
