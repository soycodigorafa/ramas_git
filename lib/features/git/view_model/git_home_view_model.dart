import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:ramas_git/features/git/model/git_repository.dart';
import 'package:ramas_git/features/git/provider/git_repository_list_provider.dart';
import 'package:ramas_git/features/git/service/git_service.dart';

class GitHomeViewModel {
  final Ref _ref;

  GitHomeViewModel(this._ref);

  // Expose the list of repositories by watching the provider
  List<GitRepository> get repositories => _ref.watch(gitRepositoryListProvider);

  // Get instances of other providers needed
  GitService get _gitService => _ref.read(gitServiceProvider);
  GitRepositoryListNotifier get _listNotifier =>
      _ref.read(gitRepositoryListProvider.notifier);

  /// Handles the process of selecting a directory and adding it as a repository.
  /// Shows feedback via SnackBar.
  Future<void> selectAndAddRepository(BuildContext context) async {
    final String? selectedDirectory =
        await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Selecciona un repositorio Git',
    );

    if (selectedDirectory != null) {
      final bool isRepo = await _gitService.isGitRepository(selectedDirectory);
      final String repoName = p.basename(selectedDirectory);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isRepo
                  ? 'Repositorio Git válido encontrado: $repoName'
                  : 'La carpeta seleccionada no es un repositorio Git válido.',
            ),
            backgroundColor: isRepo ? Colors.green : Colors.red,
          ),
        );
      }

      if (isRepo) {
        final newRepository = GitRepository(
          name: repoName,
          path: selectedDirectory,
        );
        _listNotifier.addRepository(newRepository);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selección de carpeta cancelada.')),
        );
      }
    }
  }

  /// Removes a repository from the list by its path.
  void removeRepository(String path) {
    _listNotifier.removeRepository(path);
  }
}

/// Provider for the GitHomeViewModel.
final gitHomeViewModelProvider = Provider<GitHomeViewModel>((ref) {
  return GitHomeViewModel(ref);
});
