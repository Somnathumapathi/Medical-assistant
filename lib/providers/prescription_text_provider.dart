import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class PrescriptionTextNotifier extends StateNotifier<String> {
  PrescriptionTextNotifier() : super('');

  Future<String> extractText(File prescription) async {
    try {
      String prescriptionUrl = '';

      String apiUrl = '';

      String cloudinaryUrl =
          'https://api.cloudinary.com/v1_1/drozmrtrb/image/upload';

      final req = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
        ..fields['upload_preset'] = 'eks7z3nd'
        ..files
            .add(await http.MultipartFile.fromPath('file', prescription.path));

      final res = await req.send();

      if (res.statusCode == 200) {
        final resData = await res.stream.toBytes();
        final resString = String.fromCharCodes(resData);
        final jsonMap = jsonDecode(resString);

        final url = jsonMap['url'];

        prescriptionUrl = url;

        log(prescriptionUrl);
      }

      var body = {'imageUrl': prescription};

      var headers = <String, String>{
        'Content-Type': 'application/json',
      };

      final response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        log('request successful');
        String jsonResult = response.body;
        String result = jsonDecode(jsonResult);
        log(result);

        state = result;

        return result;
      } else {
        log('error in getting data');
        log(response.statusCode.toString());
        log(response.toString());

        return '';
      }
    } catch (e) {
      log('in catch block');
      log(e.toString());

      return '';
    }
  }
}

final prescriptionTextProvider =
    StateNotifierProvider<PrescriptionTextNotifier, String>((ref) => PrescriptionTextNotifier());
