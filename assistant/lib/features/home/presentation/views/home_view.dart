import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../conversations/presentation/viewmodels/conversation_viewmodel.dart';
import '../../../conversations/data/models/conversation_model.dart';
import '../../../conversations/presentation/views/conversation_view.dart';

class HomeView extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const HomeView({super.key, this.onNavigateToTab});

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Theme.of(context).colorScheme.surface,
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, Sarah', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Online · AI Ready', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/onborading/assistant.png'),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Input Card
              Material(
                borderRadius: BorderRadius.circular(16),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'How can I help you today?',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (value) {
                                // Navigate to Assistant with query
                                onNavigateToTab?.call(2);
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                IconButton(onPressed: () {}, icon: const Icon(Icons.mic)),
                                IconButton(onPressed: () {}, icon: const Icon(Icons.attachment)),
                                IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
                                ElevatedButton(
                                  onPressed: () => onNavigateToTab?.call(2),
                                  style: ElevatedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(12)),
                                  child: const Icon(Icons.send),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Quick action chips
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          ActionChip(label: const Text('Ask AI'), onPressed: () => onNavigateToTab?.call(2)),
                          ActionChip(label: const Text('Summarize Email'), onPressed: () => onNavigateToTab?.call(1)),
                          ActionChip(label: const Text('Write Content'), onPressed: () => onNavigateToTab?.call(3)),
                          ActionChip(label: const Text('Translate'), onPressed: () => onNavigateToTab?.call(1)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Action buttons grid
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _buildActionButton(context, Icons.psychology, 'Ask AI', () => onNavigateToTab?.call(2)),
                  _buildActionButton(context, Icons.email, 'Summarize Email', () => onNavigateToTab?.call(1)),
                  _buildActionButton(context, Icons.edit, 'Write Content', () => onNavigateToTab?.call(3)),
                  _buildActionButton(context, Icons.language, 'Translate', () => onNavigateToTab?.call(1)),
                  _buildActionButton(context, Icons.picture_as_pdf, 'Explain PDF', () => onNavigateToTab?.call(1)),
                  _buildActionButton(context, Icons.flash_on, 'Quick Action', () => onNavigateToTab?.call(1)),
                ],
              ),

              const SizedBox(height: 18),

              Text('Recent Chats', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Consumer<ConversationViewModel>(builder: (context, vm, _) {
                final conversations = vm.conversations.reversed.toList();
                if (conversations.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: Text('No recent chats', style: theme.textTheme.bodyMedium)),
                    ),
                  );
                }

                return Card(
                  child: Column(
                    children: List.generate(conversations.length, (i) {
                      final c = conversations[i];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(c.title),
                            subtitle: c.description != null ? Text(c.description!) : null,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              vm.selectConversation(c);
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ConversationView()));
                            },
                          ),
                          if (i != conversations.length - 1) const Divider(height: 1),
                        ],
                      );
                    }),
                  ),
                );
              }),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
