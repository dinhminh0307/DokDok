import 'package:dokdok/services/process_run/docker/docker_process.dart';

class DockerImageCommand extends DockerProcess {
  DockerImageCommand({required super.log});

  Future<void> buildImage({
    required String imageName,
    required String dockerfilePath,
    List<String> buildArgs = const [],
  }) async {
    final args = [
      'build',
      '-t',
      imageName,
      ...buildArgs,
      '-f',
      dockerfilePath,
      '.',
    ];
    
    logger.info('Building Docker image: $imageName with args: $args');
    
    final result = await runDockerCommand(args);
    
    if (result.exitCode == 0) {
      logger.info('Docker image $imageName built successfully.');
    } else {
      logger.error('Failed to build Docker image $imageName: ${result.stderr}');
    }
  }
}