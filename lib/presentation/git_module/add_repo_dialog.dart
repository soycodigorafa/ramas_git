import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ramas_git/application/git_module/repo_manager.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramas_git/presentation/git_module/repo_list_provider.dart';

Future<void> showAddRepoDialog(BuildContext context, WidgetRef ref) async {
  final result = await FilePicker.platform.getDirectoryPath();
  if (result == null) return;

  final dir = Directory(result);
  final gitDir = Directory('${dir.path}/.git');
  if (!await gitDir.exists()) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('No es un repositorio Git'),
            content: const Text(
              'La carpeta seleccionada no contiene un directorio .git.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
    );
    return;
  }

  final repo = RepoInfo(
    name: dir.path.split(Platform.pathSeparator).last,
    path: dir.path,
    lastAction: 'Añadido',
  );
  await ref.read(repoListProvider.notifier).addRepo(repo);

  // Removed unconditional Navigator.pop(context) to prevent popping the home route.
}
