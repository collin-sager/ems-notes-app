import '../patient_info/patient_info_controller.dart';
import '../vitals/vitals_controller.dart';

class Report {
  final PatientInfo patientInfo;
  final List<Vitals> vitalsHistory;
  final List<String> notes;
  final DateTime timestamp;

  Report({
    required this.patientInfo,
    required this.vitalsHistory,
    required this.notes,
  }) : timestamp = DateTime.now();
}

class ReportController {
  Report? _currentReport;

  Report? get currentReport => _currentReport;

  void generateReport({
    required PatientInfo patientInfo,
    required List<Vitals> vitalsHistory,
    required List<String> notes,
  }) {
    _currentReport = Report(
      patientInfo: patientInfo,
      vitalsHistory: vitalsHistory,
      notes: notes,
    );
  }

  // TODO: Implement report sharing functionality
  Future<void> shareReport() async {
    // Implementation for sharing report
  }
}