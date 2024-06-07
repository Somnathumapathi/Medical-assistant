import 'dart:developer';
import 'package:ffpns/ffpns.dart';
import 'package:medical_assistant/ffpns_playground.dart';
import 'package:shared_preferences/shared_preferences.dart';

initializeFFPNS() async {
  await FFPNS.initialize(
    options: FFPNSOptions(
      onDeviceTokenReceived: (token) async {
        print("Saving Device Token to SharedPrefs => $token");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('ffpns_device_token', token);
      },
      onNotificationClicked: (payload, type) {
        log("FFPNS_NOTIFICATION_CLICKED\nPAYLOAD: $payload\nTYPE: $type");
        String? notificationType = payload['notification_type'];
        if (notificationType == null) return;
      },
      shouldBlockForegroundNotification: (x) async {
        //SET(true) tp prevent double notifications when app is in foreground
        return true;
      },
      fcmServiceAccountCredentials: ProjectSecrets.fcmServiceAccountCredentials,
    ),
  );
}

/*
Sending push notification:
  FFPNS().sendPushNotification(
    title: "${cu.name} wants to connect",
    message: "Click to accept/reject ${cu.name}'s connection request",
    receiverDeviceToken: token,
    payload: {
      'notification_type': 'connection_request',
      'sender': '${cu.id}',
    },
  );
*/