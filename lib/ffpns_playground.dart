import 'package:flutter/material.dart';
import 'package:medical_assistant/backend/autopn_registrar.dart';

class FFPNSPlayground extends StatelessWidget {
  const FFPNSPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Add Medication'),
          onPressed: () async {
            final z = await MedicationReminderRegistrar.registerMedication(
              medicationName: 'VitaminB12 Sparc',
              timing: "17:50",
              instructions: "Take it with a glass of water",
            );
            print(z);
          },
        ),
      ),
    );
  }
}	

class ProjectSecrets {
  static const Map<String, String> fcmServiceAccountCredentials = {
    "type": "service_account",
    "project_id": "medical-assistant-923f2",
    "private_key_id": "d837184ad46a80082eb39a3772aa7bfcbe0dc935",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCxzHrwMsvrY+Wc\n5ErNm1bQOitm8pgTWRh6Cq5JGdO6pcIspChwjbj4bbFU38uFVvn3EkWw0Bh4EiV6\n/yV191HHZr+l4FFwnbzQzW/oz3c2/wbO5v8iH30wD1UDDG74L18SdMubS9xnEajK\nSdltrOhodVktvPI8hLHV2+2ADEWf2EJQOOBhTuX0Ze6ZWGsobS0lrfAFbcAjZ9Nd\nGKxVj+Sh4qITTpmD5LdeC5uIhtVq3FpyjpTNdd4NttG1KIiBlDK6z1oB21Axikd/\nwhEKOl6BlXjTaMoqZH6i7N6NKDcqAsczsKHoaq/Sd1THEeTgs05xppjj/EVzeW27\n2Xi0J7lHAgMBAAECggEAB9jjCivrxSFdFn4a8RUskTcoCDynyp7Rjj1fcNmDd0bu\nmYLLSCBxLAHHZFwWQvXSRX3YdpPQqKgAYHvXXuwB/3+A8OTEI2jK1xpiGI/jjplV\n5xbZ5tsl7tOWaHKJiUmp9AoUnG+ONDxay0bUIluRzF51h6fBtzsSEELLKi4geowB\nlG6k6WT0HD+TN0E8EmTEzViPl6wYDRBuSthIE0rlAa87ezAKn33ts6KmCNf2wre0\najjCjayslLTaawEKj+cGNJLZ2dX4IHABJXE9rPC6XgmJCGKrVgEchK5PzGouo0pX\ni0h88dki4TM7zddcYmm9U9GChw7+TIPxfCFGZOtMCQKBgQDd4NW5ShvKqufukl4o\n1OJ2Nh19gl9tSVN5XSNOCXdvjKvNFMJuHIBF8j8p9vZvgFg00QGTHvGWvo/veDHq\n7T/TJIRP0zFYkvEmS81WZ3nA5c/UCnhzjT5f9vylx5WyC6U/0Wlm8pssotKuLQsu\ndi+TArjb5gLKAc0sKUSB3Y5muQKBgQDNJEVtzXFeiGcUnqKFn3LjtYRqhp+3mbz3\nP5Y7mMmeDbbiO50ijOnvcjp79/bVSILlbWfxZxK/pFfy2Gzwx2Ohg7O/YRVTrDde\naKBUTucWhtlrFjrW+YIeVgPqeCHknh+tvVjHQTWgc49/boL0CQ9Tvq+TyX1HRQuI\nD2UUvFcf/wKBgQDTZ0TbzZObT6m6szUJ/IRlk3wXuN+JdmMVcLuRwA1PeJ28wjna\nxkcl3gF2z3rQlF32vOmeLs6LDbiAt2oAZ9r3J4T1tcj/lsoz7eeQmvjz5UNWyj8o\nAfzbXK4umnKz+MqTesjNsPxO1DieggZ0V2FO1joiMw6XQI4ntI40mk/y6QKBgFrw\nBUcTl3oMhYWCfRE3CbsfsD94xjyhjj8clQB+ToIeGkBXpOS4Csv2my5xUZ5isoP5\n5+X/hzQlKkeg4UorWWMz+u6PnuCkqzbSsqAtCgvWY3MxO4wotyGzh7Dc6ElsPybJ\nlR1fLuKd17LpzmtXyM+a7EJbQ4ngdagvCuQSSZ0JAoGAHYgMjPPkAp/Hce3zKXGf\nNpDvnbIi3buaqlEy0RiptEWvYqZAy9tUtYMPathuEF4Hlo1fNS1i5pgldpxlratj\nxGXoyB7au+id3SUXoiRm8iwFQBA1IcVKKKQRjiJjZ7qP/KL43+EfFdsw+bLYlXJs\nBzR9+bu8VjU35OC3edmMrqQ=\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-e1ur5@medical-assistant-923f2.iam.gserviceaccount.com",
    "client_id": "109918919472978826957",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-e1ur5%40medical-assistant-923f2.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };
}
