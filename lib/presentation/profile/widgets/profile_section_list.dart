import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class ProfileSectionList<T> extends StatelessWidget {
  final List<T> items;
  final String title;
  final String emptyMessage;
  final Widget Function(T item, int index, VoidCallback onEdit, VoidCallback onDelete) itemBuilder;
  final Future<T?> Function(T? existing) onAdd;
  final Function(List<T>) onChanged;
  final bool isDark;

  const ProfileSectionList({
    super.key,
    required this.items,
    required this.title,
    required this.emptyMessage,
    required this.itemBuilder,
    required this.onAdd,
    required this.onChanged,
    this.isDark = false,
  });

  Future<void> _handleEdit(BuildContext context, {T? existing, int? index}) async {
    final result = await onAdd(existing);
    if (result != null) {
      final newList = List<T>.from(items);
      if (index != null) {
        newList[index] = result;
      } else {
        newList.add(result);
      }
      onChanged(newList);
    }
  }

  Future<void> _handleDelete(BuildContext context, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmDelete),
        content: Text(AppLocalizations.of(context)!.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final newList = List<T>.from(items);
      newList.removeAt(index);
      onChanged(newList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark = isDark || Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16, 
                color: effectiveIsDark ? Colors.white : Colors.black
              )
            ),
            TextButton.icon(
              onPressed: () => _handleEdit(context),
              icon: Icon(Icons.add, color: effectiveIsDark ? Colors.white : Theme.of(context).primaryColor),
              label: Text(
                AppLocalizations.of(context)!.add, 
                style: TextStyle(color: effectiveIsDark ? Colors.white : Theme.of(context).primaryColor)
              ),
              style: TextButton.styleFrom(
                backgroundColor: effectiveIsDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              emptyMessage, 
              style: TextStyle(color: effectiveIsDark ? Colors.white54 : Colors.grey)
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return itemBuilder(
              items[index], 
              index,
              () => _handleEdit(context, existing: items[index], index: index),
              () => _handleDelete(context, index),
            );
          },
        ),
      ],
    );
  }
}
