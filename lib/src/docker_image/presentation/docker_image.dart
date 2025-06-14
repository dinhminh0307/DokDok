import 'package:dokdok/src/docker_image/domain/entities/docker_image_model.dart';
import 'package:dokdok/src/docker_image/domain/usecases/docker_image_usecase.dart';
import 'package:dokdok/utils/table_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/material.dart' hide ButtonStyle;

class DockerImageApp extends StatefulWidget {
  final DockerImageUsecase _dockerImageUsecase;
  const DockerImageApp(this._dockerImageUsecase, {super.key});

  @override
  State<DockerImageApp> createState() => _DockerImageAppState();
}

class _DockerImageAppState extends State<DockerImageApp> {
  int _selectedOption = 0;
  String? _selectedFolder;

  @override
  Widget build(BuildContext context) {
    final columns = ['name', 'tag', 'size', 'created'];
    final data = widget._dockerImageUsecase.getDockerImages()
        .map((img) => {
              'name': img.name,
              'tag': img.tag,
              'size': img.size,
              'created': img.created,
            })
        .toList();
    void _pickFolder() async {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        // Use the selected folder path
        setState(() {
          _selectedFolder = selectedDirectory;
        });
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Docker Images Page'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TableBuilder(
                      columns: columns,
                      data: data,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _pickFolder,
                      label: const Text('Add Docker Project folder'),
                      icon: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selectedFolder == null
                          ? 'Manage your Project folder here to be generated into docker file. You can add, remove, and view details of your Docker images.'
                          : 'Selected folder: $_selectedFolder',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<int>(
                          value: 0,
                          groupValue: _selectedOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                        const Text('Create with template'),
                        const SizedBox(width: 16),
                        Radio<int>(
                          value: 1,
                          groupValue: _selectedOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                        const Text('Create with AI'),
                        const SizedBox(width: 16),
                        Radio<int>(
                          value: 2,
                          groupValue: _selectedOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                        const Text('Create with Drag and Drop'),
                        const SizedBox(width: 16),
                        Radio<int>(
                          value: 3,
                          groupValue: _selectedOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                        const Text('View Details'),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          // Place the button at the bottom center, outside the center-aligned content
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0, right: 32.0),
              child: Button(
                child: const Text('Create Docker Image'),
                style: ButtonStyle(
                  backgroundColor: ButtonState.all(const Color(0xFF8F5FE8).withOpacity(0.3)),
                  padding: ButtonState.all(const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                  elevation: ButtonState.all(4.0),
                ),
                onPressed: () {
                  // Handle button press
                  print('Create Docker Image button pressed');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}