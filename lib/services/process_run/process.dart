

abstract class Process {
  Future<bool> isInstalled();

  Future<String> runCommand(var cmd);
}