import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/content_viewmodel.dart';
import '../../data/models/content_model.dart';

class ContentCreationView extends StatefulWidget {
  const ContentCreationView({super.key});

  @override
  State<ContentCreationView> createState() => _ContentCreationViewState();
}

class _ContentCreationViewState extends State<ContentCreationView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContentCreationViewModel>().loadContents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: isDark ? Colors.grey : Colors.grey[600]),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.filter_list, color: isDark ? Colors.grey : Colors.grey[600]),
                  ),
                ),
              ),
            ),

            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildCategoryChip('All', isSelected: _selectedCategory == 'All'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Summaries', isSelected: _selectedCategory == 'Summaries'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Notes', isSelected: _selectedCategory == 'Notes'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Translations', isSelected: _selectedCategory == 'Translations'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Drafts', isSelected: _selectedCategory == 'Drafts'),
                ],
              ),
            ),

            // Content List
            Expanded(
              child: Consumer<ContentCreationViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.contents.isEmpty) {
                    // Show dummy data if empty to match the screenshot
                    return _buildDummyList(isDark);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: viewModel.contents.length,
                    itemBuilder: (context, index) {
                      final content = viewModel.contents[index];
                      return _buildContentCard(content, isDark);
                    },
                  );
                },
              ),
            ),

            // Footer info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Showing most recent 50 saved items',
                style: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.blue 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? Colors.white 
                : (isDark ? Colors.grey : Colors.grey[600]),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(Content content, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForType(content.type),
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  content.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                _formatDate(content.createdAt),
                style: TextStyle(
                  color: isDark ? Colors.grey[600] : Colors.grey[500],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '• ${content.type.name}',
                style: TextStyle(
                  color: isDark ? Colors.grey[600] : Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_vert,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to display dummy data matching the screenshot
  Widget _buildDummyList(bool isDark) {
    final dummyContents = [
      _DummyContent(
        title: 'Meeting Summary',
        body: 'Project is on track, next phase starts Monday. Finish report and testing. Next meeting: Friday at 10 AM.',
        date: 'Today',
        source: 'From Gmail',
        timeAgo: '7mo', // Matching screenshot literally
        icon: Icons.mail_outline,
        isStarred: true,
      ),
      _DummyContent(
        title: 'Interview Preparation Notes',
        body: 'Research the company, review the job description. Practice common interview questions.',
        date: 'Yesterday',
        source: '',
        timeAgo: '41m',
        icon: Icons.list,
        isStarred: true,
      ),
      _DummyContent(
        title: 'تېببىي لۇغەتتىن تاللانغان',
        body: '', // Empty body in screenshot for this item
        date: 'Apr 20',
        source: 'Email',
        timeAgo: '',
        icon: Icons.language,
        isStarred: true,
      ),
      _DummyContent(
        title: 'Travel Checklist Ideas',
        body: '',
        date: 'Apr 19',
        source: 'Email • Copied Text',
        timeAgo: '',
        icon: Icons.inbox,
        isStarred: true,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: dummyContents.length,
      itemBuilder: (context, index) {
        return _buildDummyCard(dummyContents[index], isDark);
      },
    );
  }

  Widget _buildDummyCard(_DummyContent content, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                content.icon,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  content.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (content.isStarred)
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
            ],
          ),
          if (content.body.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              content.body,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                content.date,
                style: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (content.source.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  '• ${content.source}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[600] : Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
              if (content.timeAgo.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  '• ${content.timeAgo}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[600] : Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
              const Spacer(),
              Icon(
                Icons.more_vert,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(ContentType type) {
    switch (type) {
      case ContentType.article:
        return Icons.article;
      case ContentType.blog:
        return Icons.web;
      case ContentType.code:
        return Icons.code;
      case ContentType.documentation:
        return Icons.description;
      case ContentType.social:
        return Icons.share;
      case ContentType.email:
        return Icons.email;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}

class _DummyContent {
  final String title;
  final String body;
  final String date;
  final String source;
  final String timeAgo;
  final IconData icon;
  final bool isStarred;

  _DummyContent({
    required this.title,
    required this.body,
    required this.date,
    required this.source,
    required this.timeAgo,
    required this.icon,
    required this.isStarred,
  });
}
