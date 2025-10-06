import 'package:supabase_flutter/supabase_flutter.dart';

import '../patient_info/patient_info_controller.dart';
import '../vitals/vitals_controller.dart';

class ReportNotes {
  final String notes;
  final String observations;
  final DateTime updatedAt;

  ReportNotes({
    required this.notes,
    required this.observations,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory ReportNotes.fromMap(Map<String, dynamic> map) {
    return ReportNotes(
      notes: (map['notes'] as String?) ?? '',
      observations: (map['observations'] as String?) ?? '',
      updatedAt:
          DateTime.tryParse(map['updated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class ReportData {
  const ReportData({
    required this.patientInfo,
    required this.vitalsHistory,
    required this.notes,
  });

  final PatientInfo? patientInfo;
  final List<Vitals> vitalsHistory;
  final ReportNotes? notes;
}

class ReportController {
  ReportController({
    SupabaseClient? client,
    PatientInfoController? patientInfoController,
    VitalsController? vitalsController,
  }) : _client = client ?? Supabase.instance.client,
       _patientInfoController =
           patientInfoController ?? PatientInfoController(client: client),
       _vitalsController = vitalsController ?? VitalsController(client: client);

  final SupabaseClient _client;
  final PatientInfoController _patientInfoController;
  final VitalsController _vitalsController;

  Future<ReportData> loadReport() async {
    final patientInfo = await _patientInfoController.fetchLatestPatientInfo();
    final vitalsHistory = await _vitalsController.fetchVitalsHistory();
    final notes = await _fetchNotes();

    return ReportData(
      patientInfo: patientInfo,
      vitalsHistory: vitalsHistory,
      notes: notes,
    );
  }

  Future<ReportNotes?> _fetchNotes() async {
    final user = _requireUser();
    final data = await _client
        .from('reports')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return ReportNotes.fromMap(Map<String, dynamic>.from(data));
  }

  Future<void> saveNotes({
    required String notes,
    required String observations,
  }) async {
    final user = _requireUser();
    await _client.from('reports').upsert({
      'user_id': user.id,
      'notes': notes,
      'observations': observations,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id');
  }

  Future<void> shareReport() async {
    // Placeholder for future implementation
  }

  User _requireUser() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user.');
    }
    return user;
  }
}
