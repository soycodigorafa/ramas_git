import 'package:freezed_annotation/freezed_annotation.dart';

part 'git_status_info.freezed.dart';

/// Represents the parsed status of a Git repository.
@freezed
class GitStatusInfo with _$GitStatusInfo {
  const factory GitStatusInfo({
    /// Files staged for commit (Added, Modified, Deleted, Renamed, Copied).
    @Default([]) List<GitFileStatus> staged,

    /// Files with unstaged changes (Modified, Deleted).
    @Default([]) List<GitFileStatus> unstaged,

    /// Files that are not tracked by Git.
    @Default([]) List<GitFileStatus> untracked,
  }) = _GitStatusInfo;
}

/// Represents the status of a single file.
@freezed
class GitFileStatus with _$GitFileStatus {
  const factory GitFileStatus({
    required String path,
    required String stagedStatus,
    required String unstagedStatus,
  }) = _GitFileStatus;

  /// Creates a GitFileStatus from a line of `git status --porcelain` output.
  /// Returns null if the line is not valid.
  static GitFileStatus? fromPorcelainLine(String line) {
    if (line.length < 4) return null; // Need at least 'XY ' + path

    final String staged = line.substring(0, 1);
    final String unstaged = line.substring(1, 2);
    String path = line.substring(3);

    // Handle renamed/copied files (R/C) which have format 'XY oldpath -> newpath'
    // For simplicity here, we'll just take the new path.
    // A more robust parser might store both old and new paths.
    if ((staged == 'R' || staged == 'C' || unstaged == 'R' || unstaged == 'C') && path.contains(' -> ')) {
      path = path.split(' -> ').last;
    }

    return GitFileStatus(
      path: path,
      stagedStatus: staged.trim(),
      unstagedStatus: unstaged.trim(),
    );
  }
}
