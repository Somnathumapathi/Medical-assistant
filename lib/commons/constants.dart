import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final firebaseAuth = FirebaseAuth.instance;
final fireStore = FirebaseFirestore.instance;

final PROMPT =
    """This is the speech to text result of the doctor. For this, please provide a JSON report summarizing the patient's medical condition and prescribed medications based on this speech-to-text (STT) output. 
1. Disease Information:
   - Extract the medical diagnosis of the patient.
   - Provide a detailed description of the diagnosis in layman terms, including symptoms and any relevant medical history.

2. Medication Details:
   - Extract information about each medication prescribed to the patient.
   - For each medication, include:
     - The name of the medication.
     - A list of boolean values representing the medication intake schedule for each time slot of the day (e.g., [true, false, true] for morning and evening doses).
     - Detailed instructions on how to take the medication, including dosage and any special instructions.

The JSON output should be structured as follows:
{
  \"disease\": {
    \"medicalDiagnosis\": \"Medical diagnosis of the patient.\",
    \"descriptionLayman\": \"Description of the diagnosis in layman terms, including symptoms and any relevant medical history.\"
  },
  \"medications\": [
    {
      \"mName\": \"Name of the medication.\",
      \"mTime\": [true, false, true],
      \"mDuration\":\"Duration of medication\",
      \"mInstructions\": \"Detailed instructions on how to take the medication, including dosage and any special instructions.\"
    }
  ]
}
""";
