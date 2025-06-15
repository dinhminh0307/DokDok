import 'package:dokdok/src/docker_template/data/languages.dart';
import 'package:dokdok/src/docker_template/domain/docker_template_usecase.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide ButtonStyle, showDialog;

class DockerTemplateApp extends StatefulWidget {
  final String? folder;
  final DockerTemplateUseCase _dockerTemplateUseCase = DockerTemplateUseCase();
  DockerTemplateApp({super.key, this.folder});

  @override
  State<DockerTemplateApp> createState() => _DockerTemplateAppState();
}

class _DockerTemplateAppState extends State<DockerTemplateApp> {
  final TextEditingController _codeController = TextEditingController();
  String _selectedLanguage = '';

  final List<Languages> _languages = [];
  String _textEditorValue = '';

  Future<void> setDefaultLanguage() async {
     final lang = await widget._dockerTemplateUseCase.getProgrammingLanguages(widget.folder ?? '');
     setState(() {
      _selectedLanguage = lang;
    });
  }

  Future<void> getAvailableLanguages() async {
    final availableLanguages = await widget._dockerTemplateUseCase.getAvailableLanguages();
    setState(() {
      _languages.clear();
      _languages.addAll(availableLanguages);
      if (_languages.isNotEmpty && _selectedLanguage.isEmpty) {
        _selectedLanguage = _languages.first.languageName ?? '';
      }
    });

  }

  Future<void> setDefaultTextEditorValue() async {
    if (_languages.isNotEmpty) {
      for(var lang in _languages) {
        if (lang.languageName == _selectedLanguage) {
          print('Selected language: ${lang.languageName}');
          final template = await widget._dockerTemplateUseCase.getDockerfileTemplate(lang.languageId ?? 0);
          setState(() {
            _textEditorValue = template;
            _codeController.text = template;
          });
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
void initState() {
  super.initState();
  _initAsync();
}

void _initAsync() async {
  await getAvailableLanguages();
  await setDefaultLanguage();
  await setDefaultTextEditorValue();
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
              _languages.isEmpty
              ? const Text('No languages available')
              :
              ComboBox<String>(
                value: _languages.map((lang) => lang.languageName ?? '').contains(_selectedLanguage)
                  ? _selectedLanguage
                  : (_languages.isNotEmpty ? _languages.first.languageName ?? '' : ''),
                items: _languages
                    .map((lang) => ComboBoxItem<String>(
                          value: lang.languageName ?? '',
                          child: Text(lang.languageName ?? ''),
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
          Expanded(
            child: TextBox(
              controller: _codeController,
              minLines: null,
              maxLines: null,
              expands: true,
              placeholder: _textEditorValue.isEmpty ? 'Enter your code here...' : null,
              style: const TextStyle(
                fontFamily: 'Consolas',
                fontSize: 15,
              ),
              onChanged: (value) {
                _textEditorValue = value;
              },
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