import 'package:flutter/material.dart';

class ActionView extends StatefulWidget {
  const ActionView({super.key});

  @override
  State<ActionView> createState() => _ActionViewState();
}

class _ActionViewState extends State<ActionView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _inputController = TextEditingController();
  String _result = '';
  final List<Map<String, dynamic>> _actions = [
    {'icon': Icons.edit, 'label': 'Write'},
    {'icon': Icons.article, 'label': 'Summarize'},
    {'icon': Icons.language, 'label': 'Translate'},
    {'icon': Icons.code, 'label': 'Code'},
    {'icon': Icons.email, 'label': 'Email'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _actions.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _onPrimaryAction() {
    setState(() {
      final tab = _tabController.index;
      switch (tab) {
        case 0:
          _result = 'Generated content for: ${_inputController.text}';
          break;
        case 1:
          _result = 'Summary for: ${_inputController.text}';
          break;
        case 2:
          _result = 'Translation of: ${_inputController.text}';
          break;
        case 3:
          _result = 'Generated code for: ${_inputController.text}';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
                Expanded(child: Text('Action', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              ],
            ),
          ),
          // Action selector row
          SizedBox(
            height: 96,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final a = _actions[index];
                final selected = _tabController.index == index;
                return InkWell(
                  onTap: () => setState(() => _tabController.index = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 120,
                    decoration: BoxDecoration(
                      color: selected ? theme.colorScheme.primary : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: selected ? [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.15), blurRadius: 8)] : null,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(a['icon'], color: selected ? Colors.white : theme.colorScheme.primary),
                        const SizedBox(height: 8),
                        Text(a['label'], style: TextStyle(color: selected ? Colors.white : null)),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: _actions.length,
            ),
          ),

          // Input row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter input:'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        decoration: InputDecoration(
                          hintText: 'Paste or type text...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.mic)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.copy)),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        decoration: InputDecoration(hintText: 'Paste URL...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: _onPrimaryAction, child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Generate'))),
                ),
                const SizedBox(height: 12),
                // Smart suggestions
                const Text('Smart suggestions'),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      ...['Identify action items', 'Translate an email', 'Summarize this', 'Generate a list'].map((t) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ActionChip(label: Text(t), onPressed: () => setState(() => _inputController.text = t)),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWriteTab(),
                _buildSummarizeTab(),
                _buildTranslateTab(),
                _buildCodeTab(),
                // Fallback empty view for extra 'Email' action
                Center(child: Text('Email action will be implemented here')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWriteTab() {
    return _buildCommonColumn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tone:'),
          const SizedBox(height: 8),
          Row(children: [
            DropdownButton<String>(value: 'Creative', items: const [DropdownMenuItem(value: 'Creative', child: Text('Creative'))], onChanged: (_) {}),
            const SizedBox(width: 12),
            DropdownButton<String>(value: 'Medium', items: const [DropdownMenuItem(value: 'Medium', child: Text('Medium'))], onChanged: (_) {}),
          ]),
        ],
      ),
    );
  }

  Widget _buildSummarizeTab() {
    return _buildCommonColumn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Document.pdf'),
              subtitle: const Text('1.2 MB'),
              trailing: TextButton(onPressed: () {}, child: const Text('Remove')),
            ),
          ),
          const SizedBox(height: 8),
          ToggleButtons(isSelected: const [false, true, false], onPressed: (_) {}, children: const [Padding(padding: EdgeInsets.symmetric(horizontal:12), child: Text('Short')), Padding(padding: EdgeInsets.symmetric(horizontal:12), child: Text('Medium')), Padding(padding: EdgeInsets.symmetric(horizontal:12), child: Text('Detailed'))]),
        ],
      ),
    );
  }

  Widget _buildTranslateTab() {
    return _buildCommonColumn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: DropdownButton<String>(value: 'French', items: const [DropdownMenuItem(value: 'French', child: Text('From: French'))], onChanged: (_) {})),
            const SizedBox(width: 8),
            Expanded(child: DropdownButton<String>(value: 'English', items: const [DropdownMenuItem(value: 'English', child: Text('To: English'))], onChanged: (_) {})),
          ])
        ],
      ),
    );
  }

  Widget _buildCodeTab() {
    return _buildCommonColumn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: DropdownButton<String>(value: 'Python', items: const [DropdownMenuItem(value: 'Python', child: Text('Language: Python'))], onChanged: (_) {})),
            const SizedBox(width: 8),
            Expanded(child: DropdownButton<String>(value: 'Enabled', items: const [DropdownMenuItem(value: 'Enabled', child: Text('Comments: Enabled'))], onChanged: (_) {})),
          ])
        ],
      ),
    );
  }

  Widget _buildCommonColumn({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            const SizedBox(height: 12),
            if (_result.isNotEmpty) ...[
              Text('Generated', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_result),
                      const SizedBox(height: 12),
                      Row(children: [
                        TextButton(onPressed: () {}, child: const Text('Copy')),
                        const SizedBox(width: 8),
                        TextButton(onPressed: () { _onPrimaryAction(); }, child: const Text('Regenerate')),
                        const SizedBox(width: 8),
                        TextButton(onPressed: () {}, child: const Text('Share')),
                      ])
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
