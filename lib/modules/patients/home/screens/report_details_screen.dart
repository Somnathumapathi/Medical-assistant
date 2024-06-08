import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medical_assistant/commons/utils.dart';
import 'package:medical_assistant/models/report.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class ReportDetailsScreen extends StatelessWidget {
  ReportDetailsScreen({super.key, required this.report});

  final Report report;
  final flutterTts = FlutterTts();
  final speech = stt.SpeechToText();
  late String result;

  void _generateResultText() {
    final medicalDiagnosis = report.medicalDiagnosis ?? 'N/A';
    final description = report.description ?? 'No description available';
    final medications = report.medications?.map((medication) {
      return '''
      Name: ${medication.mName}
      Times: ${medication.mTime.asMap().entries.map((entry) {
        final index = entry.key;
        final time = entry.value;
        final meal = index == 0
            ? 'breakfast'
            : index == 1
                ? 'lunch'
                : 'dinner';
        return time ? 'Yes during $meal' : 'No during $meal';
      }).join(', ')}
      Duration: ${medication.mDuration}
      Instructions: ${medication.mInstructions}
      ''';
    }).join('\n\n') ?? 'No medications available';

    result = '''
    Medical Diagnosis: $medicalDiagnosis

    Description: $description

    Medications:
    $medications
    ''';
  }

  Future<void> createPDF(BuildContext context) async {
    try {
      final pdf = pw.Document();

      // Add a page to the PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                children: [
                  // Add a title to the report
                  pw.Text(
                    'Medical Report',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 20),
                  // Add the report content
                  pw.Text(result),
                ],
              ),
            );
          },
        ),
      );

      // Get the temporary directory
      final output = await getTemporaryDirectory();
      // Create the PDF file
      final file = File("${output.path}/example.pdf");
      // Write the PDF content to the file
      await file.writeAsBytes(await pdf.save());

      print('PDF saved to: ${file.path}');

      // Open the PDF file
      await OpenFile.open(file.path);
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  Future<void> speakResult(BuildContext context) async {
    try {
      await flutterTts.speak(result);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to generate PDF'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    _generateResultText(); // Make sure to generate the result text before using it

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(title: Text(report.medicalDiagnosis ?? 'JavaDeva')),
      body: Column(children: [
        Text(report.patientName!),
        Text(report.doctorName!),
        Text(report.description!),
        ElevatedButton.icon(
          onPressed: () => speakResult(context),
          label: const Text('Text-to-Speech'),
          icon: const Icon(Icons.record_voice_over),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => createPDF(context),
          label: const Text('Generate PDF'),
          icon: const Icon(Icons.picture_as_pdf),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ]),
    );
  }
}

  
  