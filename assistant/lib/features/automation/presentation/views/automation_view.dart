import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/automation_viewmodel.dart';
import '../../data/models/automation_model.dart';

class AutomationView extends StatefulWidget {
  const AutomationView({super.key});

  @override
  State<AutomationView> createState() => _AutomationViewState();
}

class _AutomationViewState extends State<AutomationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AutomationViewModel>().loadAutomations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Automations'), elevation: 0),
      body: Consumer<AutomationViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.automations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings_suggest,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No automations yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first automation to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: viewModel.automations.length,
            itemBuilder: (context, index) {
              final automation = viewModel.automations[index];
              return AutomationCard(automation: automation);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create automation
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AutomationCard extends StatelessWidget {
  final Automation automation;

  const AutomationCard({super.key, required this.automation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(automation.name),
        subtitle: Text(
          '${automation.trigger.name} → ${automation.action.name}',
        ),
        trailing: Switch(
          value: automation.isEnabled,
          onChanged: (_) {
            context.read<AutomationViewModel>().toggleAutomation(automation.id);
          },
        ),
        onTap: () {
          context.read<AutomationViewModel>().selectAutomation(automation);
        },
      ),
    );
  }
}
