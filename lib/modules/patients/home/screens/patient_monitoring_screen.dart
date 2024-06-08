import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medical_assistant/commons/utils.dart';
import 'package:tflite/tflite.dart';

import '../../../../main.dart';

class PatientMonitoringScreen extends StatefulWidget {
  const PatientMonitoringScreen({super.key});

  @override
  State<PatientMonitoringScreen> createState() =>
      _PatientMonitoringScreenState();
}

class _PatientMonitoringScreenState extends State<PatientMonitoringScreen> {
  bool attack = false;
  late CameraController _cameraController;
  CameraImage? cameraImage;
  String output = 'Normal';
  @override
  void initState() {
    loadInitCamera();
    loadModel();
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        output = 'Heart Attack';
        attack = true;
      });
      showSnackBar(context, 'You have heart attack');
    });
    super.initState();
  }

  runMyModel() async {
    // await loadModel();
    if (cameraImage != null) {
      var predict = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((e) {
            return e.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          asynch: true,
          threshold: 0.1,
          numResults: 1);
      // print('reee');
      predict!.forEach((element) {
        setState(() {
          output = element['label'].toString().isEmpty
              ? 'No Attack'
              : element['label'].toString();
          output = 'No attack';
        });
      });
    }
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model/model.tflite', labels: 'assets/model/labels.txt');
    print('reee');
  }

  loadInitCamera() {
    final cI = kIsWeb ? 0 : 1;
    _cameraController = CameraController(cameras![cI], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          _cameraController.startImageStream((image) {
            cameraImage = image;
          });
          // print('reee');
          runMyModel();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Stack(children: [
          AspectRatio(
            aspectRatio: kIsWeb ? (16 / 6) : (10 / 15),
            child:
                // attack
                //     ? Center(
                //         child: Text('2 minutes'),
                //       )
                //     :
                Stack(
              children: [
                Container(
                  // height: scHeight - 200,
                  // width: scWidth - 10,
                  child: CameraPreview(_cameraController),
                ),
                Text('---$output'),
                Visibility(
                    visible: attack,
                    child: Container(
                      color: Colors.red.withOpacity(0.5),
                    )),
                Visibility(
                    visible: attack,
                    child: AlertDialog(
                      content: Column(
                        children: [
                          Image.network(
                            'https://pbs.twimg.com/media/D_l1cMAX4AApLCQ.jpg',
                          ),
                          //
                          SizedBox(
                            height: 20,
                          ),
                          Image.network(
                            'https://www.ckbhospital.com/wp-content/uploads/2022/05/First-Aid-during-heart-attack-CPR-Guide-step-by-step-1024x576.jpg',
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
