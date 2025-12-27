import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/knowledge_viewmodel.dart';
import '../../data/models/knowledge_model.dart';

class KnowledgeBaseView extends StatefulWidget {
  const KnowledgeBaseView({super.key});

  @override
  State<KnowledgeBaseView> createState() => _KnowledgeBaseViewState();
}

class _KnowledgeBaseViewState extends State<KnowledgeBaseView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KnowledgeViewModel>().loadItems();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Knowledge Base'), elevation: 0),
      body: Consumer<KnowledgeViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => viewModel.search(value),
                  decoration: InputDecoration(
                    hintText: 'Search knowledge...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: viewModel.searchResults.isEmpty
                    ? Center(
                        child: Text(
                          'No knowledge items found',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        itemCount: viewModel.searchResults.length,
                        itemBuilder: (context, index) {
                          final item = viewModel.searchResults[index];
                          return KnowledgeCard(item: item);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create knowledge item
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class KnowledgeCard extends StatelessWidget {
  final KnowledgeItem item;

  const KnowledgeCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(item.title),
        subtitle: item.category != null ? Text(item.category!) : null,
        trailing: IconButton(
          icon: Icon(
            item.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: item.isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            context.read<KnowledgeViewModel>().toggleFavorite(item.id);
          },
        ),
        onTap: () {
          context.read<KnowledgeViewModel>().selectItem(item);
        },
      ),
    );
  }
}
