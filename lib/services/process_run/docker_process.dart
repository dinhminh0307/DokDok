import 'package:dokdok/services/process_run/process.dart';
import 'dart:io';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_run.dart';
import 'package:process_run/stdio.dart';

class DockerProcess implements Process{
  @override
  Future<bool> isInstalled() async {
    var cmd = ProcessCmd('docker', ['--version']);
    var res = await runCmd(cmd);
    if (res.exitCode == 0) {
      return true;
    } else {
      print('Command not found: ${cmd.toString()}');
      return false;
    }
  }

  @override
  Future<String> runCommand(var cmd) async {
    var res = await runCmd(cmd);
    if (res.exitCode == 0) {
      return res.stdout.toString();
    } else {
      print('Error running command: ${cmd.toString()}');
      print('Exit code: ${res.exitCode}');
      print('Error: ${res.stderr}');
      return '';
    }
  }

  Future<bool> installDocker() async {
    // This example uses Chocolatey for Windows. Adjust for your OS as needed.
    var cmd = ProcessCmd('choco', ['install', 'docker-desktop', '-y']);
    var res = await runCmd(cmd, verbose: true);
    if (res.exitCode == 0) {
      print('Docker installation started: ${res.stdout}');
      return true;
    } else {
      print('Failed to start Docker installation: ${res.stderr}');
      return false;
    }
  }
}