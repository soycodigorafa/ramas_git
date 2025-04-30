import 'package:flutter/material.dart';
import 'package:ramas_git/presentation/git_module/repo_list_view.dart';
import 'package:ramas_git/presentation/git_module/add_repo_dialog.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 260,
      color: Colors.grey[200],
      child: Column(
        children: [
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await showAddRepoDialog(context, ref);
            },
            icon: const Icon(Icons.add),
            label: const Text('Agregar repositorio'),
          ),
          const SizedBox(height: 24),
          const Expanded(child: RepoListView()),
        ],
      ),
    );
  }
}
