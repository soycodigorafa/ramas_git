import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramas_git/application/git_module/repo_manager.dart';

final repoListProvider = StateNotifierProvider<RepoListNotifier, AsyncValue<List<RepoInfo>>>(
  (ref) => RepoListNotifier(),
);

class RepoListNotifier extends StateNotifier<AsyncValue<List<RepoInfo>>> {
  RepoListNotifier() : super(const AsyncLoading()) {
    loadRepos();
  }

  Future<void> loadRepos() async {
    state = const AsyncLoading();
    try {
      final repos = await RepoManager.loadRepos();
      state = AsyncData(repos);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addRepo(RepoInfo repo) async {
    await RepoManager.addRepo(repo);
    await loadRepos();
  }
}
