import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MedicationReminderRegistrar {
  static const String BEARERCODE = "U4fngc9nxXY-096W-BSl603s6ZuQ2T4nYmF2w7YY";

  static Future<bool> registerMedication({
    required String medicationName,
    required String timing,
    required String instructions,
  }) async {
    final prefs = (await SharedPreferences.getInstance());
    final deviceToken = prefs.getString('ffpns_device_token') ?? 'NULL';

    final resp = await _append({
      "payload": {
        "mid": medicationName.toLowerCase(),
      },
      "deviceToken": deviceToken,
      "content": instructions,
      "title": "$medicationName Medication Reminder",
      "time": timing,
    });

    if (resp.statusCode == 200) {
      return true;
    }
    return false;
  }

  // ======================= (Helpers) ============================
  static Future _getRegistrarValues() async {
    const key = 'ffpns_registry';
    final resp = await http.get(
      Uri.parse(
          "https://api.cloudflare.com/client/v4/accounts/664641476fe2c5c10ddf43cf0ad57e9d/storage/kv/namespaces/84acd852db10458a815f28415af9c9f4/values/$key"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $BEARERCODE'
      },
    );
    if (resp.statusCode != 200) return [];
    if (resp.body.startsWith("value=")) {
      return [];
    }
    return jsonDecode(resp.body)['entries'];
  }

  static _append(Map value) async {
    final existingValues = await _getRegistrarValues();

    const key = 'ffpns_registry';
    final body = {
      "entries": [
        ...existingValues,
        value,
      ]
    };
    print(body);
    final resp = await http.put(
      Uri.parse(
          "https://api.cloudflare.com/client/v4/accounts/664641476fe2c5c10ddf43cf0ad57e9d/storage/kv/namespaces/84acd852db10458a815f28415af9c9f4/values/$key"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $BEARERCODE'
      },
      body: jsonEncode(body),
    );
    return resp;
  }
}
