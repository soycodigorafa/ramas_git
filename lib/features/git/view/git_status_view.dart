import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/git_status_info.dart';
import '../view_model/git_status_viewmodel.dart';

/// Displays the Git status (staged, unstaged, untracked files)
/// and allows staging/unstaging files.
class GitStatusView extends ConsumerWidget {
  final String repositoryPath;

  const GitStatusView({required this.repositoryPath, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(gitStatusProvider(repositoryPath));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Git Status'),
        // Optionally add a refresh button
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(gitStatusProvider(repositoryPath).notifier).refreshStatus(),
            tooltip: 'Refresh Status',
          ),
        ],
      ),
      body: statusAsync.when(
        data: (statusInfo) => _buildStatusContent(context, ref, statusInfo),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          print('Error in GitStatusView: $error\n$stackTrace');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Failed to load Git status: \n${error.toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusContent(BuildContext context, WidgetRef ref, GitStatusInfo statusInfo) {
    // Combine all files for easier rendering if needed, or keep separate
    // Here we build sections
    if (statusInfo.staged.isEmpty && statusInfo.unstaged.isEmpty && statusInfo.untracked.isEmpty) {
      return const Center(child: Text('No changes detected.'));
    }

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        if (statusInfo.staged.isNotEmpty)
          _buildFileSection(
            context,
            ref,
            title: 'Staged Changes (${statusInfo.staged.length})',
            files: statusInfo.staged,
            actionType: _FileActionType.unstage,
          ),
        if (statusInfo.unstaged.isNotEmpty)
          _buildFileSection(
            context,
            ref,
            title: 'Unstaged Changes (${statusInfo.unstaged.length})',
            files: statusInfo.unstaged,
            actionType: _FileActionType.stage,
          ),
        if (statusInfo.untracked.isNotEmpty)
          _buildFileSection(
            context,
            ref,
            title: 'Untracked Files (${statusInfo.untracked.length})',
            files: statusInfo.untracked,
            actionType: _FileActionType.stageUntracked,
          ),
      ],
    );
  }

  Widget _buildFileSection(
    BuildContext context,
    WidgetRef ref,
    {
      required String title,
      required List<GitFileStatus> files,
      required _FileActionType actionType,
    }
  ) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Disable inner scrolling
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                final String statusText = _getFileStatusText(file);
                final Color statusColor = _getFileStatusColor(file, colors);

                return ListTile(
                  dense: true,
                  leading: _buildActionButton(ref, file.path, actionType),
                  title: Text(file.path),
                  trailing: Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(WidgetRef ref, String filePath, _FileActionType actionType) {
    final notifier = ref.read(gitStatusProvider(repositoryPath).notifier);
    final Icon icon;
    final VoidCallback onPressed;
    final String tooltip;

    switch (actionType) {
      case _FileActionType.stage:
      case _FileActionType.stageUntracked:
        icon = const Icon(Icons.add, size: 20);
        onPressed = () => notifier.stageFile(filePath);
        tooltip = 'Stage File';
        break;
      case _FileActionType.unstage:
        icon = const Icon(Icons.remove, size: 20);
        onPressed = () => notifier.unstageFile(filePath);
        tooltip = 'Unstage File';
        break;
    }

    // Use IconButton for better accessibility and hit area
    return IconButton(
      icon: icon,
      tooltip: tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(), // Remove default padding
    );
  }

  // Helper to get display text for status (e.g., 'M', 'A', 'D', '??')
  String _getFileStatusText(GitFileStatus file) {
    if (file.stagedStatus == '?' && file.unstagedStatus == '?') return '??'; // Untracked
    if (file.stagedStatus == 'A') return 'A'; // Added
    if (file.stagedStatus == 'M') return 'M'; // Modified Staged
    if (file.stagedStatus == 'D') return 'D'; // Deleted Staged
    if (file.unstagedStatus == 'M') return 'M'; // Modified Unstaged
    if (file.unstagedStatus == 'D') return 'D'; // Deleted Unstaged
    // Add more cases for R, C, U etc. if needed
    return '${file.stagedStatus}${file.unstagedStatus}'.trim(); // Fallback
  }

  // Helper to get color based on status
  Color _getFileStatusColor(GitFileStatus file, ColorScheme colors) {
    if (file.stagedStatus == '?' && file.unstagedStatus == '?') return colors.secondary; // Untracked
    if (file.stagedStatus == 'A' || file.unstagedStatus == 'A') return Colors.green; // Added
    if (file.stagedStatus == 'D' || file.unstagedStatus == 'D') return colors.error; // Deleted
    if (file.stagedStatus == 'M' || file.unstagedStatus == 'M') return Colors.blue; // Modified
    // Add more cases for R, C, U etc. if needed
    return colors.onSurface.withOpacity(0.7); // Default/Fallback
  }
}

enum _FileActionType {
  stage,
  unstage,
  stageUntracked // Functionally same as stage, but helps categorize sections
}
