import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiPrescriptionTextNotifier extends StateNotifier<String?> {
  GeminiPrescriptionTextNotifier() : super('');

  Future<void> getResponse(File prescription) async {
    try {
      var geminiApiKey = 'AIzaSyBbzVI-x9oVNlcqVkDd1td-MrdKQiElbHY';
      log('here in gemini api provider');

      final model =
          GenerativeModel(model: 'gemini-1.5-flash', apiKey: geminiApiKey);

      final imageCode = await prescription.readAsBytes();

      final imagePart = DataPart('image/jpeg', imageCode);

      final textPart = TextPart('You are an OCR, extract text from the image');

      final response = await model.generateContent([
        Content.multi([textPart, imagePart])
      ]);

      log(response.text!);

      state = response.text;
    } catch (e) {
      log(e.toString());
    }
  }
}

final textProvider =
    StateNotifierProvider<GeminiPrescriptionTextNotifier, String?>(
        (ref) => GeminiPrescriptionTextNotifier());
