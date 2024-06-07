import 'package:medical-assistant/lib/models/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {
  final CollectionReference reportCollection =
      FirebaseFirestore.instance.collection('reports');

  Future<void> createReport(Report report) async {
    await reportCollection.add(report.toMap());
  }

  Future<Report?> readReport(String id) async {
    DocumentSnapshot snapshot = await reportCollection.doc(id).get();
    if (snapshot.exists) {
      return Report.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateReport(String id, Report report) async {
    await reportCollection.doc(id).update(report.toMap());
  }

  Future<void> deleteReport(String id) async {
    await reportCollection.doc(id).delete();
  }
}
