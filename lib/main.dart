import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_assistant/commons/constants.dart';
import 'package:medical_assistant/modules/auth/screens/login_screen.dart';
import 'package:medical_assistant/modules/doctors/home/screens/doctor_home_screen.dart';
import 'package:medical_assistant/modules/patients/home/screens/patient_home_screen.dart';
import 'package:medical_assistant/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription>? cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  Gemini.init(apiKey: API_KEY);
  cameras = await availableCameras();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String? role;

  _init() async {
    final prefs = await SharedPreferences.getInstance();
    role = await prefs.getString('role');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // final prefs = await Sharedpre
      // final role =
      home: firebaseAuth.currentUser != null
          ? role == 'Patient'
              ? PatientHomeScreen()
              : DoctorHomeScreen()
          : LoginScreen(),
    );
  }
}
