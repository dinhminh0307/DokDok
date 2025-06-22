import 'dart:io';
import 'package:process_run/cmd_run.dart';

/// Interface for basic command execution
abstract class CommandRunner {
  /// Runs a command with the specified arguments and returns the result
  Future<ProcessResult> runCommand(String command, List<String> arguments);
}

/// Interface for processes that can be checked for installation status
abstract class InstallableProcess {
  /// Checks if the process is installed
  Future<bool> isInstalled();
  
  /// Installs the process
  Future<bool> install();
}

/// Interface for processes that have version information
abstract class VersionedProcess {
  /// Gets the version of the process
  Future<String?> getVersion();
}

/// Base implementation of CommandRunner
class BaseCommandRunner implements CommandRunner {
  final ProcessRunner _processRunner;
  
  BaseCommandRunner({ProcessRunner? processRunner}) 
      : _processRunner = processRunner ?? ProcessRunner();
  
  @override
  Future<ProcessResult> runCommand(String command, List<String> arguments) async {
    return await _processRunner.runCommand(command, arguments);
  }
}

/// Utility class to run processes
class ProcessRunner {  Future<ProcessResult> runCommand(String command, List<String> arguments) async {
    var cmd = ProcessCmd(command, arguments);
    return await runCmd(cmd);
  }
}
