import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:lottie/lottie.dart';
import 'package:medical_assistant/commons/constants.dart';
import 'package:medical_assistant/commons/utils.dart';
import 'package:medical_assistant/modules/doctors/session/screens/sessionresults_screen.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../models/report.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final SpeechToText _speechToText = SpeechToText();
  Gemini gemini = Gemini.instance;
  bool _isLoading = false;
  Report? report;

  bool _isMicOn = false;
  String _lastWords = '';
  String res = '';
  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: _isLoading
            ? LottieBuilder.asset(
                'assets/analyzing.json',
                height: 300,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isMicOn
                      ? Column(
                          children: [
                            Text(
                              'Go on...',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            LottieBuilder.asset('assets/recording.json'),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white),
                                onPressed: () async {
                                  _stopListening();
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  try {
                                    final response = await gemini.text(
                                      _lastWords + PROMPT,
                                    );

                                    if (response != null &&
                                        response.content != null) {
                                      String content =
                                          response.content.toString();

                                      // Sanitize the input JSON string
                                      if (content.startsWith(
                                          'Content(parts: [Parts(text:')) {
                                        final startIndex = content.indexOf('{');
                                        final endIndex =
                                            content.lastIndexOf('}');
                                        if (startIndex != -1 &&
                                            endIndex != -1) {
                                          content = content.substring(
                                              startIndex, endIndex + 1);
                                        }
                                      }

                                      final jsonResponse = json.decode(content);
                                      report = Report.fromMap(jsonResponse);

                                      print(report?.description);
                                      // Do something with the report, e.g., save it, display it, etc.
                                    } else {
                                      print('No result from API');
                                      showSnackBar(
                                          context, 'No result from API');
                                    }
                                  } catch (e) {
                                    print(e);
                                    showSnackBar(context, e.toString());
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          SessionResultScreen(
                                            report: report ?? Report(),
                                          )),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.stop),
                                label: Text('Generate')),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              'Start Session',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            IconButton(
                                onPressed: () {
                                  SystemSound.play(SystemSoundType.click);
                                  setState(() {
                                    _isMicOn = !_isMicOn;
                                  });
                                  _startListening();
                                },
                                icon: Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                  size: 50,
                                )),
                          ],
                        )
                ],
              ),
      ),
    );
  }
}
