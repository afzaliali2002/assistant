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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<SettingsViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
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
                    child: Row(
                      children: [
                         const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/onborading/assistant.png'), // Placeholder or use network image
                          // child: Icon(Icons.person, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ali Danish Afzali ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'alidanishafzali21@gmail.com',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            // Navigate to Edit Profile
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            side: BorderSide(color: isDark ? Colors.grey : Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Assistant Preferences',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          context,
                          'Tone',
                          'Friendly',
                          onTap: () {
                             _showToneSelection(context);
                          },
                        ),
                        _buildDivider(isDark),
                        _buildSettingsItem(
                          context,
                          'Response Length',
                          'Medium',
                          onTap: () {
                            _showResponseLengthSelection(context);
                          },
                        ),
                        _buildDivider(isDark),
                        _buildSettingsItem(
                          context,
                          'Language',
                          'English', // Map viewModel.settings.language to readable name
                          onTap: () {
                            // Show language selection
                          },
                        ),
                        _buildDivider(isDark),
                         ListTile(
                          title: const Text('AI Mode'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Smart',
                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white),
                              ],
                            ),
                          ),
                          onTap: () {
                             // Show AI mode selection
                          },
                         ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSimpleSettingsItem(context, 'Notifications'),
                        _buildDivider(isDark),
                        _buildSimpleSettingsItem(context, 'Privacy & Security'),
                         _buildDivider(isDark),
                        _buildSimpleSettingsItem(context, 'Appearance', onTap: () {
                            viewModel.toggleDarkMode();
                        }),
                        _buildDivider(isDark),
                        _buildSimpleSettingsItem(context, 'Storage & Performance'),
                        _buildDivider(isDark),
                        _buildSimpleSettingsItem(context, 'Help & About'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle logout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                   const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, String value, {VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
        ],
      ),
      onTap: onTap,
    );
  }
  
    Widget _buildSimpleSettingsItem(BuildContext context, String title, {VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      title: Text(title),
      trailing: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
      onTap: onTap,
    );
  }


  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: isDark ? Colors.grey[800] : Colors.grey[100],
    );
  }

  void _showToneSelection(BuildContext context) {
    // Implementation for Tone Selection BottomSheet or Dialog
  }
  
  void _showResponseLengthSelection(BuildContext context) {
    // Implementation for Response Length Selection
  }
}
