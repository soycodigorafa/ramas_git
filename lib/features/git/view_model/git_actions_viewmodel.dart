import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/git_service.dart';

// Enum to represent the state of an action
enum ActionState { idle, loading, success, error }

/// Notifier to handle Git actions like commit and checkout.
/// It holds the state of the *last* action performed.
class GitActionsViewModel extends FamilyNotifier<ActionState, String> {
  late GitService _gitService;
  late String _repositoryPath;
  Object? _lastError;

  @override
  ActionState build(String repositoryPath) {
    _repositoryPath = repositoryPath;
    _gitService = ref.watch(gitServiceProvider);
    return ActionState.idle; // Initial state
  }

  /// Returns the error object from the last failed action.
  Object? get lastError => _lastError;

  /// Executes a given Git action, updating the state accordingly.
  Future<void> _runAction(Future<void> Function() action) async {
    state = ActionState.loading;
    _lastError = null;
    try {
      await action();
      state = ActionState.success;
    } catch (e) {
      _lastError = e;
      state = ActionState.error;
      print('Git action failed for $_repositoryPath: $e');
      // Optionally rethrow or handle specific errors
    }
  }

  /// Commits staged changes with the given message.
  Future<void> commit(String message) async {
    await _runAction(() => _gitService.commit(_repositoryPath, message));
  }

  /// Checks out the specified branch.
  Future<void> checkoutBranch(String branchName) async {
    await _runAction(() => _gitService.checkoutBranch(_repositoryPath, branchName));
  }

   /// Resets the state back to idle, e.g., after showing a success/error message.
  void resetState() {
    state = ActionState.idle;
    _lastError = null;
  }
}

/// Provider for GitActionsViewModel.
/// Takes the repository path as an argument.
final gitActionsProvider = NotifierProviderFamily<GitActionsViewModel, ActionState, String>(
  GitActionsViewModel.new,
);
