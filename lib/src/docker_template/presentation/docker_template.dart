import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide ButtonStyle, showDialog;

class DockerTemplateApp extends StatefulWidget {
  final String? folder;
  const DockerTemplateApp({super.key, this.folder});

  @override
  State<DockerTemplateApp> createState() => _DockerTemplateAppState();
}

class _DockerTemplateAppState extends State<DockerTemplateApp> {
  final TextEditingController _codeController = TextEditingController();
  String _selectedLanguage = 'Dockerfile';

  final List<String> _languages = [
    'Dockerfile',
    'YAML',
    'Shell',
    'Python',
    'JavaScript',
  ];

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language dropdown
          const Text(
            'Docker Template',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Language:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              ComboBox<String>(
                value: _selectedLanguage,
                items: _languages
                    .map((lang) => ComboBoxItem<String>(
                          value: lang,
                          child: Text(lang),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Code editor (multiline text field)
          Expanded(
            child: TextBox(
              controller: _codeController,
              minLines: null,
              maxLines: null,
              expands: true,
              placeholder: 'Enter your code here...',
              style: const TextStyle(
                fontFamily: 'Consolas',
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: Button(
              child: const Text('Create Docker Image'),
              style: ButtonStyle(
                backgroundColor: ButtonState.all(const Color(0xFF8F5FE8).withOpacity(0.3)),
                padding: ButtonState.all(const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                elevation: ButtonState.all(4.0),
              ),
              onPressed: () {
                // You can handle the code submission here
                final code = _codeController.text;
                final language = _selectedLanguage;
                // TODO: Implement your logic for creating a Docker image with [code] and [language]
                showDialog(
                  context: context,
                  builder: (_) => ContentDialog(
                    title: const Text('Docker Image'),
                    content: const Text('Docker image creation logic goes here.'),
                    actions: [
                      Button(
                        child: const Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}