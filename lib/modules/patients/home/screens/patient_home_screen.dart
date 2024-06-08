import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_assistant/modules/patients/home/screens/patient_monitoring_screen.dart';
import 'package:medical_assistant/modules/patients/home/screens/patient_profile_screen.dart';
import 'package:medical_assistant/modules/patients/home/screens/patiet_reports_screen.dart';
import 'package:medical_assistant/providers/patient_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../commons/constants.dart';
import '../../../../models/patient.dart';

class PatientHomeScreen extends ConsumerStatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  ConsumerState<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends ConsumerState<PatientHomeScreen> {
  void getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = await prefs.getString('x-uid');
    final qsnap = await fireStore.collection('Patient').doc(uid).get();

    final data = qsnap.data();
    final _patient = Patient.fromMap(data!);
    await prefs.setString('role', 'Patient');
    ref.read(patientProvider).setPatient(_patient);
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  int _screenIdx = 1;
  getBody(double screenWidth, double screenHeight) {
    if (_screenIdx == 0) {
      return const PatientProfileScreen();
    } else if (_screenIdx == 1) {
      return Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          children: [
            CarouselSlider(
                items: [
                  Image.network(
                      'https://www.northwestcareercollege.edu/wp-content/uploads/2022/06/Medical-Assisting-qualification-1.webp'),
                  Image.network(
                      'https://www.careeraddict.com/uploads/article/58344/illustrated-medical_assistant-xrays-doctor.jpg')
                ],
                options: CarouselOptions(
                  autoPlay: true,
                  height: 200,
                  enlargeCenterPage: true,
                ))
          ],
        ),
      );
    } else if (_screenIdx == 2) {
      return const PatientMonitoringScreen();
    } else if (_screenIdx == 3) {
      return const PatientReportsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _scWidth = MediaQuery.of(context).size.width;
    final _scHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          'Medical Assistant',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ))
        ],
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: getBody(_scWidth, _scHeight),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(
            Icons.person,
            color: Colors.orangeAccent,
          ),
          Icon(
            Icons.home,
            color: Colors.orangeAccent,
          ),
          Icon(
            Icons.remove_red_eye,
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
