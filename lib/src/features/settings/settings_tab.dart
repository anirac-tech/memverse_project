import 'package:flutter/material.dart';
import 'package:memverse/src/common/widgets/memverse_app_bar.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MemverseAppBar(suffix: 'Settings'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 18),
            const Text('Default Translation:'),
            const Text(
              'TODO: Let user pick translation here',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 18),
            const Text('Reminder Notification Time:'),
            const Text(
              'TODO: User sets a preferred time for daily reminder notifications',
              style: TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            const Center(child: Text('🔧 Demo Settings UI')),
          ],
        ),
      ),
    );
  }
}
