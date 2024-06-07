import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medical_assistant/commons/constants.dart';
import 'package:medical_assistant/models/doctor.dart';
import 'package:medical_assistant/models/patient.dart';
import 'package:medical_assistant/modules/auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_assistant/modules/doctors/home/screens/doctor_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();
  final _caretakerController = TextEditingController();
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
    _nameController.dispose();
    _caretakerController.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    // _verifyPhone();
  }

  _verifyPhone() async {
    try{
      debugPrint("reached in verifyphone");
        await firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+91${_phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential).then((value) async {
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
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
    }
    catch(e){
      debugPrint("inside verify phone catch");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }    
  }

  Future<void> _verifyOtp(String pin) async {
    try {
      debugPrint("reached1");
      _verificationCode = _otpController.text;
      final cred = await firebaseAuth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationCode!, smsCode: pin))
          .then((value) async {
        if (value.user != null) {
          debugPrint("reached2");
          final prefs = await SharedPreferences.getInstance();

            await prefs.setString('phNumber', '${_phoneController.text}');
            await prefs.setString('x-id', value.user!.uid);
            final firestore = FirebaseFirestore.instance;
            final _patient = Patient(pId: '', pName: _nameController.text, reports: [], breakfastTime: '', lunchTime: '', dinnerTime: '', language: '', careTakerNo: _caretakerController.text, pNo: _phoneController.text);
            final _doctor = Doctor(dname: _nameController.text, dId: '', dNumber: _phoneController.text);
            final ref = firestore.collection(_isPatient?'Patient':"Doctor").add(_isPatient?_patient.toMap():_doctor.toMap());
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
              (route) => false);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
                  _isPatient? 'PATIENT REGISTER' : 'DOCTOR REGISTER',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    hintText: 'Enter Phone Number',
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
                _isPatient?
                Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Patient Name',
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
                    TextFormField(
                      controller: _caretakerController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        hintText: 'Enter Caretaker Phone Number',
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
                  ],
                ):
                Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Doctor Name',
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
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                _isOtpSent
                    ? TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (pin) async {
                        await _verifyOtp(pin);
                      },
                        decoration: InputDecoration(
                          hintText: 'Enter OTP',
                          hintStyle: TextStyle(
                            color: Colors.white.withAlpha(100),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox.shrink(),
                _isOtpSent
                    ? ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white),
                        child: const Text('Login'),
                      )
                    : ElevatedButton(
                        onPressed: () async 
                        {
                          await _verifyOtp(_otpController.text);
                          setState(() {
                    //          Navigator.of(context).push(MaterialPageRoute(
                    // builder: (context) => LoginScreen(_phoneController.text)));
                            _isOtpSent = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white),
                        child: const Text('Send OTP'),
                      ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen() ),
                  );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
  
}

