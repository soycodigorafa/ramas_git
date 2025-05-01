/// Represents a parsed reference decoration (branch, tag, HEAD).
class GitRef {
  final String name;
  final RefType type;

  GitRef(this.name, this.type);

  @override
  String toString() => '$type: $name';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitRef &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode => name.hashCode ^ type.hashCode;
}

enum RefType { head, branch, remoteBranch, tag }

/// Represents a single commit node parsed from the git log output.
class CommitNodeInfo {
  final String hash;
  final List<String> parentHashes;
  final List<GitRef> refs;
  final String author;
  final String date;
  final String subject;

  CommitNodeInfo({
    required this.hash,
    required this.parentHashes,
    required this.refs,
    required this.author,
    required this.date,
    required this.subject,
  });

  /// Parses a single line from the `getCommitGraphLog` output format.
  static CommitNodeInfo? fromLogLine(String line) {
    final parts = line.split('<|SEP|>');
    if (parts.length != 6) {
      print('Warning: Skipping invalid log line format (expected 6 parts): $line');
      return null;
    }

    final hash = parts[0];
    final parentHashes = parts[1].isEmpty ? <String>[] : parts[1].split(' ');
    final decorations = parts[2];
    final author = parts[3];
    final date = parts[4];
    final subject = parts[5];

    final List<GitRef> refs = _parseDecorations(decorations);

    return CommitNodeInfo(
      hash: hash,
      parentHashes: parentHashes,
      refs: refs,
      author: author,
      date: date,
      subject: subject,
    );
  }

  /// Parses the decoration string (e.g., " (HEAD -> main, tag: v1.0, origin/main)").
  static List<GitRef> _parseDecorations(String decorationString) {
    if (decorationString.trim().isEmpty) return [];

    // Remove surrounding parentheses if present
    String cleaned = decorationString.trim();
    if (cleaned.startsWith('(') && cleaned.endsWith(')')) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }

    final List<GitRef> refs = [];
    final parts = cleaned.split(', ');

    for (final part in parts) {
      if (part.isEmpty) continue;

      if (part == 'HEAD' || part.startsWith('HEAD ->')) {
        // Extract branch name if HEAD points to one
        final headBranch =
            part.split(' -> ').length > 1 ? part.split(' -> ').last : 'HEAD';
        refs.add(GitRef(headBranch, RefType.head));
        // If HEAD points to a branch, also add the branch ref itself if not already present
        if (headBranch != 'HEAD' &&
            !parts.any((p) => p == headBranch && !p.contains('/'))) {
          // Heuristic: Check if it looks like a local branch
          if (!headBranch.contains('/')) {
            refs.add(GitRef(headBranch, RefType.branch));
          }
        }
      } else if (part.startsWith('tag: ')) {
        refs.add(GitRef(part.substring('tag: '.length), RefType.tag));
      } else if (part.contains('/')) {
        // Basic assumption: contains '/' means remote branch
        refs.add(GitRef(part, RefType.remoteBranch));
      } else {
        // Assume local branch
        refs.add(GitRef(part, RefType.branch));
      }
    }
    // Remove duplicates that might arise from HEAD -> branch logic
    return refs.toSet().toList();
  }

  @override
  String toString() {
    return 'CommitNodeInfo{hash: $hash, parents: $parentHashes, refs: $refs, author: $author, date: $date, subject: $subject}';
  }
}
