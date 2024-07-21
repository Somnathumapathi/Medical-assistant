import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_assistant/providers/gemini_prescription_text_provider.dart';

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

  File? _image;

  bool imagePicked = false;

  Future<File?> getFileFromXFile(XFile xfile) async {
    return File(xfile.path);
  }

  String? response = '';

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

  void showMyDialog(BuildContext context, String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Here is your extracted text'),
          content: Text(response),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    Future<void> pickImage() async {
      final XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final File? file = await getFileFromXFile(pickedFile);
        setState(() {
          _image = file;
          imagePicked = true;
        });

        await ref.read(textProvider.notifier).getResponse(_image!);

        response = ref.watch(textProvider);

        showMyDialog(context, response!);
      }
    }

    Future<void> takePicture() async {
      await _controllerFuture;
      prescriptionImage = await _cameraController.takePicture();

      final File? file = await getFileFromXFile(prescriptionImage!);
      setState(() {
        _image = file;
        imagePicked = false;
      });

      await ref.read(textProvider.notifier).getResponse(_image!);

      response = ref.watch(textProvider);

      showMyDialog(context, response!);

      log('Image path: ${prescriptionImage!.path}');
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.75,
              width: width * 0.9,
              child: !imagePicked
                  ? FutureBuilder(
                      future: _controllerFuture,
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.done
                              ? CameraPreview(_cameraController)
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    )
                  : Image.file(_image!),
            ),
            const Gap(10),
            Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: takePicture,
                  label: const Icon(Icons.camera),
                ),
                const Gap(10),
                ElevatedButton.icon(
                  onPressed: pickImage,
                  label: const Icon(Icons.image),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
