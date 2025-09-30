import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMS Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement report sharing
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoCard(),
            const SizedBox(height: 16),
            const Text(
              'Vital Signs History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildVitalsHistory(),
            const SizedBox(height: 16),
            const Text(
              'Notes & Observations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildNotes(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Name: John Doe'),
            SizedBox(height: 8),
            Text('Age: 45'),
            SizedBox(height: 8),
            Text('Chief Complaint: Chest Pain'),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalsHistory() {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3, // Example count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Vitals Check #${index + 1}'),
            subtitle: const Text('HR: 80, BP: 120/80, RR: 16, Temp: 98.6°F'),
            trailing: Text('${DateTime.now().hour}:${DateTime.now().minute}'),
          );
        },
      ),
    );
  }

  Widget _buildNotes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Text('Patient found conscious and alert...'),
            SizedBox(height: 8),
            Text('No visible injuries...'),
          ],
        ),
      ),
    );
  }
}
