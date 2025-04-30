import 'package:ramas_git/infrastructure/git_module/repo_local_datasource.dart';

class RepoInfo {
  final String name;
  final String path;
  final String lastAction;

  RepoInfo({required this.name, required this.path, required this.lastAction});

  factory RepoInfo.fromMap(Map<String, dynamic> map) => RepoInfo(
        name: map['name'] as String,
        path: map['path'] as String,
        lastAction: map['lastAction'] as String? ?? '',
      );
}

class RepoManager {
  static Future<List<RepoInfo>> loadRepos() async {
    final list = await RepoLocalDatasource.getRepos();
    return list.map((e) => RepoInfo.fromMap(e)).toList();
  }

  static Future<void> addRepo(RepoInfo repo) async {
    await RepoLocalDatasource.insertRepo(
      name: repo.name,
      path: repo.path,
      lastAction: repo.lastAction,
    );
  }
}
