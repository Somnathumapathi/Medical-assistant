import 'package:flutter/material.dart';

class SessionResultScreen extends StatefulWidget {
  const SessionResultScreen({super.key, required this.speechResult});
  final String speechResult;
  @override
  State<SessionResultScreen> createState() => _SessionResultScreenState();
}

class _SessionResultScreenState extends State<SessionResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.speechResult),
      ),
    );
  }
}
