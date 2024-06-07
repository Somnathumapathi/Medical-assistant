import 'package:flutter/material.dart';

class SessionResultScreen extends StatefulWidget {
  const SessionResultScreen({super.key, required this.speechResult});
  final String speechResult;
  @override
  State<SessionResultScreen> createState() => _SessionResultScreenState();
}

class _SessionResultScreenState extends State<SessionResultScreen> {
  late TextEditingController _resultController;
  final _durationController = TextEditingController();
  final _patientNameController = TextEditingController();
  @override
  void initState() {
    _resultController = TextEditingController(text: widget.speechResult);
    super.initState();
  }

  @override
  void dispose() {
    _resultController.dispose();
    _durationController.dispose();
    _patientNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            TextFormField(
              controller: _resultController,
              maxLines: 20,
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _durationController,
              keyboardType: TextInputType.numberWithOptions(),
            ),
            TextFormField(
              controller: _patientNameController,
              keyboardType: TextInputType.numberWithOptions(),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              label: Text('Generate Report'),
              icon: Icon(Icons.edit_document),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        )),
      ),
    );
  }
}
