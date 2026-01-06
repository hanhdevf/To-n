import 'package:flutter/material.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/core/services/firestore_seeding_service.dart';

/// Admin page for seeding Firestore data
/// This is a dev-only feature for initial setup
class AdminSeedingPage extends StatefulWidget {
  const AdminSeedingPage({super.key});

  @override
  State<AdminSeedingPage> createState() => _AdminSeedingPageState();
}

class _AdminSeedingPageState extends State<AdminSeedingPage> {
  bool _isSeeding = false;
  String _status = '';
  final List<String> _logs = [];

  Future<void> _seedData() async {
    setState(() {
      _isSeeding = true;
      _status = 'Starting seeding process...';
      _logs.clear();
    });

    try {
      final seedingService = getIt<FirestoreSeedingService>();

      _addLog('🌱 Starting data seeding...');

      // Use the optimized seedInitialData method
      await seedingService.seedInitialData();

      _addLog('✅ Seeding completed successfully!');
      setState(() {
        _status = 'Seeding completed successfully!';
        _isSeeding = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data seeded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _addLog('❌ Error: $e');
      setState(() {
        _status = 'Seeding failed: $e';
        _isSeeding = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seeding failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addLog(String message) {
    setState(() {
      _logs.add(message);
    });
    // Also print to console
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin: Firestore Seeding'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.amber[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Warning',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will delete all existing cinemas and showtimes data and re-seed with mock data.',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: $_status',
                      style: TextStyle(
                        color: _isSeeding ? Colors.blue : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSeeding ? null : _seedData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: _isSeeding
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Seeding...'),
                      ],
                    )
                  : const Text(
                      'Start Seeding',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Logs:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
