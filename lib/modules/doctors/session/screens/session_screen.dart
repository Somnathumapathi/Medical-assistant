import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:lottie/lottie.dart';
import 'package:medical_assistant/modules/doctors/session/screens/sessionresults_screen.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final SpeechToText _speechToText = SpeechToText();
  Gemini gemini = Gemini.instance;

  bool _isMicOn = false;
  String _lastWords = '';
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
        child: Column(
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
                          onPressed: () {
                            _stopListening();
                            gemini
                                .text(
                                    "Give me some illness and tablet names in json format make it as precise as possible")
                                .then((value) => print(value?.output))
                                .catchError((e) => print(e));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => SessionResultScreen(
                                        speechResult: _lastWords))));
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
