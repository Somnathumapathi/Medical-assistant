import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:medical_assistant/commons/constants.dart';
import 'package:medical_assistant/commons/utils.dart';
import 'package:medical_assistant/models/report.dart';
import 'package:medical_assistant/modules/patients/home/screens/report_details_screen.dart';
import 'package:medical_assistant/providers/patient_provider.dart';

class PatientReportsScreen extends ConsumerStatefulWidget {
  const PatientReportsScreen({super.key});

  @override
  ConsumerState<PatientReportsScreen> createState() =>
      _PatientReportsScreenState();
}

class _PatientReportsScreenState extends ConsumerState<PatientReportsScreen> {
  List<Report> reports = [];
  void getReports() async {
    try {
      final QuerySnapshot qsnap = await fireStore
          .collection('Reports')
          .where('pMail', isEqualTo: ref.read(patientProvider).patient!.pMail)
          .get();

      reports = qsnap.docs.map((doc) {
        return Report.fFromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    getReports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: reports.isEmpty
          ? Center(child: LottieBuilder.asset('assets/analyzing.json'))
          : Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final myRep = reports[index];
                    return Card(
                      color: const Color.fromARGB(255, 15, 119, 205),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReportDetailsScreen(report: myRep)));
                          },
                          child: ListTile(
                            tileColor: const Color.fromARGB(255, 15, 119, 205),
                            title: Text(myRep.startDate.toString()),
                            subtitle: Text(myRep.doctorName!),
                            trailing: Icon(
                              Icons.document_scanner_outlined,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
