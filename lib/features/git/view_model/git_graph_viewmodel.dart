import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphview/GraphView.dart'; // Import graphview

import '../model/git_graph_models.dart';
import '../service/git_service.dart';

/// Notifier responsible for fetching commit data and building the commit graph.
class GitGraphViewModel extends FamilyAsyncNotifier<Graph, String> {
  // Cache the parsed commit info along with the graph
  Map<String, CommitNodeInfo> _commitInfoCache = {};

  @override
  FutureOr<Graph> build(String repositoryPath) async {
    // Consider adding a parameter for max commits, e.g., build(String repositoryPath, {int maxCommits = 200})
    final gitService = ref.watch(gitServiceProvider);
    return _fetchAndBuildGraph(gitService, repositoryPath);
  }

  /// Fetches the commit log, parses it, and builds the Graph object.
  Future<Graph> _fetchAndBuildGraph(
      GitService gitService, String repositoryPath,
      {int maxCommits = 200}) async {
    try {
      final String logOutput = await gitService
          .getCommitGraphLog(repositoryPath, maxCount: maxCommits);
      final List<String> lines =
          logOutput.split('\n').where((l) => l.isNotEmpty).toList();

      final Graph graph = Graph();
      final Map<String, Node> nodes = {};
      final Map<String, CommitNodeInfo> commitInfoMap =
          {}; // Local map for this build

      // First pass: Create nodes for all commits found
      for (final line in lines) {
        final CommitNodeInfo? commitInfo = CommitNodeInfo.fromLogLine(line);
        if (commitInfo != null) {
          // Use full hash for node ID uniqueness
          final node = Node.Id(commitInfo.hash);
          nodes[commitInfo.hash] = node;
          commitInfoMap[commitInfo.hash] = commitInfo;
        } else {
          print('Skipping node creation for invalid line: $line');
        }
      }

      // Update the cache after successful parsing
      _commitInfoCache = Map.from(commitInfoMap);

      // Second pass: Add edges (parent -> child)
      for (final commitInfo in commitInfoMap.values) {
        final Node? childNode = nodes[commitInfo.hash];
        if (childNode == null) {
          print('Error: Child node not found for hash ${commitInfo.hash}');
          continue;
        }

        if (commitInfo.parentHashes.isEmpty && nodes.length > 1) {
          // If a node has no parents but isn't the only node, it's likely the root.
          // graphview often expects a single root or handles it internally,
          // but ensure it's added to the graph if not connected by edges later.
          if (!graph.nodes.contains(childNode)) {
            // graph.addNode(childNode); // Nodes are implicitly added via edges
          }
        }

        for (final parentHash in commitInfo.parentHashes) {
          final Node? parentNode = nodes[parentHash];
          if (parentNode != null) {
            // Add edge from parent to child
            graph.addEdge(parentNode, childNode);
          } else {
            // Parent might be outside the maxCount limit
            print(
                'Warning: Parent node $parentHash not found for child ${commitInfo.hash}. Might be beyond maxCount.');
            // If parent is missing, ensure child is still added if it's a root of the visible graph section
            if (!graph.nodes.contains(childNode)) {
              // graph.addNode(childNode); // Nodes are implicitly added via edges
            }
          }
        }
      }

      // Basic check for graph consistency (optional)
      print(
          'Graph built with ${graph.nodeCount()} nodes and ${graph.edges.length} edges.');
      if (graph.nodeCount() == 0 && lines.isNotEmpty) {
        print('Warning: Graph is empty despite non-empty log output.');
      }

      return graph;
    } catch (e, stackTrace) {
      print(
          'Error fetching or building commit graph for $repositoryPath: $e\n$stackTrace');
      // Let the AsyncNotifier handle the error state
      rethrow;
    }
  }

  /// Allows retrieving the parsed commit info for a given node hash.
  CommitNodeInfo? getCommitInfoForNode(String hash) {
    return _commitInfoCache[hash];
  }

  /// Public method to explicitly refresh the graph.
  Future<void> refreshGraph({int? maxCommits}) async {
    final repositoryPath = arg; // Access the family argument
    final gitService = ref.read(gitServiceProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchAndBuildGraph(
        gitService, repositoryPath,
        maxCommits: maxCommits ?? 200));
  }
}

/// Provider for GitGraphViewModel.
/// Takes the repository path as an argument.
final gitGraphProvider =
    AsyncNotifierProviderFamily<GitGraphViewModel, Graph, String>(
  GitGraphViewModel.new,
);
