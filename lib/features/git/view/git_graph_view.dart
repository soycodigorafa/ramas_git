import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/git_graph_models.dart';
import '../view_model/git_graph_viewmodel.dart';

/// A view that displays the Git commit history as a graph.
class GitGraphView extends ConsumerWidget {
  final String repositoryPath;

  const GitGraphView({required this.repositoryPath, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graphAsync = ref.watch(gitGraphProvider(repositoryPath));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commit History Graph'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(gitGraphProvider(repositoryPath).notifier)
                .refreshGraph(),
            tooltip: 'Refresh Graph',
          ),
        ],
      ),
      body: graphAsync.when(
        data: (graph) {
          if (graph.nodeCount() == 0) {
            return const Center(
                child: Text('No commit history found or loaded.'));
          }

          // Get all commit info from the view model
          final viewModel = ref.read(gitGraphProvider(repositoryPath).notifier);
          final List<CommitNodeInfo> commits = [];

          // Collect all commits from the graph
          for (final node in graph.nodes) {
            final String hash = node.key?.value as String;
            final commitInfo = viewModel.getCommitInfoForNode(hash);
            if (commitInfo != null) {
              commits.add(commitInfo);
            }
          }

          // Sort commits by date (most recent first)
          // This is a simple approach - you might need a more sophisticated sorting
          // based on the actual commit graph structure
          commits.sort((a, b) => b.date.compareTo(a.date));

          return Column(
            children: [
              // Header row
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  border: Border(
                      bottom:
                          BorderSide(color: Theme.of(context).dividerColor)),
                ),
                child: Row(
                  children: [
                    // Git lines column
                    const SizedBox(width: 60),
                    // Commit column
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Commit',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    // Author column
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Author',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    // SHA column
                    SizedBox(
                      width: 80,
                      child: Text(
                        'SHA',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    // Date column
                    SizedBox(
                      width: 120,
                      child: Text(
                        'Date',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
              // Commit list
              Expanded(
                child: ListView.builder(
                  itemCount: commits.length,
                  itemBuilder: (context, index) {
                    return _buildCommitRow(context, commits[index]);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          print('Error in GitGraphView: $error\n$stackTrace');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Failed to load commit graph: \n${error.toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds a row for a single commit in the ListView
  Widget _buildCommitRow(BuildContext context, CommitNodeInfo commitInfo) {
    final shortHash = commitInfo.hash.substring(0, 7);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Git lines column - placeholder for branch lines visualization
            SizedBox(
              width: 60,
              child: _buildGitLines(context, commitInfo),
            ),

            // Commit column - subject and refs
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Commit subject
                  Text(
                    commitInfo.subject,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Refs (if any)
                  if (commitInfo.refs.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Wrap(
                        spacing: 4.0,
                        runSpacing: 2.0,
                        children: commitInfo.refs
                            .map((ref) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: _getRefColor(ref.type, colorScheme),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    ref.name,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),

            // Author column
            Expanded(
              flex: 2,
              child: Text(
                commitInfo.author,
                style: textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // SHA column
            SizedBox(
              width: 80,
              child: Text(
                shortHash,
                style: textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  color: colorScheme.primary,
                ),
              ),
            ),

            // Date column
            SizedBox(
              width: 120,
              child: Text(
                commitInfo.date,
                style: textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a visualization of git branch lines
  Widget _buildGitLines(BuildContext context, CommitNodeInfo commitInfo) {
    // Extract information about this commit
    final bool isHead = commitInfo.refs.any((ref) => ref.type == RefType.head);
    final bool hasBranch = commitInfo.refs.any((ref) =>
        ref.type == RefType.branch || ref.type == RefType.remoteBranch);

    // Check if this is the first commit (no parents)
    final bool isFirstCommit = commitInfo.parentHashes.isEmpty;

    // Check if this is a merge commit (has multiple parents)
    final bool isMergeCommit = commitInfo.parentHashes.length > 1;

    // Get branch information
    final List<String> branchNames = commitInfo.refs
        .where((ref) =>
            ref.type == RefType.branch || ref.type == RefType.remoteBranch)
        .map((ref) => ref.name)
        .toList();

    // Determine branch index for coloring
    int branchIndex = 0;
    if (branchNames.isNotEmpty) {
      // Simple hash function to get consistent colors for the same branch
      final int hashCode = branchNames.first.hashCode.abs();
      branchIndex = hashCode % 5; // Limit to 5 colors
    }

    // Calculate branch lane based on commit hash to ensure consistency
    int branchLane = 0;
    if (!isFirstCommit) {
      // Use hash to determine a consistent lane for this commit's branch
      final int hashValue = commitInfo.hash.hashCode.abs();
      // For merge commits, use a different calculation to ensure proper positioning
      branchLane =
          isMergeCommit ? 0 : (hashValue % 3); // 0, 1, or 2 for branch lanes
    }

    return CustomPaint(
      size: const Size(60, 30), // Slightly taller to accommodate curves
      painter: GitLinesPainter(
        isHead: isHead,
        hasBranch: hasBranch,
        parentCount: commitInfo.parentHashes.length,
        colorScheme: Theme.of(context).colorScheme,
        branchIndex: branchIndex,
        branchLane: branchLane,
        alignLeft: true, // Align main branch to the left
        isFirstCommit: isFirstCommit, // Pass whether this is the first commit
        isMergeCommit: isMergeCommit, // Pass whether this is a merge commit
      ),
    );
  }

  /// Determines the background color for a ref chip.
  Color _getRefColor(RefType type, ColorScheme colors) {
    switch (type) {
      case RefType.head:
        return colors.primary; // Or a distinct color like orange
      case RefType.branch:
        return Colors.green;
      case RefType.remoteBranch:
        return Colors.orange;
      case RefType.tag:
        return Colors.purple;
    }
  }
}

/// Custom painter for drawing git branch lines
class GitLinesPainter extends CustomPainter {
  final bool isHead;
  final bool hasBranch;
  final int parentCount;
  final ColorScheme colorScheme;
  final int branchIndex;
  final int branchLane;
  final bool alignLeft;
  final bool isFirstCommit;
  final bool isMergeCommit;

  GitLinesPainter({
    required this.isHead,
    required this.hasBranch,
    required this.parentCount,
    required this.colorScheme,
    this.branchIndex = 0,
    this.branchLane = 0,
    this.alignLeft = false,
    this.isFirstCommit = false,
    this.isMergeCommit = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = alignLeft ? 15.0 : size.width / 2;
    final double centerY = size.height / 2;
    final double radius = 5.0; // Aumentado para mejor visibilidad

    // Define branch colors - similar to the image shared
    final List<Color> branchColors = [
      Colors.blue, // Main branch - blue
      Colors.green, // Feature branch - green
      Colors.red, // Hotfix branch - red
      Colors.orange, // Release branch - orange
      Colors.purple, // Other branch - purple
      Colors.teal, // Other branch - teal
    ];

    // Draw branch lines first (so they appear behind the dots)
    _drawBranchLines(canvas, size, branchColors);

    // Draw the commit dot
    final Paint dotPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // Línea más gruesa

    // White fill for all commit dots
    final Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Different border colors based on commit type
    if (isHead) {
      // HEAD commit has a filled blue circle
      dotPaint.color = branchColors[0];
      dotPaint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(centerX, centerY), radius, dotPaint);
      
      // Add white border for contrast
      final Paint borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(Offset(centerX, centerY), radius, borderPaint);
    } else if (hasBranch) {
      // Branch commits have white fill with colored border
      canvas.drawCircle(Offset(centerX, centerY), radius, fillPaint);
      
      // Colored border for branch commits
      dotPaint.color = branchColors[branchIndex % branchColors.length];
      dotPaint.style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(centerX, centerY), radius, dotPaint);
    } else {
      // Regular commits have white fill with grey border
      canvas.drawCircle(Offset(centerX, centerY), radius, fillPaint);
      
      dotPaint.color = Colors.grey;
      dotPaint.style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(centerX, centerY), radius, dotPaint);
    }
  }

  /// Draw the branch lines similar to the image but with better branch nesting
  void _drawBranchLines(Canvas canvas, Size size, List<Color> branchColors) {
    // Calculate positions based on alignment preference
    final double leftMargin = 15.0; // Ajustado para alinear mejor con la imagen
    final double laneSpacing = 12.0; // Espaciado entre carriles ajustado
    final double centerY = size.height / 2;
    final double radius = 5.0; // Aumentado para coincidir con el tamaño del punto

    // Define branch lane positions - now with more lanes to the left for nesting
    final List<double> branchLanes = [
      leftMargin, // Main branch (leftmost)
      leftMargin + laneSpacing, // Branch lane 1
      leftMargin + laneSpacing * 2, // Branch lane 2
      leftMargin + laneSpacing * 3, // Branch lane 3
      leftMargin + laneSpacing * 4, // Branch lane 4
      leftMargin + laneSpacing * 5, // Branch lane 5
    ];

    // Determine the current commit's lane position
    final double currentLaneX = isFirstCommit || isMergeCommit
        ? branchLanes[
            0] // Initial commit or merge commit is always on main branch
        : branchLanes[branchLane]; // Other commits use their assigned lane

    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5; // Líneas más gruesas para mejor visibilidad

    // Draw all branch lanes that should be visible
    // This creates the continuous lines through all commits
    _drawContinuousBranchLines(
        canvas, size, branchLanes, branchColors, linePaint);

    // Draw the specific connections for this commit
    if (isFirstCommit) {
      // Initial commit - only draw line going up
      linePaint.color = branchColors[0];
      canvas.drawLine(
        Offset(currentLaneX, centerY),
        Offset(currentLaneX, 0),
        linePaint,
      );
    } else if (isMergeCommit) {
      // Merge commit - draw connections from other branches
      _drawMergeConnections(canvas, centerY, radius, currentLaneX, branchLanes,
          branchColors, linePaint);
    } else if (hasBranch) {
      // Branch commit - draw branch going to a different lane
      _drawBranchConnections(canvas, size, centerY, radius, currentLaneX,
          branchLanes, branchColors, linePaint);
    }
  }

  /// Draw continuous branch lines through the commit
  void _drawContinuousBranchLines(Canvas canvas, Size size,
      List<double> branchLanes, List<Color> branchColors, Paint linePaint) {
    // Draw main branch line (always visible)
    linePaint.color = branchColors[0];
    linePaint.strokeCap = StrokeCap.round; // Líneas con extremos redondeados
    
    canvas.drawLine(
      Offset(branchLanes[0], 0),
      Offset(branchLanes[0], size.height),
      linePaint,
    );

    // Draw other branch lines based on the branch lane
    // This ensures branches continue through all commits
    if (!isFirstCommit) {
      // Draw other branch lines that should be visible
      for (int i = 1; i <= min(branchLane + 2, branchLanes.length - 1); i++) {
        if (i < branchLanes.length && i < branchColors.length) {
          linePaint.color = branchColors[i % branchColors.length];

          // Skip the current commit's lane if it's a merge target
          if (isMergeCommit && i == branchLane) continue;

          canvas.drawLine(
            Offset(branchLanes[i], 0),
            Offset(branchLanes[i], size.height),
            linePaint,
          );
        }
      }
    }
  }

  /// Draw connections for merge commits
  void _drawMergeConnections(
      Canvas canvas,
      double centerY,
      double radius,
      double currentLaneX,
      List<double> branchLanes,
      List<Color> branchColors,
      Paint linePaint) {
    // For each potential parent (up to 3 shown), draw a merge line
    for (int i = 1; i <= min(parentCount, 3); i++) {
      final int colorIndex = i % branchColors.length;
      linePaint.color = branchColors[colorIndex];
      linePaint.strokeCap = StrokeCap.round; // Líneas con extremos redondeados

      // Determine source lane for this parent
      final double sourceLaneX = branchLanes[min(i, branchLanes.length - 1)];

      // Create a curved path from source branch to the merge commit
      final Path mergePath = Path()
        ..moveTo(sourceLaneX, 0) // Start at top of source branch
        ..lineTo(sourceLaneX, centerY - radius - 5) // Go down to just above the commit
        ..quadraticBezierTo(
            sourceLaneX,
            centerY, // Control point
            currentLaneX,
            centerY // End point at the commit dot
            );

      // Usar drawPath con el estilo de trazo adecuado
      canvas.drawPath(mergePath, linePaint);
    }
  }

  /// Draw connections for branch commits
  void _drawBranchConnections(
      Canvas canvas,
      Size size,
      double centerY,
      double radius,
      double currentLaneX,
      List<double> branchLanes,
      List<Color> branchColors,
      Paint linePaint) {
    // Determine target lane for the branch
    final int targetLaneIndex = min(branchLane + 1, branchLanes.length - 1);
    final double targetLaneX = branchLanes[targetLaneIndex];

    // Use branch color based on the branch index
    final Color branchColor = branchColors[branchIndex % branchColors.length];
    linePaint.color = branchColor;
    linePaint.strokeCap = StrokeCap.round; // Líneas con extremos redondeados

    // Create a curved path from current lane to target branch lane
    final Path branchPath = Path()
      ..moveTo(currentLaneX, centerY) // Start at the commit dot
      ..lineTo(currentLaneX, centerY + radius + 5) // Go down past the radius
      ..quadraticBezierTo(
          (currentLaneX + targetLaneX) / 2,
          centerY + 15, // Control point
          targetLaneX,
          centerY + 20 // End point on target branch lane
          )
      ..lineTo(targetLaneX, size.height); // Continue down to bottom

    canvas.drawPath(branchPath, linePaint);
  }

  @override
  bool shouldRepaint(GitLinesPainter oldDelegate) {
    return oldDelegate.isHead != isHead ||
        oldDelegate.hasBranch != hasBranch ||
        oldDelegate.parentCount != parentCount ||
        oldDelegate.branchIndex != branchIndex ||
        oldDelegate.branchLane != branchLane ||
        oldDelegate.alignLeft != alignLeft ||
        oldDelegate.isFirstCommit != isFirstCommit ||
        oldDelegate.isMergeCommit != isMergeCommit;
  }
}
