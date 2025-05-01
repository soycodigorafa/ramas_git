import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/git_actions_viewmodel.dart';
import '../view_model/git_status_viewmodel.dart'; // To refresh status view

/// A view/widget dedicated to writing a commit message and committing staged changes.
class GitCommitView extends ConsumerStatefulWidget {
  final String repositoryPath;

  const GitCommitView({required this.repositoryPath, super.key});

  @override
  ConsumerState<GitCommitView> createState() => _GitCommitViewState();
}

class _GitCommitViewState extends ConsumerState<GitCommitView> {
  final _commitMessageController = TextEditingController();

  @override
  void dispose() {
    _commitMessageController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actionsNotifier = ref.read(gitActionsProvider(widget.repositoryPath).notifier);
    final actionState = ref.watch(gitActionsProvider(widget.repositoryPath));
    final bool isLoading = actionState == ActionState.loading;

    // Listen to state changes for feedback
    ref.listen<ActionState>(gitActionsProvider(widget.repositoryPath), (previous, next) {
      if (next == ActionState.success) {
        _showSnackBar('Commit successful!');
        // Refresh the status view after successful commit
        ref.read(gitStatusProvider(widget.repositoryPath).notifier).refreshStatus();
        // Optionally navigate back or clear the message
        _commitMessageController.clear();
        // Reset state if it doesn't reset automatically elsewhere
        // or if you want immediate effect before potential navigation
         WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
             actionsNotifier.resetState();
          }
         });
        // Consider Navigator.pop(context);
      } else if (next == ActionState.error) {
        final error = actionsNotifier.lastError;
        _showSnackBar('Commit failed: ${error?.toString() ?? "Unknown error"}', isError: true);
         WidgetsBinding.instance.addPostFrameCallback((_) {
           if (mounted) {
             actionsNotifier.resetState();
           }
         });
      }
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Occupy minimum space
        children: [
          TextField(
            controller: _commitMessageController,
            decoration: const InputDecoration(
              labelText: 'Commit Message',
              hintText: 'Enter commit message',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            textInputAction: TextInputAction.done,
            enabled: !isLoading,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: isLoading
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
            label: const Text('Commit Changes'),
            onPressed: isLoading || _commitMessageController.text.trim().isEmpty
                ? null
                : () {
                    final message = _commitMessageController.text.trim();
                    // Hide keyboard
                    FocusScope.of(context).unfocus();
                    actionsNotifier.commit(message);
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40), // Make button taller
            ),
          ),
        ],
      ),
    );
  }
}
