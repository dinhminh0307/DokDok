import 'package:fluent_ui/fluent_ui.dart';

/// Model class to hold Docker image and container information
class DockerImageInfo {
  final String imageName;
  final String imageTag;
  final bool buildAfterCreation;
  
  // Container-specific settings
  final bool runContainer;
  final bool mapPort;
  final String hostPort;
  final String containerPort;
  
  const DockerImageInfo({
    this.imageName = '',
    this.imageTag = 'latest',
    this.buildAfterCreation = false,
    
    // Container options
    this.runContainer = false,
    this.mapPort = false,
    this.hostPort = '8080',
    this.containerPort = '80',
  });
}

/// Modal dialog to collect Docker image and container information
class DockerImageInformationDialog extends StatefulWidget {
  final DockerImageInfo initialInfo;
  
  const DockerImageInformationDialog({
    Key? key, 
    this.initialInfo = const DockerImageInfo(),
  }) : super(key: key);

  @override
  State<DockerImageInformationDialog> createState() => _DockerImageInformationDialogState();
}

class _DockerImageInformationDialogState extends State<DockerImageInformationDialog> {
  late TextEditingController _imageNameController;
  late TextEditingController _imageTagController;
  late TextEditingController _hostPortController;
  late TextEditingController _containerPortController;
  late bool _buildAfterCreation;
  late bool _runContainer;
  late bool _mapPort;

  @override
  void initState() {
    super.initState();
    _imageNameController = TextEditingController(text: widget.initialInfo.imageName);
    _imageTagController = TextEditingController(text: widget.initialInfo.imageTag);
    _hostPortController = TextEditingController(text: widget.initialInfo.hostPort);
    _containerPortController = TextEditingController(text: widget.initialInfo.containerPort);
    _buildAfterCreation = widget.initialInfo.buildAfterCreation;
    _runContainer = widget.initialInfo.runContainer;
    _mapPort = widget.initialInfo.mapPort;
  }

  @override
  void dispose() {
    _imageNameController.dispose();
    _imageTagController.dispose();
    _hostPortController.dispose();
    _containerPortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Docker Configuration'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Provide information for your Docker image:'),
            const SizedBox(height: 20),
            
            // Image section
            const Text('Image Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // Image name
            InfoLabel(
              label: 'Image Name (Required)',
              child: TextBox(
                controller: _imageNameController,
                placeholder: 'my-app',
                onChanged: (value) => setState(() {}),
              ),
            ),
            const SizedBox(height: 10),
            
            // Image tag
            InfoLabel(
              label: 'Image Tag',
              child: TextBox(
                controller: _imageTagController,
                placeholder: 'latest',
              ),
            ),
            const SizedBox(height: 10),
            
            // Build after creation toggle
            ToggleSwitch(
              checked: _buildAfterCreation,
              onChanged: (value) {
                setState(() {
                  _buildAfterCreation = value;
                  // If building is disabled, container running should also be disabled
                  if (!value) {
                    _runContainer = false;
                  }
                });
              },
              content: const Text('Build Image After Creation'),
            ),
            
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            
            // Container section (only shown if buildAfterCreation is true)
            if (_buildAfterCreation) ...[
              const Text('Container Settings', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              // Run container toggle
              ToggleSwitch(
                checked: _runContainer,
                onChanged: (value) {
                  setState(() {
                    _runContainer = value;
                  });
                },
                content: const Text('Run Container After Build'),
              ),
              const SizedBox(height: 10),
              
              // Port mapping (only if run container is enabled)
              if (_runContainer) ...[
                ToggleSwitch(
                  checked: _mapPort,
                  onChanged: (value) {
                    setState(() {
                      _mapPort = value;
                    });
                  },
                  content: const Text('Map Container Port to Host'),
                ),
                const SizedBox(height: 10),
                
                // Port mapping fields (only if port mapping is enabled)
                if (_mapPort) ...[
                  Row(
                    children: [
                      Expanded(
                        child: InfoLabel(
                          label: 'Host Port',
                          child: TextBox(
                            controller: _hostPortController,
                            placeholder: '8080',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('→', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InfoLabel(
                          label: 'Container Port',
                          child: TextBox(
                            controller: _containerPortController,
                            placeholder: '80',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
      actions: [
        Button(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        FilledButton(
          child: const Text('Continue'),
          onPressed: _imageNameController.text.trim().isEmpty
              ? null  // Disable button if image name is empty
              : () {
                  Navigator.pop(
                    context,
                    DockerImageInfo(
                      imageName: _imageNameController.text.trim(),
                      imageTag: _imageTagController.text.trim().isEmpty 
                          ? 'latest' 
                          : _imageTagController.text.trim(),
                      buildAfterCreation: _buildAfterCreation,
                      runContainer: _runContainer,
                      mapPort: _mapPort,
                      hostPort: _hostPortController.text.trim(),
                      containerPort: _containerPortController.text.trim(),
                    ),
                  );
                },
        ),
      ],
    );
  }
}