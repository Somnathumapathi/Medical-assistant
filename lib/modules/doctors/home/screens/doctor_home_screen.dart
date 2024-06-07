import 'package:flutter/material.dart';
import 'package:medical_assistant/modules/doctors/session/screens/session_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: Center(child: Text('Home')),
        // bottomNavigationBar: ,
        floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SessionScreen()));
        }));
  }
}
