import 'dart:io'; // For Directory and Platform checks if needed later
import 'package:process_run/process_run.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service class for interacting with Git repositories.
class GitService {

  /// Checks if the given directory path is a Git repository.
  /// 
  /// Runs `git status` in the specified directory.
  /// Returns `true` if the command exits successfully (exit code 0),
  /// indicating it's likely a Git repository, otherwise `false`.
  Future<bool> isGitRepository(String directoryPath) async {
    // Ensure the directory exists before attempting to run the command
    if (!await Directory(directoryPath).exists()) {
      print('Directory does not exist: $directoryPath');
      return false;
    }
    
    try {
      // Run 'git status' in the specified directory.
      // We don't need the output, just the exit code.
      // runExecutableArguments prevents shell interpretation issues.
      final result = await runExecutableArguments(
        'git',
        ['status'],
        workingDirectory: directoryPath,
        // Don't connect stdin/stdout/stderr to the console
        stdoutEncoding: null, 
        stderrEncoding: null,
      );
      
      // Exit code 0 typically means success for 'git status' within a repo.
      return result.exitCode == 0;
    } catch (e) {
      // Catch potential exceptions during process execution
      print('Error running git status in $directoryPath: $e');
      return false;
    }
  }

  /// Executes a Git command in the specified directory and returns the stdout.
  /// Throws an exception if the command fails.
  Future<String> _runGitCommand(String directoryPath, List<String> arguments) async {
    if (!await Directory(directoryPath).exists()) {
      throw Exception('Directory does not exist: $directoryPath');
    }

    try {
      final result = await runExecutableArguments(
        'git',
        arguments,
        workingDirectory: directoryPath,
      );

      if (result.exitCode != 0) {
        throw Exception('Git command failed: git ${arguments.join(' ')}\n${result.stderr}');
      }
      return result.stdout.trim();
    } catch (e) {
      // Rethrow or handle specific exceptions as needed
      throw Exception('Error running git ${arguments.join(' ')} in $directoryPath: $e');
    }
  }

  /// Gets the status of the Git repository.
  /// 
  /// Runs `git status --porcelain` for a machine-readable output.
  Future<String> getStatus(String directoryPath) async {
    return _runGitCommand(directoryPath, ['status', '--porcelain']);
  }

  /// Gets the list of local branches in the repository.
  /// 
  /// Runs `git branch`.
  Future<String> getBranches(String directoryPath) async {
    return _runGitCommand(directoryPath, ['branch']);
  }

  /// Gets the commit history of the repository.
  /// 
  /// Runs `git log --oneline` for a concise history.
  Future<String> getCommits(String directoryPath) async {
    // Consider adding options like -n <count> to limit the number of commits
    return _runGitCommand(directoryPath, ['log', '--oneline']);
  }

  /// Stages a specific file or directory.
  /// 
  /// Runs `git add <filePath>`.
  Future<void> stageFile(String directoryPath, String filePath) async {
    // Use _runGitCommand but ignore the output String for void methods.
    await _runGitCommand(directoryPath, ['add', filePath]);
  }

  /// Unstages a specific file or directory from the index.
  /// 
  /// Runs `git reset HEAD <filePath>`.
  Future<void> unstageFile(String directoryPath, String filePath) async {
    await _runGitCommand(directoryPath, ['reset', 'HEAD', filePath]);
  }

  /// Creates a commit with the given message.
  /// 
  /// Runs `git commit -m "message"`.
  Future<void> commit(String directoryPath, String message) async {
    await _runGitCommand(directoryPath, ['commit', '-m', message]);
  }

  /// Switches to the specified branch.
  /// 
  /// Runs `git checkout <branchName>`.
  /// Note: This can fail if there are uncommitted changes. Error handling
  /// in the ViewModel or UI layer might be needed based on the output/exception.
  Future<void> checkoutBranch(String directoryPath, String branchName) async {
    await _runGitCommand(directoryPath, ['checkout', branchName]);
  }

  /// Fetches the commit log with details needed for building a commit graph.
  /// Uses a specific format with separators for easier parsing.
  /// Format: <hash><|SEP|><parent_hashes><|SEP|><decorations><|SEP|><author><|SEP|><date><|SEP|><subject>
  Future<String> getCommitGraphLog(String directoryPath, {int? maxCount}) async {
    // Added %an (author name) and %ar (relative author date)
    const String logFormat = '%H<|SEP|>%P<|SEP|>%D<|SEP|>%an<|SEP|>%ar<|SEP|>%s';
    final List<String> args = [
      'log',
      '--all',
      '--pretty=format:$logFormat',
      '--date-order',
    ];
    if (maxCount != null && maxCount > 0) {
      args.add('-n');
      args.add(maxCount.toString());
    }
    return _runGitCommand(directoryPath, args);
  }

  // Add other Git-related methods here later (e.g., checkout, pull, push)
}

/// Provider for the GitService.
/// 
/// This makes the GitService available throughout the app via Riverpod.
final gitServiceProvider = Provider<GitService>((ref) {
  return GitService();
});
