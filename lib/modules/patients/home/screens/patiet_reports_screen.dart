import 'package:flutter/material.dart';

class PatientReportsScreen extends StatefulWidget {
  const PatientReportsScreen({super.key});

  @override
  State<PatientReportsScreen> createState() => _PatientReportsScreenState();
}

class _PatientReportsScreenState extends State<PatientReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              color: const Color.fromARGB(255, 15, 119, 205),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: const Color.fromARGB(255, 15, 119, 205),
                  title: Text('Date:'),
                  subtitle: Text('Rajeev'),
                  trailing: Icon(
                    Icons.document_scanner_outlined,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
