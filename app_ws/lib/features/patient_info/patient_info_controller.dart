import 'package:supabase_flutter/supabase_flutter.dart';

class PatientInfo {
  final String name;
  final int age;
  final String chiefComplaint;
  final DateTime updatedAt;

  PatientInfo({
    required this.name,
    required this.age,
    required this.chiefComplaint,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory PatientInfo.fromMap(Map<String, dynamic> map) {
    return PatientInfo(
      name: map['name'] as String,
      age: (map['age'] as num).toInt(),
      chiefComplaint: map['chief_complaint'] as String,
      updatedAt:
          DateTime.tryParse(map['updated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class PatientInfoController {
  PatientInfoController({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  PatientInfo? _currentPatient;

  PatientInfo? get currentPatient => _currentPatient;

  Future<void> savePatientInfo({
    required String name,
    required int age,
    required String chiefComplaint,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user.');
    }

    final patientInfo = PatientInfo(
      name: name,
      age: age,
      chiefComplaint: chiefComplaint,
    );
    await _client.from('patient_info').upsert({
      'user_id': user.id,
      'name': patientInfo.name,
      'age': patientInfo.age,
      'chief_complaint': patientInfo.chiefComplaint,
      'updated_at': patientInfo.updatedAt.toIso8601String(),
    }, onConflict: 'user_id');
    _currentPatient = patientInfo;
  }

  Future<PatientInfo?> fetchLatestPatientInfo() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user.');
    }

    final data = await _client
        .from('patient_info')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (data == null) {
      _currentPatient = null;
      return null;
    }

    final patientInfo = PatientInfo.fromMap(Map<String, dynamic>.from(data));
    _currentPatient = patientInfo;
    return patientInfo;
  }
}
