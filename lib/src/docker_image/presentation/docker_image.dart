import 'package:dokdok/utils/table_builder.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/material.dart';

class DockerImageApp extends StatelessWidget {
  DockerImageApp({super.key});
  final List<Map<String, dynamic>> dockerImages = [
    {
      'name': 'nginx',
      'tag': 'latest',
      'size': '133 MB',
      'created': '2 days ago',
    },
    {
      'name': 'ubuntu',
      'tag': '20.04',
      'size': '29.9 MB',
      'created': '1 week ago',
    },
    {
      'name': 'node',
      'tag': '14-alpine',
      'size': '73.5 MB',
      'created': '3 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final columns = dockerImages.first.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Docker Images Page'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: TableBuilder( // feed the data to table builder
            columns: columns,
            data: dockerImages,
          ),
        ),
      ),
    );
  }
}