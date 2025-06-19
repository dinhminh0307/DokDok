import 'package:dokdok/services/log/interface.dart';import 'package:dokdok/services/process_run/interface.dart';
import 'dart:io';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_run.dart';
import 'package:process_run/stdio.dart';

class DockerProcess extends BaseProcess implements InstallableProcess {
  DockerProcess(super.logger);
  @override
  Future<bool> isInstalled() async {
    var res = await runCommand('docker', ['--version']);
    if (res.exitCode == 0) {
      return true;
    } else {
      logger.error('Command not found: ${res.toString()}');
      return false;
    }
  }

  @override
  Future<bool> install() async {
    var res = await runCommand('choco', ['install', 'docker-desktop', '-y']);
    if (res.exitCode == 0) {
      logger.info('Docker installation started: ${res.stdout}');
      return true;
    } else {
      logger.error('Failed to start Docker installation: ${res.stderr}');
      return false;
    }
  }
}