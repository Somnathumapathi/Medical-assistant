import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_assistant/commons/constants.dart';
import 'package:medical_assistant/commons/utils.dart';
import 'package:medical_assistant/models/medication.dart';
import 'package:medical_assistant/models/report.dart';
import 'package:medical_assistant/providers/doctor_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';


class SessionResultScreen extends ConsumerStatefulWidget {
  const SessionResultScreen({super.key, required this.report});
  final Report report;

  @override
  ConsumerState<SessionResultScreen> createState() => _SessionResultScreenState();
}

class _SessionResultScreenState extends ConsumerState<SessionResultScreen> {
  late TextEditingController _resultController;
  final _durationController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _patientEmailController = TextEditingController();
  final reportCollection = FirebaseFirestore.instance;
  String? result;

  @override
  void initState() {
    super.initState();
    _generateResultText();
    _resultController = TextEditingController(text: result);
  }

  @override
  void dispose() {
    _resultController.dispose();
    _durationController.dispose();
    _patientNameController.dispose();
    _patientEmailController.dispose();
    super.dispose();
  }

  void _generateResultText() {
    final medicalDiagnosis = widget.report.medicalDiagnosis ?? 'N/A';
    final description = widget.report.description ?? 'No description available';
    final medications = widget.report.medications?.map((medication) {
      return '''
      Name: ${medication.mName}
      Times: ${medication.mTime.asMap().entries.map((entry) {
        final index = entry.key;
        final time = entry.value;
        final meal = index == 0 ? 'breakfast' : index == 1 ? 'lunch' : 'dinner';
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

  Future<Report> _reportGeneration({required String doctorName, required int duration}) async {
    final _report = Report(
      startDate: DateTime.now(),
      endTime: DateTime.now().add(Duration(days: duration)),
      patientName: _patientNameController.text,
      description: widget.report.description,
      medicalDiagnosis: widget.report.medicalDiagnosis,
      hospitalName: widget.report.hospitalName,
      doctorName: doctorName,
      medications: widget.report.medications,
    );

    final dRef = await reportCollection.collection("Reports").add(_report.toMap());
    final dSnap = await reportCollection.collection('Patient')
      .where('pMail', isEqualTo: _patientEmailController.text)
      .get();
    final docRef = dSnap.docs.first.reference;
    await docRef.update({'reports': FieldValue.arrayUnion([dRef])});
    return _report;
  }

  Future<void> createPDF(String finalReport) async {
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
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                // Add the report content
                pw.Text(finalReport),
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


  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      return result == PermissionStatus.granted;
    }
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
                  color: Color.fromARGB(255, 91, 106, 191),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.indigo.withOpacity(0.26),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                  controller: _resultController,
                  maxLines: 20,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Enter patient name:",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 91, 106, 191),
                ),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: InputDecoration(hintText: "Enter Patient Name"),
                  controller: _patientNameController,
                ),
              ),
              SizedBox(height: 10),
              const Text(
                "Enter patient email:",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 91, 106, 191),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: const InputDecoration(hintText: "Enter Patient Email"),
                  controller: _patientEmailController,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final _dur = int.tryParse(widget.report.medications![0].mDuration.split(' ')[0]) ?? 3;
                    _generateResultText(); // Ensure the result is generated before creating the PDF
                    await createPDF(result!); // Use the createPDF function to generate the PDF
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('PDF Generated Successfully!'),
                    ));
                  } catch (e) {
                    print('Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Failed to generate PDF'),
                    ));
                  }
                },
                label: const Text('Generate PDF'),
                icon: const Icon(Icons.edit_document),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class SessionResultScreen extends ConsumerStatefulWidget {
//   const SessionResultScreen({super.key, required this.report});
//   final Report report;
  
//   @override
//   ConsumerState<SessionResultScreen> createState() => _SessionResultScreenState();
// }

// class _SessionResultScreenState extends ConsumerState<SessionResultScreen> {
//   late TextEditingController _resultController;
//   final _durationController = TextEditingController();
//   final _patientNameController = TextEditingController();
//   final _patientEmailController = TextEditingController();
//   final reportCollection = FirebaseFirestore.instance;
//   String? result;

//  _reportGeneration({required String doctorName, required int duration}) async{
//     final _report = Report(startDate: DateTime.now(), endTime: DateTime.now().add(Duration(days: duration)), patientName: _patientNameController.text, description: widget.report.description, medicalDiagnosis: widget.report.medicalDiagnosis,hospitalName: widget.report.hospitalName, doctorName: doctorName,medications: widget.report.medications,
//     );
//     final dRef = await fireStore.collection("Reports").add(_report.toMap());
//     final dSnap = await fireStore.collection('Patient').where('pMail', isEqualTo: _patientEmailController.text).get();
//     final docref = dSnap.docs.first.reference;
//     await docref.update({'reports': FieldValue.arrayUnion([dRef])});
//     return _report;
//     }


//   void _generateResultText() {
//     final medicalDiagnosis = widget.report.medicalDiagnosis ?? 'N/A';
//     final description = widget.report.description ?? 'No description available';
//     final medications = widget.report.medications?.map((medication) {
//           return '''
//       Name: ${medication.mName}
//       Times: ${medication.mTime.map((time) => time ? 'Yes' : 'No').join(', ')}
//       Duration: ${medication.mDuration}
//       Instructions: ${medication.mInstructions}
//             ''';
//               }).join('\n\n') ??
//               'No medications available';

//           result = '''
//       Medical Diagnosis: $medicalDiagnosis

//       Description: $description

//       Medications:
//       $medications
//           ''';
//         }

//   @override
//   void initState() {
//     _generateResultText();
//     _resultController = TextEditingController(text: result);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _resultController.dispose();
//     _durationController.dispose();
//     _patientNameController.dispose();
//     _patientEmailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.indigo,
//       appBar: AppBar(
//         title: Text('Result'),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//             child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color.fromARGB(255, 91, 106, 191)),
//               child: TextFormField(
//                 decoration:
//                     InputDecoration(fillColor: Colors.indigo.withOpacity(0.26)),
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w300),
//                 controller: _resultController,
//                 maxLines: 20,
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Text(
//               "Enter patient name:",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             Container(
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color.fromARGB(255, 91, 106, 191)),
//               child: TextFormField(
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w300),
//                 decoration: InputDecoration(hintText: "Enter Patient Name"),
//                 controller: _patientNameController,
//                 //keyboardType: TextInputType.numberWithOptions(),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             const Text(
//               "Enter patient email:",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             Container(
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: const Color.fromARGB(255, 91, 106, 191)),
//               child: TextFormField(
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w300),
//                 decoration: const InputDecoration(hintText: "Enter Patient Email"),
//                 controller: _patientEmailController,
//                 //keyboardType: TextInputType.numberWithOptions(),
//               ),
//             ),
//             ElevatedButton.icon(
//               onPressed: () async {                
//                 try {
//                     final _dur = int.tryParse(widget.report.medications![0].mDuration.split(' ')[0])??3;
//                     print(_dur);
//                     print(ref.watch(doctorProvider).doctor!.dname);       
//                     debugPrint("reached1");                                 
//                     final finalReport = _reportGeneration(doctorName: ref.watch(doctorProvider).doctor!.dname, duration: _dur);
//                     debugPrint("reached2");       
//                     await createPDF(finalReport);
//                     debugPrint("reached3");       
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                       content: Text('PDF Generated Successfully!'),
//                     ));
//                   } catch (e) {
//                     print('Error: $e');
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                       content: Text('Failed to generate PDF'),
//                     ));
//                   }

//               },
//               label: const Text('Generate PDF'),
//               icon: const Icon(Icons.edit_document),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red, foregroundColor: Colors.white),
//             ),
//           ],
//         )),
//       ),
//     );
//   }

//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       final result = await permission.request();
//       return result == PermissionStatus.granted;
//     }
//   }
//   Future<void> createPDF(finalReport) async {
//     try {
// final pdf = pw.Document();
// print('r1');
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Text(finalReport),
//           ); // Center
//         },
//       ),
//     );
//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/example.pdf");
//     await file.writeAsBytes(await pdf.save());

//     print('PDF saved to: ${file.path}');

//     // Open the PDF file
//     await OpenFile.open(file.path);
//     } catch (e) {
//       print(e.toString());
//       showSnackBar(context, e.toString());
//     }
    

//     // Save the PDF file to the device
    
//   }
// } how do i format the pdf before generating it?


// class SessionResultScreen extends ConsumerStatefulWidget {
//   const SessionResultScreen({super.key, required this.report});
//   final Report report;
  
//   @override
//   ConsumerState<SessionResultScreen> createState() => _SessionResultScreenState();
// }

// class _SessionResultScreenState extends ConsumerState<SessionResultScreen> {
//   late TextEditingController _resultController;
//   final _durationController = TextEditingController();
//   final _patientNameController = TextEditingController();
//   final _patientEmailController = TextEditingController();
//   final reportCollection = FirebaseFirestore.instance;
//   String? result;

//  _reportGeneration({required String doctorName, required int duration}) async{
//     final _report = Report(startDate: DateTime.now(), endTime: DateTime.now().add(Duration(days: duration)), patientName: _patientNameController.text, description: widget.report.description, medicalDiagnosis: widget.report.medicalDiagnosis,hospitalName: widget.report.hospitalName, doctorName: doctorName,medications: widget.report.medications,
//     );
//     final dRef = await fireStore.collection("Reports").add(_report.toMap());
//     final dSnap = await fireStore.collection('Patient').where('pMail', isEqualTo: _patientEmailController.text).get();
//     final docref = dSnap.docs.first.reference;
//     await docref.update({'reports': FieldValue.arrayUnion([dRef])});
//     return _report;
//     }


//   void _generateResultText() {
//     final medicalDiagnosis = widget.report.medicalDiagnosis ?? 'N/A';
//     final description = widget.report.description ?? 'No description available';
//     final medications = widget.report.medications?.map((medication) {
//           return '''
//       Name: ${medication.mName}
//       Times: ${medication.mTime.map((time) => time ? 'Yes' : 'No').join(', ')}
//       Duration: ${medication.mDuration}
//       Instructions: ${medication.mInstructions}
//             ''';
//               }).join('\n\n') ??
//               'No medications available';

//           result = '''
//       Medical Diagnosis: $medicalDiagnosis

//       Description: $description

//       Medications:
//       $medications
//           ''';
//         }

//   @override
//   void initState() {
//     _generateResultText();
//     _resultController = TextEditingController(text: result);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _resultController.dispose();
//     _durationController.dispose();
//     _patientNameController.dispose();
//     _patientEmailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.indigo,
//       appBar: AppBar(
//         title: Text('Result'),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//             child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color.fromARGB(255, 91, 106, 191)),
//               child: TextFormField(
//                 decoration:
//                     InputDecoration(fillColor: Colors.indigo.withOpacity(0.26)),
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w300),
//                 controller: _resultController,
//                 maxLines: 20,
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Text(
//               "Enter patient name:",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             Container(
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color.fromARGB(255, 91, 106, 191)),
//               child: TextFormField(
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w300),
//                 decoration: InputDecoration(hintText: "Enter Patient Name"),
//                 controller: _patientNameController,
//                 //keyboardType: TextInputType.numberWithOptions(),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             const Text(
//               "Enter patient email:",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             Container(
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: const Color.fromARGB(255, 91, 106, 191)),
//               child: TextFormField(
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w300),
//                 decoration: const InputDecoration(hintText: "Enter Patient Email"),
//                 controller: _patientEmailController,
//                 //keyboardType: TextInputType.numberWithOptions(),
//               ),
//             ),
//             ElevatedButton.icon(
//               onPressed: () async {                
//                 try {
//                     final _dur = int.tryParse(widget.report.medications![0].mDuration.split(' ')[0])??3;
//                     print(_dur);
//                     print(ref.watch(doctorProvider).doctor!.dname);       
//                     debugPrint("reached1");                                 
//                     final finalReport = _reportGeneration(doctorName: ref.watch(doctorProvider).doctor!.dname, duration: _dur);
//                     debugPrint("reached2");       
//                     await createPDF(finalReport);
//                     debugPrint("reached3");       
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                       content: Text('PDF Generated Successfully!'),
//                     ));
//                   } catch (e) {
//                     print('Error: $e');
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                       content: Text('Failed to generate PDF'),
//                     ));
//                   }

//               },
//               label: const Text('Generate PDF'),
//               icon: const Icon(Icons.edit_document),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red, foregroundColor: Colors.white),
//             ),
//           ],
//         )),
//       ),
//     );
//   }

//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       final result = await permission.request();
//       return result == PermissionStatus.granted;
//     }
//   }
//   Future<void> createPDF(finalReport) async {
//     try {
// final pdf = pw.Document();
// print('r1');
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Text(finalReport),
//           ); // Center
//         },
//       ),
//     );
//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/example.pdf");
//     await file.writeAsBytes(await pdf.save());

//     print('PDF saved to: ${file.path}');

//     // Open the PDF file
//     await OpenFile.open(file.path);
//     } catch (e) {
//       print(e.toString());
//       showSnackBar(context, e.toString());
//     }
    

//     // Save the PDF file to the device
    
//   }
// }