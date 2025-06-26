import 'package:dokdok/services/log/interface.dart';
import 'package:dokdok/services/process_run/common/base_installable_process_new.dart';
import 'package:dokdok/utils/platform_utils.dart';
import 'package:dokdok/services/process_run/interfaces/command_interfaces.dart';
import 'package:process_run/stdio.dart';

/// Docker process handler that provides installation and command execution capabilities
class DockerProcess extends BaseInstallableProcess {
  /// Creates a new instance of the Docker process handler
  DockerProcess({
    required Log log, 
    ProcessRunner? processRunner,
    PlatformType? platformType
  }) : super(
    log: log, 
    processName: 'Docker', 
    processRunner: processRunner,
    platformType: platformType
  ) {
    logger.info('Initialized DockerProcess for platform: ${PlatformUtils.getPlatformName()}');
  }
  
  @override
  String get versionCheckCommand => 'docker';
    @override
  String get installCommand {
    switch (platformType) {
      case PlatformType.windows:
        return 'choco';
      case PlatformType.linux:
        return 'sudo';
      case PlatformType.macOS:
        return 'brew';
      case PlatformType.other:
        return 'echo';
    }
  }
  
  @override
  List<String> get installArgs {
    switch (platformType) {
      case PlatformType.windows:
        return ['install', 'docker-desktop', '-y'];
      case PlatformType.linux:
        return ['apt-get', 'install', '-y', 'docker.io'];
      case PlatformType.macOS:
        return ['install', 'docker'];
      case PlatformType.other:
        logger.error('Unsupported platform for automatic Docker installation');
        return ['Docker installation not supported on this platform. Please install manually.'];
    }
  }
  
  /// Runs a Docker command
  Future<ProcessResult> runDockerCommand(List<String> arguments) async {
    try {
      var result = await runCommand('docker', arguments);
      if (result.exitCode == 0) {
        return result;
      } else {
        logger.error('Docker command failed: ${result.stderr}');
        throw Exception('Docker command failed with exit code ${result.exitCode}');
      }
    } catch (e) {
      logger.error('Error executing Docker command', e);
      throw Exception('Error executing Docker command');
    }
  }
  
  /// Gets Docker version information
  Future<String?> getDockerVersion() async {
    try {
      var result = await runCommand('docker', ['version', '--format', '{{.Server.Version}}']);
      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      } else {
        logger.error('Failed to get Docker version: ${result.stderr}');
        return null;
      }
    } catch (e) {
      logger.error('Error getting Docker version', e);
      return null;
    }
  }
    /// Checks if Docker daemon is running
  Future<bool> isDockerRunning() async {
    try {
      var result = await runCommand('docker', ['info']);
      return result.exitCode == 0;
    } catch (e) {
      logger.error('Error checking Docker daemon status', e);
      return false;
    }
  }
}