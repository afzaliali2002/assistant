import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/voice_vision_viewmodel.dart';

class VoiceVisionView extends StatefulWidget {
  const VoiceVisionView({super.key});

  @override
  State<VoiceVisionView> createState() => _VoiceVisionViewState();
}

class _VoiceVisionViewState extends State<VoiceVisionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice & Vision'), elevation: 0),
      body: Consumer<VoiceVisionViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voice Input',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: viewModel.isRecording
                          ? () => viewModel.stopRecording('audio_path')
                          : () => viewModel.startRecording(),
                      icon: Icon(
                        viewModel.isRecording ? Icons.stop : Icons.mic,
                      ),
                      label: Text(
                        viewModel.isRecording
                            ? 'Stop Recording'
                            : 'Start Recording',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (viewModel.voiceInputs.isNotEmpty) ...[
                    Text(
                      'Voice History',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.voiceInputs.length,
                      itemBuilder: (context, index) {
                        final voiceInput = viewModel.voiceInputs[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Icon(Icons.mic),
                            title: Text(
                              voiceInput.transcription ?? 'Processing...',
                            ),
                            subtitle: Text(voiceInput.status.name),
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 32),
                  Text(
                    'Image Processing',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: viewModel.isProcessing
                          ? null
                          : () => viewModel.processImage('image_path'),
                      icon: const Icon(Icons.image),
                      label: const Text('Upload Image'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (viewModel.images.isNotEmpty) ...[
                    Text(
                      'Processed Images',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.images.length,
                      itemBuilder: (context, index) {
                        final imageData = viewModel.images[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Icon(Icons.image),
                            title: Text(
                              imageData.description ?? 'Processing...',
                            ),
                            subtitle: Text(
                              'Objects: ${imageData.detectedObjects.join(", ")}',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
