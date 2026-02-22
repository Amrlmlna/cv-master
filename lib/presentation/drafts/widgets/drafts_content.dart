import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../domain/entities/cv_data.dart';

class DraftsContent extends StatelessWidget {
  final Map<String, List<CVData>> folders;
  final List<CVData> currentDrafts;
  final String? selectedFolderName;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;
  
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onFolderSelected;
  final ValueChanged<CVData> onDraftSelected;
  final ValueChanged<String> onDraftDeleted;

  const DraftsContent({
    super.key,
    required this.folders,
    required this.currentDrafts,
    required this.selectedFolderName,
    required this.searchQuery,
    required this.isLoading,
    this.errorMessage,
    required this.onSearchChanged,
    required this.onFolderSelected,
    required this.onDraftSelected,
    required this.onDraftDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedFolderName == null,
      onPopInvokedWithResult: (didPop, result) {
         if (didPop) return;
         if (selectedFolderName != null) {
           onFolderSelected(null);
        }
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedFolderName == null) ...[
                TextField(
                  controller: TextEditingController(text: searchQuery)
                    ..selection = TextSelection.fromPosition(TextPosition(offset: searchQuery.length)),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchJob,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: onSearchChanged,
                ),
                const SizedBox(height: 16),
              ] else ...[
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => onFolderSelected(null),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedFolderName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              Expanded(
                child: _buildContent(context),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text('Error: $errorMessage'));
    }

    if (selectedFolderName != null) {
      return _buildDraftList(context, currentDrafts);
    } else {
      if (folders.isEmpty) {
         return Center(child: Text(AppLocalizations.of(context)!.noDrafts));
      }
      return _buildFolderGrid(context, folders);
    }
  }

  Widget _buildFolderGrid(BuildContext context, Map<String, List<CVData>> folders) {
    final keys = folders.keys.toList()..sort();

    if (keys.isEmpty) {
       return Center(child: Text(AppLocalizations.of(context)!.noMatchingJobs));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final title = keys[index];
        final count = folders[title]!.length;
        
        return InkWell(
          onTap: () => onFolderSelected(title),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$count draft${count != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right, size: 16, color: Colors.grey[600]),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDraftList(BuildContext context, List<CVData> drafts) {
    if (drafts.isEmpty) return Center(child: Text(AppLocalizations.of(context)!.folderEmpty));
    
    return ListView.separated(
      itemCount: drafts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final draft = drafts[index];

        final version = drafts.length - index;
        
        final title = draft.jobTitle.isNotEmpty 
            ? '${draft.jobTitle} #$version' 
            : '${AppLocalizations.of(context)!.untitled} #$version';
            
        final templateName = _getTemplateName(context, draft.styleId);


        return Dismissible(
          key: Key(draft.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            onDraftDeleted(draft.id);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white.withValues(alpha: 0.05) 
                    : Colors.grey.shade200
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.blue.withValues(alpha: 0.2) 
                      : Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.description, color: Colors.blue),
              ),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(height: 4),
                    Text(
                    'Template: $templateName',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                   const SizedBox(height: 2),
                  Text(
                    '${AppLocalizations.of(context)!.created} ${timeago.format(draft.createdAt)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => onDraftSelected(draft),
            ),
          ),
        );
      },
    );
  }

  String _getTemplateName(BuildContext context, String id) {
    switch (id) {
      case 'ATS': return AppLocalizations.of(context)!.atsStandard;
      case 'Modern': return AppLocalizations.of(context)!.modernProfessional;
      case 'Creative': return AppLocalizations.of(context)!.creativeDesign;
      default: return id;
    }
  }
}
