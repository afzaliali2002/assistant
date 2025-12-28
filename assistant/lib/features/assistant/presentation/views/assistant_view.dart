import 'package:flutter/material.dart';

class AssistantView extends StatefulWidget {
  const AssistantView({super.key});

  @override
  State<AssistantView> createState() => _AssistantViewState();
}

class _AssistantViewState extends State<AssistantView> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(role: Role.assistant, text: 'Hello! How can I assist you today?'),
    _ChatMessage(role: Role.user, text: 'Summarize my recent emails.'),
    _ChatMessage(role: Role.assistant, text: 'Here\'s a summary of your recent emails:\n\n• Team Meeting Reminder: HR scheduled a team meeting...\n• Invoice from John Doe: A \$550 invoice...\n• Newsletter from Fitness Daily: Contains tips on staying active...'),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(role: Role.user, text: text));
      _messages.add(_ChatMessage(role: Role.assistant, text: 'Working on "$text"...'));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.smart_toy),
                const SizedBox(width: 8),
                Text('Assistant', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.history)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                if (m.role == Role.user) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(color: theme.colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(12)),
                        child: Text(m.text),
                      ),
                    ),
                  );
                }

                // assistant bubble with card style
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: const [CircleAvatar(child: Icon(Icons.smart_toy)), SizedBox(width: 8), Text('Assistant', style: TextStyle(fontWeight: FontWeight.bold))]),
                            const SizedBox(height: 8),
                            Text(m.text),
                            const SizedBox(height: 12),
                            Row(children: [
                              TextButton(onPressed: () {}, child: const Text('Copy')),
                              const SizedBox(width: 8),
                              TextButton(onPressed: () {}, child: const Text('Regenerate')),
                              const SizedBox(width: 8),
                              TextButton(onPressed: () {}, child: const Text('Share')),
                              const Spacer(),
                              ElevatedButton(onPressed: () {}, child: const Text('Upgrade')),
                            ])
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // suggestions row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Wrap(
              spacing: 8,
              children: [
                ActionChip(label: const Text('Summarize my emails'), onPressed: () => setState(() => _controller.text = 'Summarize my emails')),
                ActionChip(label: const Text('Translate text'), onPressed: () => setState(() => _controller.text = 'Translate this text')),
                ActionChip(label: const Text('Create a post'), onPressed: () => setState(() => _controller.text = 'Create a post about...')),
                ActionChip(label: const Text('Plan my day'), onPressed: () => setState(() => _controller.text = 'Plan my day')),
              ],
            ),
          ),

          // input bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: theme.colorScheme.surface),
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.mic)),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Ask me anything...', border: InputBorder.none),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(onPressed: _sendMessage, icon: const Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum Role { user, assistant }

class _ChatMessage {
  final Role role;
  final String text;
  _ChatMessage({required this.role, required this.text});
}
