import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class PatientPrescriptionScreen extends ConsumerStatefulWidget {
  const PatientPrescriptionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PatientPrescriptionScreenState();
}

class _PatientPrescriptionScreenState
    extends ConsumerState<PatientPrescriptionScreen> {
  late List<CameraDescription> cameraDescription;
  late CameraController _cameraController;
  late CameraDescription rearCamera;
  late Future<void> _controllerFuture;
  XFile? prescriptionImage;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameraDescription = await availableCameras();
    rearCamera = cameraDescription.first;
    _cameraController = CameraController(rearCamera, ResolutionPreset.high);
    _controllerFuture = _cameraController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    await _controllerFuture;
    prescriptionImage = await _cameraController.takePicture();

    log('Image path: ${prescriptionImage!.path}');
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.75,
              width: width * 0.9,
              child: FutureBuilder(
                future: _controllerFuture,
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.done
                        ? CameraPreview(_cameraController)
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
              ),
            ),
            const Gap(10),
            Center(
              child: ElevatedButton.icon(
                onPressed: takePicture,
                label: const Icon(Icons.camera),
              ),
            )
          ],
        ),
      ),
    );
  }
}
