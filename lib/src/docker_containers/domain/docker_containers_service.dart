import 'package:dokdok/models/container_model.dart';
import 'package:dokdok/services/process_run/docker/docker_container_command.dart';

class DockerContainersService {
  final DockerContainerCommand _dockerContainerCommand;

  DockerContainersService({required DockerContainerCommand dockerContainerCommand})
      : _dockerContainerCommand = dockerContainerCommand;

  Future<List<Containers>> listContainers() async {
    try {
      return await _dockerContainerCommand.listContainers();
    } catch (e) {
      throw Exception('Failed to list Docker containers: $e');
    }
  }
}