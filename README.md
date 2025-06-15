# dokdok

DokDok is a cross-platform desktop application built with Flutter, designed to help users manage, generate, and work with Docker templates and images efficiently. The project provides a user-friendly interface for handling Docker-related workflows, including template management, code editing, and integration with various programming languages.

## Purpose

The primary purpose of DokDok is to streamline the process of creating, editing, and managing Docker templates for different programming environments. It aims to simplify Docker adoption for developers by providing ready-to-use templates, language support, and easy integration with Docker commands.

## Features

- **Docker Template Management:**  
  Create, edit, and organize Dockerfile templates for various programming languages and frameworks.

- **Language Support:**  
  Built-in support for multiple programming languages, allowing users to select and customize templates based on their stack.

- **Integrated Code Editor:**  
  Edit Docker templates directly within the application.

- **Process Integration:**  
  Run Docker commands and other processes from within the app, leveraging platform-specific process management.

- **Cross-Platform Support:**  
  Runs on Windows, Linux, and macOS desktops.

- **Database Storage:**  
  Uses SQLite (with FFI for desktop) to store templates and language metadata.

- **Modern UI:**  
  Utilizes Fluent UI for a clean, Windows-like user interface.

## Tech Stack

- **Flutter**: Main framework for building the cross-platform desktop application.
- **Dart**: Programming language for application logic.
- **Fluent UI**: For modern, responsive desktop UI components.
- **SQLite (sqflite_common_ffi)**: Local database for storing templates and language data.
- **get_it**: Dependency injection and service locator.
- **go_router**: Declarative routing for navigation.
- **file_picker**: File selection dialogs.
- **Docker**: Integration for managing containers and images.
- **Platform Support**:  
  - Windows  
  - Linux  
  - macOS

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.