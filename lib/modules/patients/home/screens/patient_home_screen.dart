import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:medical_assistant/modules/patients/home/screens/patient_profile_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int _screenIdx = 1;
  getBody(double screenWidth, double screenHeight) {
    if (_screenIdx == 0) {
      return const PatientProfileScreen();
    } else if (_screenIdx == 1) {
      return Center(
        child: Text('Home'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _scWidth = MediaQuery.of(context).size.width;
    final _scHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(
          'Medical Assistant',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ))
        ],
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: getBody(_scWidth, _scHeight),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(
            Icons.person,
            color: Colors.orangeAccent,
          ),
          Icon(
            Icons.home,
            color: Colors.orangeAccent,
          ),
          Icon(
            Icons.receipt_long_rounded,
            color: Colors.orangeAccent,
          ),
        ],
        index: _screenIdx,
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        color: const Color.fromARGB(255, 15, 119, 205),
        backgroundColor: Colors.blue,
        onTap: (value) {
          setState(() {
            _screenIdx = value;
          });
        },
      ),
    );
  }
}
