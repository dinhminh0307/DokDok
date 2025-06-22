import 'package:dokdok/services/db/db_manager.dart';
import 'package:dokdok/services/db/templates.dart';
import 'package:dokdok/services/log/console.dart';
import 'package:dokdok/services/log/interface.dart';
import 'package:dokdok/services/process_run/create_file.dart';
import 'package:dokdok/services/process_run/tokei_process.dart';
import 'package:dokdok/src/docker_template/data/languages.dart';
import 'package:dokdok/src/docker_template/domain/docker_template_usecase.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide ButtonStyle, showDialog;
import 'package:get_it/get_it.dart';

class DockerTemplateApp extends StatefulWidget {
  final String? folder;
  late final DockerTemplateUseCase _dockerTemplateUseCase;

  DockerTemplateApp({super.key, this.folder}) {
  _dockerTemplateUseCase = DockerTemplateUseCase(
    log: GetIt.I<Log>(),
    tokeiProcess: GetIt.I<TokeiProcess>(),
    languagesDb: GetIt.I<DbManager<Languages>>(),
    templatesDb: GetIt.I<TemplatesDbManager>(),
    createFileProcess: GetIt.I<CreateFileProcess>(),
  );
}

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

  Future<void> _createDockerFile() async {
    final code = _codeController.text;
  final language = _selectedLanguage;
  
  if (widget.folder == null || widget.folder!.isEmpty) {
    showDialog(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: const Text('Error'),
        content: const Text('No folder selected. Please select a folder first.'),
        actions: [
          Button(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(dialogContext),
          ),
        ],
      ),
    );
    return;
  }
  
  try {
    // Create the Dockerfile in the selected folder
    await widget._dockerTemplateUseCase.createDockerfile(
      widget.folder!,
      code,
      fileName: "Dockerfile"
    );
    
    showDialog(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: const Text('Success'),
        content: const Text('Dockerfile has been created successfully.'),
        actions: [
          Button(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.of(context).pushReplacementNamed('/docker-images');
            },
          ),
        ],
      ),
    );
  } catch (e) {
    showDialog(
      context: context,
      builder: (_) => ContentDialog(
        title: const Text('Error'),
        content: Text('Failed to create Dockerfile: ${e.toString()}'),
        actions: [
          Button(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
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
              onPressed: () async{
                final code = _codeController.text;
                final language = _selectedLanguage;
                
                if (widget.folder == null || widget.folder!.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => ContentDialog(
                      title: const Text('Error'),
                      content: const Text('No folder selected. Please select a folder first.'),
                      actions: [
                        Button(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                
                try {
                  // Create the Dockerfile in the selected folder
                  await _createDockerFile(); // Call your method here
                  
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (_) => ContentDialog(
                      title: const Text('Error'),
                      content: Text('Failed to create Dockerfile: ${e.toString()}'),
                      actions: [
                        Button(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}