class PatientInfo {
  final String name;
  final int age;
  final String chiefComplaint;

  PatientInfo({
    required this.name,
    required this.age,
    required this.chiefComplaint,
  });
}

class PatientInfoController {
  PatientInfo? _currentPatient;

  PatientInfo? get currentPatient => _currentPatient;

  void savePatientInfo({
    required String name,
    required int age,
    required String chiefComplaint,
  }) {
    _currentPatient = PatientInfo(
      name: name,
      age: age,
      chiefComplaint: chiefComplaint,
    );
  }
}