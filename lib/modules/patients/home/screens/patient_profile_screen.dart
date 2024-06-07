import 'package:flutter/material.dart';
import 'package:medical_assistant/commons/constants.dart';
import 'package:medical_assistant/modules/auth/screens/login_screen.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
          onPressed: () async {
            await firebaseAuth.signOut();
            Navigator.popUntil(context, (route) => false);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          child: Text('Sign out')),
    );
  }
}
