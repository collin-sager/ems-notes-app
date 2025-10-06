import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../patient_info/patient_info_page.dart';
import '../vitals/vitals_page.dart';
import '../report/report_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMS Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Supabase.instance.client.auth.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: [
            _buildMenuCard(
              context,
              'Patient Info',
              Icons.person,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientInfoPage(),
                ),
              ),
            ),
            _buildMenuCard(
              context,
              'Vitals',
              Icons.favorite,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VitalsPage()),
              ),
            ),
            _buildMenuCard(
              context,
              'Report',
              Icons.description,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
