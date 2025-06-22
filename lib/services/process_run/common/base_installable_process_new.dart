import 'dart:io';

import 'package:dokdok/services/log/interface.dart';
import 'package:dokdok/utils/platform_utils.dart';
import 'package:dokdok/services/process_run/common/process_logger.dart';
import 'package:dokdok/services/process_run/interfaces/command_interfaces.dart';

/// Abstract base class for installable processes
abstract class BaseInstallableProcess implements CommandRunner, InstallableProcess, VersionedProcess {
  final ProcessLogger logger;
  final ProcessRunner _processRunner;
  final PlatformType platformType;
  
  BaseInstallableProcess({
    required Log log, 
    required String processName,
    ProcessRunner? processRunner,
    PlatformType? platformType,
  }) : 
    logger = ProcessLogger(log, processName),
    _processRunner = processRunner ?? ProcessRunner(),
    platformType = platformType ?? PlatformUtils.detectPlatformType();
  
  @override
  Future<ProcessResult> runCommand(String command, List<String> arguments) async {
    return await _processRunner.runCommand(command, arguments);
  }
  
  /// Gets the command to check if the process is installed
  String get versionCheckCommand;
  
  /// Gets the arguments for checking if the process is installed
  List<String> get versionCheckArgs => ['--version'];
  
  /// Gets the installation command
  String get installCommand;
  
  /// Gets the arguments for installing the process
  List<String> get installArgs;
  
  /// Determines if the process is installed based on the command result
  bool isInstallationSuccessful(ProcessResult result) {
    return result.exitCode == 0;
  }
  
  /// Logs the success message after checking installation
  void logInstallationCheckSuccess(ProcessResult result) {
    logger.info('${versionCheckCommand} is installed: ${result.stdout}');
  }
  
  /// Logs the error message after checking installation
  void logInstallationCheckError(ProcessResult result) {
    logger.error('Command not found: ${result.toString()}');
  }
  
  /// Logs the success message after installation
  void logInstallationSuccess(ProcessResult result) {
    logger.info('${versionCheckCommand} installation started: ${result.stdout}');
  }
  
  /// Logs the error message after installation
  void logInstallationError(ProcessResult result) {
    logger.error('Failed to start ${versionCheckCommand} installation: ${result.stderr}');
  }
  
  @override
  Future<bool> isInstalled() async {
    var result = await runCommand(versionCheckCommand, versionCheckArgs);
    if (isInstallationSuccessful(result)) {
      logInstallationCheckSuccess(result);
      return true;
    } else {
      logInstallationCheckError(result);
      return false;
    }
  }
  
  @override
  Future<bool> install() async {
    var result = await runCommand(installCommand, installArgs);
    if (isInstallationSuccessful(result)) {
      logInstallationSuccess(result);
      return true;
    } else {
      logInstallationError(result);
      return false;
    }
  }
  
  @override
  Future<String?> getVersion() async {
    try {
      var result = await runCommand(versionCheckCommand, versionCheckArgs);
      if (result.exitCode == 0) {
        // Extract version from output
        final output = result.stdout.toString().trim();
        final versionPattern = RegExp(r'\d+\.\d+\.\d+');
        final match = versionPattern.firstMatch(output);
        
        return match?.group(0) ?? output;
      }
      return null;
    } catch (e) {
      logger.error('Error getting version', e);
      return null;
    }
  }
  
  /// Checks if the platform is supported for this process
  bool isPlatformSupported() {
    return true; // Default implementation allows all platforms
  }
}
