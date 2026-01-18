import 'package:flutter/material.dart';
import '../widgets/common/profile_list_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'User Name', // Placeholder
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Text(
              'user@example.com', // Placeholder
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            ProfileListItem(
              icon: Icons.person_outline,
              title: 'Personal Information',
              onTap: () {},
            ),
            ProfileListItem(
              icon: Icons.work_outline,
              title: 'Experience',
              onTap: () {},
            ),
            ProfileListItem(
              icon: Icons.school_outlined,
              title: 'Education',
              onTap: () {},
            ),
            ProfileListItem(
              icon: Icons.code,
              title: 'Skills',
              onTap: () {},
            ),
            const Divider(height: 48),
            ProfileListItem(
              icon: Icons.logout,
              title: 'Log Out',
              isDestructive: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
