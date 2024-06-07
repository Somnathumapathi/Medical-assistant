import 'package:flutter/material.dart';
import 'package:medical_assistant/models/medication.dart';
import 'package:medical_assistant/models/report.dart';

class SessionResultScreen extends StatefulWidget {
  const SessionResultScreen({super.key, required this.report});
  final Report report;
  @override
  State<SessionResultScreen> createState() => _SessionResultScreenState();
}

class _SessionResultScreenState extends State<SessionResultScreen> {
  late TextEditingController _resultController;
  final _durationController = TextEditingController();
  final _patientNameController = TextEditingController();
  String? result;

  void _generateResultText() {
    final medicalDiagnosis = widget.report.medicalDiagnosis ?? 'N/A';
    final description = widget.report.description ?? 'No description available';
    final medications = widget.report.medications?.map((medication) {
          return '''
Name: ${medication.mName}
Times: ${medication.mTime.map((time) => time ? 'Yes' : 'No').join(', ')}
Duration: ${medication.mDuration}
Instructions: ${medication.mInstructions}
      ''';
        }).join('\n\n') ??
        'No medications available';

    result = '''
Medical Diagnosis: $medicalDiagnosis

Description: $description

Medications:
$medications
    ''';
  }

  @override
  void initState() {
    _generateResultText();
    _resultController = TextEditingController(text: result);
    super.initState();
  }

  @override
  void dispose() {
    _resultController.dispose();
    _durationController.dispose();
    _patientNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            TextFormField(
              controller: _resultController,
              maxLines: 20,
            ),
            SizedBox(
              height: 15,
            ),
            Text("Enter patient name:"),
            TextFormField(
              decoration: InputDecoration(hintText: "Enter Patient Name"),
              controller: _patientNameController,
              //keyboardType: TextInputType.numberWithOptions(),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              label: Text('Generate Report'),
              icon: Icon(Icons.edit_document),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        )),
      ),
    );
  }
}
