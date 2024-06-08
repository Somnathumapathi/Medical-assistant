// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:medical_assistant/models/medication.dart';

class Report {
  String? rId;
  String? rLink;
  DateTime? startDate;
  DateTime? endTime;
  String? hospitalName;
  String? doctorName;
  String? patientName;
  String? description;
  // final List<String> videoLinks;
  String? medicalDiagnosis;
  List<Medication>? medications;

  Report(
      {this.rId,
      this.rLink,
      this.startDate,
      this.endTime,
      this.hospitalName,
      this.doctorName,
      this.patientName,
      this.description,
      this.medicalDiagnosis,
      // required this.videoLinks,
      this.medications});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rId': rId,
      'rLink': rLink,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'hospitalName': hospitalName,
      'doctorName': doctorName,
      'patientName': patientName,
      'description': description,
      // 'videoLinks': videoLinks,
      'medications': medications!.map((x) => x.toMap()).toList(),
    };
  }

  factory Report.fFromMap(Map<String, dynamic> map) {
    return Report(
      rId: map['rId'] as String?,
      rLink: map['rLink'] as String?,
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : null,
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int)
          : null,
      hospitalName: map['hospitalName'] as String?,
      doctorName: map['doctorName'] as String?,
      patientName: map['patientName'] as String?,
      description: map['description'] as String?,
      medicalDiagnosis: map['medicalDiagnosis'] as String?,
      medications: map['medications'] != null
          ? List<Medication>.from(
              (map['medications'] as List)
                  .map((x) => Medication.fromMap(x as Map<String, dynamic>)),
            )
          : null,
    );
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      rId: (map['rId'])?.toString(),
      rLink: (map['rLink'])?.toString(),
      // startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      // endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : null,
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int)
          : null,
      hospitalName: 'Jayadeva Hospital',
      doctorName: map['doctorName'] != null ? map['doctorName'] as String : '',

      patientName:
          map['patientName'] != null ? map['patientName'] as String : '',

      description: map['disease']['descriptionLayman'] as String,
      medicalDiagnosis: map['disease']['medicalDiagnosis'] as String,
      // videoLinks:  List<String>.from((map['videoLinks'] as List<String>),),
      medications: List<Medication>.from(
        (map['medications'] as List).map((x) => Medication.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);
}
// class Report {
//   final String medicalDiagnosis;
//   final String description;
//   final List<Medication> medications;

//   Report({
//     required this.medicalDiagnosis,
//     required this.description,
//     required this.medications,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'medicalDiagnosis': medicalDiagnosis,
//       'description': description,
//       'medications': medications.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory Report.fromMap(Map<String, dynamic> map) {
//     return Report(
//       medicalDiagnosis: map['disease']['medicalDiagnosis'] as String,
//       description: map['disease']['descriptionLayman'] as String,
//       medications: List<Medication>.from(
//         (map['medications'] as List).map((x) => Medication.fromMap(x)),
//       ),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Report.fromJson(String source) =>
//       Report.fromMap(json.decode(source) as Map<String, dynamic>);
// }
