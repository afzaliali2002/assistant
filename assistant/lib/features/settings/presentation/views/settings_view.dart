import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsViewModel>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: Consumer<SettingsViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    value: viewModel.settings.darkMode,
                    onChanged: (_) {
                      viewModel.toggleDarkMode();
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Language & Region',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: viewModel.settings.language,
                    items: ['en', 'es', 'fr', 'de', 'ja', 'zh']
                        .map(
                          (lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(lang.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        viewModel.setLanguage(value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'AI Configuration',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text('Default AI Model'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: viewModel.settings.defaultAiModel,
                    items:
                        [
                              'gpt-3.5-turbo',
                              'gpt-4',
                              'gemini-pro',
                              'claude-3-sonnet-20240229',
                            ]
                            .map(
                              (model) => DropdownMenuItem(
                                value: model,
                                child: Text(model),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        viewModel.setDefaultAIModel(value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'API Keys',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  _buildAPIKeyItem(context, 'OpenAI', 'openai'),
                  _buildAPIKeyItem(context, 'Google Gemini', 'gemini'),
                  _buildAPIKeyItem(context, 'HuggingFace', 'huggingface'),
                  _buildAPIKeyItem(context, 'Anthropic', 'anthropic'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAPIKeyItem(BuildContext context, String label, String service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(label),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            _showAPIKeyDialog(context, label, service);
          },
        ),
      ),
    );
  }

  void _showAPIKeyDialog(BuildContext context, String label, String service) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $label API Key'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            labelText: '$label API Key',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SettingsViewModel>().saveAPIKey(
                service,
                controller.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
