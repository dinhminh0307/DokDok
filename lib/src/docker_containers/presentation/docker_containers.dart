import 'package:dokdok/models/container_model.dart';
import 'package:dokdok/shared/ui/toast_builder.dart';
import 'package:dokdok/src/docker_containers/domain/docker_containers_service.dart';
import 'package:dokdok/src/docker_image/domain/entities/docker_image_model.dart';
import 'package:dokdok/src/docker_image/domain/usecases/docker_image_usecase.dart';
import 'package:dokdok/utils/table_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/material.dart' hide ButtonStyle, Scrollbar, IconButton;
import 'package:go_router/go_router.dart';

class DockerContainers extends StatefulWidget {
  final DockerContainersService _dockerContainersService;
  const DockerContainers(this._dockerContainersService, {super.key});

  @override
  State<DockerContainers> createState() => _DockerContainersState();
}

class _DockerContainersState extends State<DockerContainers> {
  int _selectedOption = 0;
  String? _selectedFolder;

  // Add controllers for both directions
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  Widget _buildTableSection() {
    final columns = ['id', 'name', 'image', 'status', 'createdAt', 'port'];

    return FutureBuilder<List<Containers>>(
      future: widget._dockerContainersService.listContainers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 700,
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            width: 700,
            height: 300,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            width: 700,
            height: 300,
            child: Center(
              child: Text(
                'No Docker images found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        } else {
          final data = snapshot.data!
              .map((container) => {
                    'id': container.id,
                    'name': container.name,
                    'image': container.image,
                    'status': container.status,
                    'created': container.createdAt,
                    'port': container.port,
                  })
              .toList();

          return SizedBox(
            width: 700,
            height: 300,
            child: Scrollbar(
              controller: _horizontalController,
              thumbVisibility: true,
              notificationPredicate: (notification) => notification.depth == 0,
              child: SingleChildScrollView(
                controller: _horizontalController,
                scrollDirection: Axis.horizontal,
                child: Scrollbar(
                  controller: _verticalController,
                  thumbVisibility: true,
                  notificationPredicate: (notification) => notification.depth == 1,
                  child: SingleChildScrollView(
                    controller: _verticalController,
                    scrollDirection: Axis.vertical,
                    child: TableBuilder(
                      columns: columns,
                      data: data,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Docker Containers Page'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildTableSection(),
        ],
      ),
    );
  }
}