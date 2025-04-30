import 'package:flutter/material.dart';
import 'package:ramas_git/presentation/git_module/sidebar.dart';
import 'package:ramas_git/presentation/git_module/repo_history_view.dart';

class GitMainView extends StatelessWidget {
  const GitMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: RepoHistoryView(),
          ),
        ],
      ),
    );
  }
}
