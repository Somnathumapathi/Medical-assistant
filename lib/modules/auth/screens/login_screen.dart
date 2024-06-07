import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_assistant/commons/utils.dart';
import 'package:medical_assistant/models/doctor.dart';
import 'package:medical_assistant/models/patient.dart';
import 'package:medical_assistant/modules/doctors/home/screens/doctor_home_screen.dart';
import 'package:medical_assistant/modules/auth/screens/register_screen.dart';
import 'package:medical_assistant/providers/doctor_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../commons/constants.dart';
import '../../../providers/patient_provider.dart';
import '../../patients/home/screens/patient_home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  // final String phone = '';
  String? _verificationCode;
  bool _isPatient = true;
  bool _isOtpSent = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _phoneController.dispose();
    _otpController.dispose();
  }

  void login(
      {required String email,
      required String password,
      required bool isPatient}) async {
    try {
      final UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final uid = userCred.user!.uid;
      print(uid);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('x-uid', uid);

      // final cRef = fireStore.collection(isPatient?'Patient':'Doctor');
      //  final _patient = Patient(
      //     pId: uid,
      //     pName: ,
      //     pMail: '',
      //     reports: [],
      //     breakfastTime: '',
      //     lunchTime: '',
      //     dinnerTime: '',
      //     language: '',
      //     careTakerNo: caretakerNumber);
      // final _doctor = Doctor(dname: name, dId: uid, dMail: email);

      final qsnap = await fireStore
          .collection(isPatient ? 'Patient' : 'Doctor')
          .doc('$uid')
          .get();

      final data = qsnap.data();
      print(data);
      if (data != null) {
        if (isPatient) {
          final _patient = Patient.fromMap(data);
          await prefs.setString('role', 'Patient');
          ref.read(patientProvider).setPatient(_patient);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PatientHomeScreen()));
        } else {
          await prefs.setString('role', 'Doctor');
          final _doctor = Doctor.fromMap(data);
          ref.read(doctorProvider).setDoctor(_doctor);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DoctorHomeScreen()));
        }
      } else {
        showSnackBar(context, 'No user');
      }

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: ((context) =>
      //             isPatient ? PatientHomeScreen() : DoctorHomeScreen())));
    } catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _scwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Doctor',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                width: 25,
              ),
              Switch(
                  value: _isPatient,
                  activeColor: Colors.orange,
                  onChanged: (value) {
                    setState(() {
                      _isPatient = value;
                    });
                    print(_isPatient);
                  }),
              const SizedBox(
                width: 25,
              ),
              const Text(
                'Patient',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 81, 100, 207),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isPatient ? 'PATIENT LOGIN' : 'DOCTOR LOGIN',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                // TextFormField(
                //   controller: _phoneController,
                //   keyboardType: const TextInputType.numberWithOptions(),
                //   decoration: InputDecoration(
                //     hintText: 'Enter Phone Number',
                //     hintStyle: TextStyle(
                //       color: Colors.white.withAlpha(100),
                //     ),
                //   ),
                //   style: const TextStyle(
                //     color: Colors.white,
                //   ),
                // ),
                TextFormField(
                  controller: _emailcontroller,
                  // keyboardType: const TextInputType.num,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    hintStyle: TextStyle(
                      color: Colors.white.withAlpha(100),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  // keyboardType: const TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    hintStyle: TextStyle(
                      color: Colors.white.withAlpha(100),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () => login(
                        email: _emailcontroller.text,
                        password: _passwordController.text,
                        isPatient: _isPatient),
                    child: Text('Login')),
                // _isOtpSent
                //     ? TextFormField(
                //         controller: _otpController,
                //         keyboardType: TextInputType.number,
                //         onFieldSubmitted: (pin) async {
                //           await _verifyOtp(pin);
                //         },
                //         decoration: InputDecoration(
                //           hintText: 'Enter OTP',
                //           hintStyle: TextStyle(
                //             color: Colors.white.withAlpha(100),
                //           ),
                //         ),
                //         style: const TextStyle(
                //           color: Colors.white,
                //         ),
                //       )
                //     : const SizedBox.shrink(),
                // _isOtpSent
                //     ? ElevatedButton(
                //         onPressed: () {},
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.indigo,
                //             foregroundColor: Colors.white),
                //         child: const Text('Login'),
                //       )
                //     : ElevatedButton(
                //         onPressed: () async {
                //           await _verifyOtp(_otpController.text);
                //           setState(() {
                //             //          Navigator.of(context).push(MaterialPageRoute(
                //             // builder: (context) => LoginScreen(_phoneController.text)));
                //             _isOtpSent = true;
                //           });
                //         },
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.indigo,
                //             foregroundColor: Colors.white),
                //         child: const Text('Send OTP'),
                //       ),
                // const SizedBox(
                //   height: 15,
                // ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _verifyOtp(String pin) async {
    try {
      debugPrint("reached1");
      _verificationCode = _otpController.text;
      await firebaseAuth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationCode!, smsCode: pin))
          .then((value) async {
        if (value.user != null) {
          debugPrint("reached2");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
              (route) => false);
        }
      });
    } catch (e) {
      debugPrint("reached3");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _verifyPhone() async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91${_phoneController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message!)));
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 120),
      );
    } catch (e) {
      debugPrint("reached3");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    // _verifyPhone();
  }
}
