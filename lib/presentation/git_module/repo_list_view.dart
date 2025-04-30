import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramas_git/presentation/git_module/repo_list_provider.dart';

class RepoListView extends ConsumerWidget {
  const RepoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoListAsync = ref.watch(repoListProvider);
    return repoListAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (repos) {
        if (repos.isEmpty) {
          return const Center(child: Text('No hay repositorios agregados.'));
        }
        return ListView.separated(
          itemCount: repos.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final repo = repos[i];
            return ListTile(
              leading: const Icon(Icons.folder),
              title: Text(repo.name),
              subtitle: Text(repo.path),
              trailing: Text(repo.lastAction),
              onTap: () {
                // TODO: Abrir el repo
              },
            );
          },
        );
      },
    );
  }
}
