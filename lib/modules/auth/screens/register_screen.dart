import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_assistant/commons/constants.dart';
import 'package:medical_assistant/commons/utils.dart';
import 'package:medical_assistant/models/doctor.dart';
import 'package:medical_assistant/models/patient.dart';
import 'package:medical_assistant/modules/auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_assistant/modules/doctors/home/screens/doctor_home_screen.dart';
import 'package:medical_assistant/modules/patients/home/screens/patient_home_screen.dart';
import 'package:medical_assistant/providers/doctor_provider.dart';
import 'package:medical_assistant/providers/patient_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();
  final _caretakerController = TextEditingController();
  final _emailController = TextEditingController();
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
    _nameController.dispose();
    _caretakerController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _verifyPhone();
  }

  void signup(
      {required String email,
      required String password,
      required String name,
      required String caretakerNumber,
      required bool isPatient}) async {
    try {
      final UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCred.user!.uid;
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('email', email);
      // await prefs.setString('x-id', uid);
      final _patient = Patient(
          pId: uid,
          pName: name,
          pMail: '',
          reports: [],
          breakfastTime: '',
          lunchTime: '',
          dinnerTime: '',
          language: '',
          careTakerNo: caretakerNumber);
      final _doctor = Doctor(dname: name, dId: uid, dMail: email);
      final docref = await fireStore
          .collection(isPatient ? 'Patient' : 'Doctor')
          .doc(uid)
          .set(isPatient ? _patient.toMap() : _doctor.toMap());
      // isPatient
      //     ? ref.read(patientProvider).setPatient(_patient)
      //     : ref.read(doctorProvider).setDoctor(_doctor);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: ((context) =>
      //             isPatient ? PatientHomeScreen() : DoctorHomeScreen())));
      showSnackBar(context, 'Account Created');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      // print(e);
      showSnackBar(context, e.toString());
    }
  }

  _verifyPhone() async {
    try {
      debugPrint("reached in verifyphone");
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
      debugPrint("inside verify phone catch");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  //  Future<void> signUpWithMobileAndPassword() async {
  //   // String phoneNumber = "+${selectedCountry.phoneCode}${mobilenosignup.text}";
  //   TextEditingController otpcontroller = TextEditingController();

  //     try {
  //       await FirebaseAuth.instance.verifyPhoneNumber(
  //         phoneNumber: _phoneController.text,
  //         verificationCompleted: (PhoneAuthCredential credential) async {
  //           await FirebaseAuth.instance
  //               .signInWithCredential(credential)
  //               .then((userCredential) async {});
  //         },
  //         verificationFailed: (FirebaseAuthException e) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text('Verification failed: ${e.message}'),
  //             ),
  //           );
  //         },
  //         codeSent: (String verificationId, int? resendToken) {
  //           showOTPDialog(
  //             context: context,
  //             otpcontroller: otpcontroller,
  //             onPressed: () async {
  //               PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //                 verificationId: verificationId,
  //                 smsCode: otpcontroller.text.trim(),
  //               );

  //               });
  //             },
  //           );
  //         },
  //         codeAutoRetrievalTimeout: (String verificationId) {},
  //       );
  //     } catch (e) {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: const Text('Sign Up Error'),
  //             content: const Text(
  //               'An error occurred while signing up. Please try again.',
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('OK'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  // }

  Future<void> _verifyOtp(String pin) async {
    try {
      debugPrint("reached1");
      _verificationCode = _otpController.text;
      // final cred = await firebaseAuth
      //     .signInWithCredential(PhoneAuthProvider.credential(
      //         verificationId: _verificationCode!, smsCode: pin, )
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationCode!,
        smsCode: pin,
      );
      debugPrint("ahsd");
      await firebaseAuth.signInWithCredential(credential).then(
          (userCredential) async {
        String uid = userCredential.user!.uid;
        // debugPrint("ahsd");
        // if (value.user != null) {
        debugPrint("reached2");
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('phNumber', '${_phoneController.text}');
        await prefs.setString('x-id', uid);
        final firestore = FirebaseFirestore.instance;
        final _patient = Patient(
            pId: '',
            pName: _nameController.text,
            reports: [],
            breakfastTime: '',
            lunchTime: '',
            dinnerTime: '',
            language: '',
            careTakerNo: _caretakerController.text,
            pMail: _phoneController.text);
        final _doctor = Doctor(
            dname: _nameController.text, dId: '', dMail: _phoneController.text);
        print('reeeee');
        final ref = await firestore
            .collection(_isPatient ? 'Patient' : "Doctor")
            .add(_isPatient ? _patient.toMap() : _doctor.toMap());

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
            (route) => false);
      }
          // }
          // .then((value) async {
          //   if (value.user != null) {
          //     debugPrint("reached2");
          //     final prefs = await SharedPreferences.getInstance();

          //       await prefs.setString('phNumber', '${_phoneController.text}');
          //       await prefs.setString('x-id', value.user!.uid);
          //       final firestore = FirebaseFirestore.instance;
          //       final _patient = Patient(pId: '', pName: _nameController.text, reports: [], breakfastTime: '', lunchTime: '', dinnerTime: '', language: '', careTakerNo: _caretakerController.text, pNo: _phoneController.text);
          //       final _doctor = Doctor(dname: _nameController.text, dId: '', dMail: _phoneController.text);
          //       print('reeeee');
          //       final ref = await firestore.collection(_isPatient?'Patient':"Doctor").add(_isPatient?_patient.toMap():_doctor.toMap());

          //     Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
          //         (route) => false);
          //   }
          // }

          );
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
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
                  _isPatient ? 'PATIENT REGISTER' : 'DOCTOR REGISTER',
                  style: const TextStyle(
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
                  controller: _emailController,
                  // keyboardType: const TextInputType.numberWithOptions(),
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
                _isPatient
                    ? Column(
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
                            keyboardType:
                                const TextInputType.numberWithOptions(),
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
                      )
                    : Column(
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
                ElevatedButton(
                    onPressed: () {
                      signup(
                          isPatient: _isPatient,
                          email: _emailController.text,
                          password: _passwordController.text,
                          name: _nameController.text,
                          caretakerNumber: _caretakerController.text);
                    },
                    child: Text('Register')),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
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
