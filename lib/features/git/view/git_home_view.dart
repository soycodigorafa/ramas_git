import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramas_git/features/git/view_model/git_home_view_model.dart';
import 'git_graph_view.dart';

class GitHomeView extends ConsumerWidget {
  const GitHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(gitHomeViewModelProvider);
    final repositories = viewModel.repositories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Git Branch Manager - Home'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.selectAndAddRepository(context),
        tooltip: 'Añadir Repositorio',
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                    ),
                    child: Text(
                      'Navegación',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      context.goNamed('home');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.folder_copy),
                    title: Text('Repositorios (${repositories.length})'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Repositorios: Próximamente')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Configuración'),
                    onTap: () {
                      context.pushNamed('settings');
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: repositories.isEmpty
                  ? const Center(
                      child: Text(
                        'Añade un repositorio usando el botón (+) en la barra superior.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: repositories.length,
                      itemBuilder: (context, index) {
                        final repo = repositories[index];
                        return ListTile(
                          title: Text(repo.name),
                          subtitle: Text(repo.path),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GitGraphView(repositoryPath: repo.path),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            tooltip: 'Quitar Repositorio',
                            onPressed: () {
                              viewModel.removeRepository(repo.path);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
