import 'dart:io';

/// Enum representing different platform types for installation methods
enum PlatformType {
  windows,
  linux,
  macOS,
  other
}

/// Utility class for platform-specific operations
class PlatformUtils {
  /// Detects the current platform type
  static PlatformType detectPlatformType() {
    if (Platform.isWindows) return PlatformType.windows;
    if (Platform.isLinux) return PlatformType.linux;
    if (Platform.isMacOS) return PlatformType.macOS;
    return PlatformType.other;
  }
  
  /// Checks if the current platform is supported
  static bool isSupportedPlatform() {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }
  
  /// Gets the platform-specific path separator
  static String get pathSeparator => Platform.pathSeparator;
  
  /// Gets the platform-specific line ending
  static String get lineEnding => Platform.isWindows ? '\r\n' : '\n';
  
  /// Gets platform name as a string
  static String getPlatformName() {
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isFuchsia) return 'Fuchsia';
    return 'Unknown';
  }
}
