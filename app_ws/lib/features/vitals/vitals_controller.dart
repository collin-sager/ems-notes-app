class Vitals {
  final int heartRate;
  final String bloodPressure;
  final int respiratoryRate;
  final double temperature;
  final DateTime timestamp;

  Vitals({
    required this.heartRate,
    required this.bloodPressure,
    required this.respiratoryRate,
    required this.temperature,
  }) : timestamp = DateTime.now();
}

class VitalsController {
  final List<Vitals> _vitalsHistory = [];

  List<Vitals> get vitalsHistory => List.unmodifiable(_vitalsHistory);

  void saveVitals({
    required int heartRate,
    required String bloodPressure,
    required int respiratoryRate,
    required double temperature,
  }) {
    _vitalsHistory.add(Vitals(
      heartRate: heartRate,
      bloodPressure: bloodPressure,
      respiratoryRate: respiratoryRate,
      temperature: temperature,
    ));
  }
}