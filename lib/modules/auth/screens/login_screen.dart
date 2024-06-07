import 'package:flutter/material.dart';

import '../../../commons/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isPatient = true;
  bool _isOtpSent = false;
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
                const Text(
                  'LOGIN',
                  style: TextStyle(
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
                _isOtpSent
                    ? TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
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
                        onPressed: () async {
                          // await firebaseAuth.verifyPhoneNumber(verificationCompleted: verificationCompleted, verificationFailed: verificationFailed, codeSent: codeSent, codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
                          setState(() {
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
                    onPressed: () {},
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
}
