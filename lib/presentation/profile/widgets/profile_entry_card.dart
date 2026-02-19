import 'package:flutter/material.dart';

class ProfileEntryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isDark;

  const ProfileEntryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onDelete,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      child: ListTile(
        title: Text(
          title, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: isDark ? Colors.white : Colors.black
          )
        ),
        subtitle: Text(
          subtitle, 
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
