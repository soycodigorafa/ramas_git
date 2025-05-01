import 'package:freezed_annotation/freezed_annotation.dart';

part 'git_repository.freezed.dart';
part 'git_repository.g.dart';

/// Represents a Git repository managed by the application.
@freezed
class GitRepository with _$GitRepository {
  const factory GitRepository({
    required String name,
    required String path,
    DateTime? lastCommitDate, // Optional: Might not be available initially
  }) = _GitRepository;

  /// Factory constructor for creating a new GitRepository instance from JSON data.
  factory GitRepository.fromJson(Map<String, dynamic> json) =>
      _$GitRepositoryFromJson(json);
}
