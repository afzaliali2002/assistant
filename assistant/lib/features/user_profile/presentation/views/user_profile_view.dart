import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_viewmodel.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserProfileViewModel>();
    final user = vm.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                child: user == null
                    ? const Icon(Icons.person, size: 40)
                    : Text(
                        (user.fullName.isNotEmpty)
                            ? user.fullName[0].toUpperCase()
                            : user.email[0].toUpperCase(),
                        style: const TextStyle(fontSize: 32),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Name: ${user?.fullName ?? "—"}'),
            const SizedBox(height: 8),
            Text('Email: ${user?.email ?? "—"}'),
            const SizedBox(height: 8),
            Text('ID: ${user?.id ?? "—"}'),
          ],
        ),
      ),
    );
  }
}
