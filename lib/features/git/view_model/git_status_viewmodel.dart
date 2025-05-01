import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/git_status_info.dart';
import '../service/git_service.dart';

/// Notifier responsible for fetching and parsing the git status for a repository.
class GitStatusViewModel extends FamilyAsyncNotifier<GitStatusInfo, String> {
  /// Fetches the status using GitService and parses the output.
  Future<GitStatusInfo> _fetchAndParseStatus(GitService gitService, String repositoryPath) async {
    try {
      final String statusOutput = await gitService.getStatus(repositoryPath);
      return _parseStatusOutput(statusOutput);
    } catch (e, stackTrace) {
      // Consider more specific error handling/logging
      print('Error fetching git status for $repositoryPath: $e\n$stackTrace');
      // Error state is handled automatically by FamilyAsyncNotifier
      rethrow; 
    }
  }

  /// Parses the output of `git status --porcelain`.
  GitStatusInfo _parseStatusOutput(String output) {
    final List<GitFileStatus> staged = [];
    final List<GitFileStatus> unstaged = [];
    final List<GitFileStatus> untracked = [];

    final List<String> lines = output.split('\n').where((line) => line.isNotEmpty).toList();

    for (final String line in lines) {
      final GitFileStatus? fileStatus = GitFileStatus.fromPorcelainLine(line);
      if (fileStatus == null) continue;

      // Categorize based on status codes
      if (fileStatus.stagedStatus == '?' && fileStatus.unstagedStatus == '?') {
        untracked.add(fileStatus);
      } else {
        // Check staged status
        if (fileStatus.stagedStatus.isNotEmpty && fileStatus.stagedStatus != ' ') {
           staged.add(fileStatus);
        }
        // Check unstaged status (ignoring files that are only staged)
        // A file can be both staged (e.g., partially) and unstaged.
        if (fileStatus.unstagedStatus.isNotEmpty && fileStatus.unstagedStatus != ' ' && fileStatus.unstagedStatus != '?') {
           unstaged.add(fileStatus);
        }
        // Handle cases like modified but not staged (e.g., ' M'), which might be missed above
        // Ensure it's not already added to unstaged if it was also staged ('MM')
        else if (fileStatus.stagedStatus == ' ' && fileStatus.unstagedStatus.isNotEmpty && fileStatus.unstagedStatus != '?') {
          if (!unstaged.any((f) => f.path == fileStatus.path)) {
             unstaged.add(fileStatus);
          }
        }
      }
    }

    return GitStatusInfo(
      staged: staged,
      unstaged: unstaged,
      untracked: untracked,
    );
  }

  /// Public method to explicitly refresh the status.
  Future<void> refreshStatus() async {
    final repositoryPath = arg; // Access the family argument
    final gitService = ref.read(gitServiceProvider);

    // Set state to loading before starting the async operation
    state = const AsyncValue.loading();
    // Refetch and update the state
    state = await AsyncValue.guard(() => _fetchAndParseStatus(gitService, repositoryPath));
  }

  /// Stages a specific file and refreshes the status.
  Future<void> stageFile(String filePath) async {
    final repositoryPath = arg;
    final gitService = ref.read(gitServiceProvider);
    state = const AsyncValue.loading(); // Show loading while action is performed
    state = await AsyncValue.guard(() async {
      await gitService.stageFile(repositoryPath, filePath);
      return _fetchAndParseStatus(gitService, repositoryPath); // Re-fetch after action
    });
  }

  /// Unstages a specific file and refreshes the status.
  Future<void> unstageFile(String filePath) async {
    final repositoryPath = arg;
    final gitService = ref.read(gitServiceProvider);
    state = const AsyncValue.loading(); // Show loading
    state = await AsyncValue.guard(() async {
      await gitService.unstageFile(repositoryPath, filePath);
      return _fetchAndParseStatus(gitService, repositoryPath); // Re-fetch after action
    });
  }

  @override
  FutureOr<GitStatusInfo> build(String repositoryPath) {
    // Keep track of the path for refresh/actions
    // Note: 'ref.keepAlive()' might be useful if you want the state
    // to persist even when the widget is unmounted.

    final gitService = ref.watch(gitServiceProvider);
    // Load initial status when the provider is first read.
    return _fetchAndParseStatus(gitService, repositoryPath);
  }
}

/// Provider for GitStatusViewModel.
/// 
/// Takes the repository path as an argument.
final gitStatusProvider = AsyncNotifierProviderFamily<GitStatusViewModel, GitStatusInfo, String>(
  GitStatusViewModel.new, // Use the constructor reference
);
