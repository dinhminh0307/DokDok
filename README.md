# dokdok

DokDok is a cross-platform desktop application built with Flutter, designed to help users manage, generate, and work with Docker templates and images efficiently. The project provides a user-friendly interface for handling Docker-related workflows, including template management, code editing, and integration with various programming languages.

## Purpose

The primary purpose of DokDok is to streamline the process of creating, editing, and managing Docker templates for different programming environments. It aims to simplify Docker adoption for developers by providing ready-to-use templates, language support, and easy integration with Docker commands.

## Features

- **Docker Template Management:**  
  Create, edit, and organize Dockerfile templates for various programming languages and frameworks.

- **Language Support:**  
  Built-in support for detecting multiple programming languages, allowing users to select and customize templates based on their stack.

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

## Upcoming Features

DokDok is actively being developed, and the following features are planned for future releases:

- **AI-Generated Docker Scripts:**  
  Automatically generate Dockerfiles using AI based on your project folder, reducing manual setup and configuration.

- **Visual Dockerfile Editing:**  
  Edit Dockerfile content using visual blocks, making it easier to customize and understand Docker instructions without deep Docker knowledge.

- **Advanced Container Management:**  
  Full CRUD (Create, Read, Update, Delete) operations for Docker containers directly from the app.

- **DockerHub Integration:**  
  - **Login to DockerHub:** Authenticate and manage your DockerHub account within the app.
  - **Pull/Push Images:** Seamlessly pull images from and push images to DockerHub.

- **Port and Traffic Management:**  
  Specify ports, view port mappings, and monitor container network traffic visually.

- **Service, Network, and Volume Management:**  
  - **Drag and Drop Service Connections:** Visually connect and manage multiple services, networks, and volumes using a drag-and-drop interface.

These features aim to make DokDok a powerful, user-friendly tool for both beginners and advanced Docker users, streamlining container development and

## Tech Stack

- **Flutter**: Main framework for building the cross-platform desktop application.
- **Dart**: Programming language for application logic.
- **Fluent UI**: For modern, responsive desktop UI components.
- **SQLite (sqflite_common_ffi)**: Local database for storing templates and language data.
- **get_it**: Dependency injection and service locator.
- **go_router**: Declarative routing for navigation.
- **file_picker**: File selection dialogs.
- **Docker**: Integration for managing containers and images.
- **Tokei**: Scan and detect the techstack from project codebase
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