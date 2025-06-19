import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide IconButton;

class ToastBuilder {

  static void show({
    required BuildContext context,
    required String title,
    InfoBarSeverity severity = InfoBarSeverity.info,
    Duration? duration,
    bool isLong = false,
  }) {
    displayInfoBar(
      context,
      duration: duration ?? const Duration(seconds: 4),
      builder: (context, close) {
        return InfoBar(
          title: Text(title),
          severity: severity,
          isLong: isLong,
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
        );
      },
    );
  }

  /// Shows a success toast
  static void showSuccess(BuildContext context, String message, {Duration? duration}) {
    show(
      context: context,
      title: message,
      severity: InfoBarSeverity.success,
      duration: duration,
    );
  }

  /// Shows an error toast
  static void showError(BuildContext context, String message, {Duration? duration}) {
    show(
      context: context,
      title: message,
      severity: InfoBarSeverity.error,
      duration: duration,
    );
  }

  /// Shows a warning toast
  static void showWarning(BuildContext context, String message, {Duration? duration}) {
    show(
      context: context,
      title: message,
      severity: InfoBarSeverity.warning,
      duration: duration,
    );
  }

  /// Shows an information toast
  static void showInfo(BuildContext context, String message, {Duration? duration}) {
    show(
      context: context,
      title: message,
      severity: InfoBarSeverity.info,
      duration: duration,
    );
  }
}