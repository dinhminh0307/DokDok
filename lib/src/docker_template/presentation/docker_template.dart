import 'package:fluent_ui/fluent_ui.dart';

class DockerTemplateApp extends StatelessWidget {
  const DockerTemplateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Docker Template Page',
            style: FluentTheme.of(context).typography.title,
          ),
          const SizedBox(height: 16),
          Text(
            'This page will display Docker templates and allow users to manage them.',
            style: FluentTheme.of(context).typography.body,
          ),
          // Add more UI elements here as needed
        ],
      ),
    );
  }
}