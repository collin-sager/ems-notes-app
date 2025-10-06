import 'package:flutter/material.dart';
import 'patient_info_controller.dart';

class PatientInfoPage extends StatefulWidget {
  const PatientInfoPage({super.key});

  @override
  State<PatientInfoPage> createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = PatientInfoController();
  String _name = '';
  String _age = '';
  String _chiefComplaint = '';

  void _savePatientInfo() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final parsedAge = int.tryParse(_age);
    if (parsedAge == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid numeric age.')),
      );
      return;
    }

    _controller.savePatientInfo(
      name: _name,
      age: parsedAge,
      chiefComplaint: _chiefComplaint,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Patient information saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Patient Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _age = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Age must be a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Chief Complaint',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => _chiefComplaint = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter chief complaint';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _savePatientInfo,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Save Patient Information'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
