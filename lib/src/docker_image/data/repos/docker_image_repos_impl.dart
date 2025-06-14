import 'dart:io';

import 'package:dokdok/src/docker_image/domain/entities/docker_image_model.dart';
import 'package:dokdok/src/docker_image/domain/repos/docker_image_repos.dart';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_run.dart';
import 'package:process_run/stdio.dart';

class DockerImageInterfaceImpl extends DockerImageInterface{
  @override
  Future<List<DockerImageModel>> getDockerImages() async {
    final cmd = ProcessCmd(
      'docker', ['images', '--format', '{{.Repository}} {{.Tag}} {{.Size}} {{.CreatedSince}}'],
    );

    final result = await runCmd(cmd);
    if (result.exitCode == 0) {
      return DockerImageModel.listFromCliOutput(result.stdout.toString());
    } else {
      // Optionally handle error, log, or throw
      return [];
    }
  }

}