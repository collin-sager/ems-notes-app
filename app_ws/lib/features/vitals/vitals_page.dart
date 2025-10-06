import 'package:flutter/material.dart';
import 'vitals_controller.dart';

class VitalsPage extends StatefulWidget {
  const VitalsPage({super.key});

  @override
  State<VitalsPage> createState() => _VitalsPageState();
}

class _VitalsPageState extends State<VitalsPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = VitalsController();
  String _heartRate = '';
  String _bloodPressure = '';
  String _respiratoryRate = '';
  String _temperature = '';
  bool _isSaving = false;

  Future<void> _saveVitals() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final parsedHeartRate = int.tryParse(_heartRate);
    final parsedRespiratoryRate = int.tryParse(_respiratoryRate);
    final parsedTemperature = double.tryParse(_temperature);

    if (parsedHeartRate == null ||
        parsedRespiratoryRate == null ||
        parsedTemperature == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid numeric values for vitals.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _controller.saveVitals(
        heartRate: parsedHeartRate,
        bloodPressure: _bloodPressure,
        respiratoryRate: parsedRespiratoryRate,
        temperature: parsedTemperature,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vitals saved.')));
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save vitals: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Vitals')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Heart Rate (bpm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _heartRate = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter heart rate';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Heart rate must be numeric';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Blood Pressure (systolic/diastolic)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _bloodPressure = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter blood pressure';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Respiratory Rate (breaths/min)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _respiratoryRate = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter respiratory rate';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Respiratory rate must be numeric';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Temperature (°F)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _temperature = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter temperature';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Temperature must be numeric';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveVitals,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Vitals'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
