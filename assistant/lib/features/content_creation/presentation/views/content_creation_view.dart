import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/content_viewmodel.dart';
import '../../data/models/content_model.dart';

class ContentCreationView extends StatefulWidget {
  const ContentCreationView({super.key});

  @override
  State<ContentCreationView> createState() => _ContentCreationViewState();
}

class _ContentCreationViewState extends State<ContentCreationView> {
  final TextEditingController _promptController = TextEditingController();
  ContentType _selectedType = ContentType.article;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContentCreationViewModel>().loadContents();
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Creation'), elevation: 0),
      body: Consumer<ContentCreationViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Generate Content',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<ContentType>(
                    isExpanded: true,
                    value: _selectedType,
                    items: ContentType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _promptController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Describe the content you want to generate...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: viewModel.isGenerating
                          ? null
                          : () {
                              if (_promptController.text.isNotEmpty) {
                                viewModel.generateContent(
                                  prompt: _promptController.text,
                                  type: _selectedType,
                                  keywords: [],
                                );
                              }
                            },
                      child: viewModel.isGenerating
                          ? const CircularProgressIndicator()
                          : const Text('Generate Content'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Your Contents',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  if (viewModel.contents.isEmpty)
                    Center(
                      child: Text(
                        'No content yet',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.contents.length,
                      itemBuilder: (context, index) {
                        final content = viewModel.contents[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(content.title),
                            subtitle: Text(content.type.name),
                            trailing: Chip(
                              label: Text(
                                content.isPublished ? 'Published' : 'Draft',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
