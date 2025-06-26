import 'dart:convert';

import 'package:dokdok/models/container_model.dart';
import 'package:dokdok/services/process_run/docker/docker_process.dart';

class DockerContainerCommand extends DockerProcess{
  DockerContainerCommand({required super.log});

  Future<List<Containers>> listContainers() async {
    try {
      final args = <String>['ps', '-a', '--format', '{{json .}}'];
      final result = await runDockerCommand(args);
      
      if (result.exitCode != 0) {
        throw Exception('Failed to list containers: ${result.toString()}');
      }

      final output = result.stdout as String;
      List<String> lines = output.split('\n');
      List<Containers> containers = [];

      for(var line in lines) {
        if (line.trim().isEmpty) continue;
        Map<String, dynamic> container = jsonDecode(line);
        containers.add(Containers.fromJson(container));
      }
      return containers;
  } catch (e) {
    logger.error('Error listing Docker containers: $e');
    throw Exception('Failed to list Docker containers: $e');
  }
  }
}