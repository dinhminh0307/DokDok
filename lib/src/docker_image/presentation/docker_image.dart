import 'package:dokdok/src/docker_image/domain/entities/docker_image_model.dart';
import 'package:dokdok/src/docker_image/domain/usecases/docker_image_usecase.dart';
import 'package:dokdok/utils/table_builder.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/material.dart';

class DockerImageApp extends StatelessWidget {
  
  final DockerImageUsecase _dockerImageUsecase;
  const DockerImageApp(this._dockerImageUsecase, {super.key});

  @override
  Widget build(BuildContext context) {
    final columns = ['name', 'tag', 'size', 'created'];
    final data = _dockerImageUsecase.getDockerImages()
        .map((img) => {
              'name': img.name,
              'tag': img.tag,
              'size': img.size,
              'created': img.created,
            })
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Docker Images Page'),
        centerTitle: true,
      ),
      body: Align(
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
                  onPressed: () {},
                  label: const Text('Add Docker Project folder'),
                  icon: const Icon(Icons.add),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Manage your Project folder here to be generated into docker file. You can add, remove, and view details of your Docker images.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}