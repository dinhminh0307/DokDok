import 'dart:io';

import 'package:dokdok/services/log/interface.dart';
import 'package:process_run/cmd_run.dart';
abstract class CommandRunner {
  Future<ProcessResult> runCommand(String command, List<String> arguments);
}

class BaseProcess implements CommandRunner {
  final Log logger;

  BaseProcess(this.logger);

  @override
  Future<ProcessResult> runCommand(String command, List<String> arguments) async {
    var cmd = ProcessCmd(command, arguments);
    return await runCmd(cmd);
  }
}

abstract class InstallableProcess {
  Future<bool> isInstalled();
  Future<bool> install();
}