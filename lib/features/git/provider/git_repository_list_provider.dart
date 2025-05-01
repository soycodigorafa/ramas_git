import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramas_git/features/git/model/git_repository.dart';

/// Manages the state of the list of added Git repositories.
class GitRepositoryListNotifier extends StateNotifier<List<GitRepository>> {
  // Initialize with an empty list (in-memory storage for now)
  GitRepositoryListNotifier() : super([]);

  /// Adds a new repository to the list if a repository with the same path doesn't already exist.
  void addRepository(GitRepository repository) {
    // Check if a repository with the same path already exists
    if (!state.any((repo) => repo.path == repository.path)) {
      // Use state = [...] to create a new list, ensuring immutability
      state = [...state, repository];
      // TODO: Persist changes to Hive later
      print('Repository added: ${repository.name} at ${repository.path}');
    } else {
      print('Repository already exists: ${repository.path}');
    }
  }

  /// Removes a repository from the list based on its path.
  void removeRepository(String path) {
    state = state.where((repo) => repo.path != path).toList();
    // TODO: Persist changes to Hive later
    print('Repository removed: $path');
  }

  // Listing is implicitly handled by accessing the provider's state.
  // No explicit listRepositories() method needed as the state *is* the list.
}

/// Provider for accessing the GitRepositoryListNotifier.
/// 
/// Use `ref.watch(gitRepositoryListProvider)` to get the list of repositories.
/// Use `ref.read(gitRepositoryListProvider.notifier)` to access methods like addRepository/removeRepository.
final gitRepositoryListProvider = 
    StateNotifierProvider<GitRepositoryListNotifier, List<GitRepository>>((ref) {
  return GitRepositoryListNotifier();
});
