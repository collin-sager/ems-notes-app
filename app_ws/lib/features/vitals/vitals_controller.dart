import 'package:supabase_flutter/supabase_flutter.dart';

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
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory Vitals.fromMap(Map<String, dynamic> map) {
    return Vitals(
      heartRate: (map['heart_rate'] as num).toInt(),
      bloodPressure: map['blood_pressure'] as String,
      respiratoryRate: (map['respiratory_rate'] as num).toInt(),
      temperature: (map['temperature'] as num).toDouble(),
      timestamp:
          DateTime.tryParse(map['recorded_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class VitalsController {
  VitalsController({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  final List<Vitals> _vitalsHistory = [];

  List<Vitals> get vitalsHistory => List.unmodifiable(_vitalsHistory);

  Future<void> saveVitals({
    required int heartRate,
    required String bloodPressure,
    required int respiratoryRate,
    required double temperature,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user.');
    }

    final vitals = Vitals(
      heartRate: heartRate,
      bloodPressure: bloodPressure,
      respiratoryRate: respiratoryRate,
      temperature: temperature,
    );

    await _client.from('vitals').insert({
      'user_id': user.id,
      'heart_rate': vitals.heartRate,
      'blood_pressure': vitals.bloodPressure,
      'respiratory_rate': vitals.respiratoryRate,
      'temperature': vitals.temperature,
      'recorded_at': vitals.timestamp.toIso8601String(),
    });

    _vitalsHistory.insert(0, vitals);
  }

  Future<List<Vitals>> fetchVitalsHistory() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user.');
    }

    final response = await _client
        .from('vitals')
        .select()
        .eq('user_id', user.id)
        .order('recorded_at', ascending: false);

    final entries = (response as List<dynamic>)
        .map((row) => Vitals.fromMap(row as Map<String, dynamic>))
        .toList();

    _vitalsHistory
      ..clear()
      ..addAll(entries);

    return vitalsHistory;
  }
}
