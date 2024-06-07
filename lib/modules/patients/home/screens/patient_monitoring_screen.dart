import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  @override
  void initState() {
    loadInitCamera();
    super.initState();
  }

  loadInitCamera() {
    final cI = kIsWeb ? 0 : 1;
    _cameraController = CameraController(cameras![cI], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          // runMyModel();
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
            child: attack
                ? Center(
                    child: Text('2 minutes'),
                  )
                : Container(
                    // height: scHeight - 200,
                    // width: scWidth - 10,
                    child: CameraPreview(_cameraController),
                  ),
          ),
        ]),
      ),
    );
  }
}
