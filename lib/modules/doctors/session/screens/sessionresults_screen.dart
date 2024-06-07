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
  final _patientNumberController = TextEditingController();
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
    _patientNumberController.dispose();
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
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 91, 106, 191)),
              child: TextFormField(
                decoration:
                    InputDecoration(fillColor: Colors.indigo.withOpacity(0.26)),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300),
                controller: _resultController,
                maxLines: 20,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Enter patient name:",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 91, 106, 191)),
              child: TextFormField(
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300),
                decoration: InputDecoration(hintText: "Enter Patient Name"),
                controller: _patientNameController,
                //keyboardType: TextInputType.numberWithOptions(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Enter patient number:",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 91, 106, 191)),
              child: TextFormField(
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300),
                decoration: InputDecoration(hintText: "Enter Patient Number"),
                controller: _patientNumberController,
                //keyboardType: TextInputType.numberWithOptions(),
              ),
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
