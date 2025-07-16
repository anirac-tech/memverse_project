import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memverse/src/common/widgets/memverse_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

const demoEmail = 'dummysigninuser@dummy.com';
const demoPass = 'any-password';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const MemverseAppBar(suffix: 'Home'),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome to Memverse!', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    const Text(
                      'Memverse uses spaced repetition—a proven technique that helps you memorize and retain scripture for the long term. ',
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text('Visit '),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final uri = Uri.parse('https://memverse.com');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              },
                              child: const Text(
                                'memverse.com',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            ' to learn more, track your progress, or join the global community.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Demo Sign-In/Sign-Up Accounts:',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 7),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SelectableText(
                            'Username: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SelectableText(demoEmail),
                          IconButton(
                            tooltip: 'Copy email',
                            onPressed: () =>
                                Clipboard.setData(const ClipboardData(text: demoEmail)),
                            icon: const Icon(Icons.copy, size: 18),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SelectableText(
                            'Password: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SelectableText(demoPass),
                          IconButton(
                            tooltip: 'Copy password',
                            onPressed: () => Clipboard.setData(const ClipboardData(text: demoPass)),
                            icon: const Icon(Icons.copy, size: 18),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Center(child: Text('💡 This is the Home screen.')),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
