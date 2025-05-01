// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'git_status_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GitStatusInfo {
  /// Files staged for commit (Added, Modified, Deleted, Renamed, Copied).
  List<GitFileStatus> get staged => throw _privateConstructorUsedError;

  /// Files with unstaged changes (Modified, Deleted).
  List<GitFileStatus> get unstaged => throw _privateConstructorUsedError;

  /// Files that are not tracked by Git.
  List<GitFileStatus> get untracked => throw _privateConstructorUsedError;

  /// Create a copy of GitStatusInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GitStatusInfoCopyWith<GitStatusInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GitStatusInfoCopyWith<$Res> {
  factory $GitStatusInfoCopyWith(
          GitStatusInfo value, $Res Function(GitStatusInfo) then) =
      _$GitStatusInfoCopyWithImpl<$Res, GitStatusInfo>;
  @useResult
  $Res call(
      {List<GitFileStatus> staged,
      List<GitFileStatus> unstaged,
      List<GitFileStatus> untracked});
}

/// @nodoc
class _$GitStatusInfoCopyWithImpl<$Res, $Val extends GitStatusInfo>
    implements $GitStatusInfoCopyWith<$Res> {
  _$GitStatusInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GitStatusInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? staged = null,
    Object? unstaged = null,
    Object? untracked = null,
  }) {
    return _then(_value.copyWith(
      staged: null == staged
          ? _value.staged
          : staged // ignore: cast_nullable_to_non_nullable
              as List<GitFileStatus>,
      unstaged: null == unstaged
          ? _value.unstaged
          : unstaged // ignore: cast_nullable_to_non_nullable
              as List<GitFileStatus>,
      untracked: null == untracked
          ? _value.untracked
          : untracked // ignore: cast_nullable_to_non_nullable
              as List<GitFileStatus>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GitStatusInfoImplCopyWith<$Res>
    implements $GitStatusInfoCopyWith<$Res> {
  factory _$$GitStatusInfoImplCopyWith(
          _$GitStatusInfoImpl value, $Res Function(_$GitStatusInfoImpl) then) =
      __$$GitStatusInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<GitFileStatus> staged,
      List<GitFileStatus> unstaged,
      List<GitFileStatus> untracked});
}

/// @nodoc
class __$$GitStatusInfoImplCopyWithImpl<$Res>
    extends _$GitStatusInfoCopyWithImpl<$Res, _$GitStatusInfoImpl>
    implements _$$GitStatusInfoImplCopyWith<$Res> {
  __$$GitStatusInfoImplCopyWithImpl(
      _$GitStatusInfoImpl _value, $Res Function(_$GitStatusInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of GitStatusInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? staged = null,
    Object? unstaged = null,
    Object? untracked = null,
  }) {
    return _then(_$GitStatusInfoImpl(
      staged: null == staged
          ? _value._staged
          : staged // ignore: cast_nullable_to_non_nullable
              as List<GitFileStatus>,
      unstaged: null == unstaged
          ? _value._unstaged
          : unstaged // ignore: cast_nullable_to_non_nullable
              as List<GitFileStatus>,
      untracked: null == untracked
          ? _value._untracked
          : untracked // ignore: cast_nullable_to_non_nullable
              as List<GitFileStatus>,
    ));
  }
}

/// @nodoc

class _$GitStatusInfoImpl implements _GitStatusInfo {
  const _$GitStatusInfoImpl(
      {final List<GitFileStatus> staged = const [],
      final List<GitFileStatus> unstaged = const [],
      final List<GitFileStatus> untracked = const []})
      : _staged = staged,
        _unstaged = unstaged,
        _untracked = untracked;

  /// Files staged for commit (Added, Modified, Deleted, Renamed, Copied).
  final List<GitFileStatus> _staged;

  /// Files staged for commit (Added, Modified, Deleted, Renamed, Copied).
  @override
  @JsonKey()
  List<GitFileStatus> get staged {
    if (_staged is EqualUnmodifiableListView) return _staged;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_staged);
  }

  /// Files with unstaged changes (Modified, Deleted).
  final List<GitFileStatus> _unstaged;

  /// Files with unstaged changes (Modified, Deleted).
  @override
  @JsonKey()
  List<GitFileStatus> get unstaged {
    if (_unstaged is EqualUnmodifiableListView) return _unstaged;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unstaged);
  }

  /// Files that are not tracked by Git.
  final List<GitFileStatus> _untracked;

  /// Files that are not tracked by Git.
  @override
  @JsonKey()
  List<GitFileStatus> get untracked {
    if (_untracked is EqualUnmodifiableListView) return _untracked;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_untracked);
  }

  @override
  String toString() {
    return 'GitStatusInfo(staged: $staged, unstaged: $unstaged, untracked: $untracked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GitStatusInfoImpl &&
            const DeepCollectionEquality().equals(other._staged, _staged) &&
            const DeepCollectionEquality().equals(other._unstaged, _unstaged) &&
            const DeepCollectionEquality()
                .equals(other._untracked, _untracked));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_staged),
      const DeepCollectionEquality().hash(_unstaged),
      const DeepCollectionEquality().hash(_untracked));

  /// Create a copy of GitStatusInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GitStatusInfoImplCopyWith<_$GitStatusInfoImpl> get copyWith =>
      __$$GitStatusInfoImplCopyWithImpl<_$GitStatusInfoImpl>(this, _$identity);
}

abstract class _GitStatusInfo implements GitStatusInfo {
  const factory _GitStatusInfo(
      {final List<GitFileStatus> staged,
      final List<GitFileStatus> unstaged,
      final List<GitFileStatus> untracked}) = _$GitStatusInfoImpl;

  /// Files staged for commit (Added, Modified, Deleted, Renamed, Copied).
  @override
  List<GitFileStatus> get staged;

  /// Files with unstaged changes (Modified, Deleted).
  @override
  List<GitFileStatus> get unstaged;

  /// Files that are not tracked by Git.
  @override
  List<GitFileStatus> get untracked;

  /// Create a copy of GitStatusInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GitStatusInfoImplCopyWith<_$GitStatusInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GitFileStatus {
  String get path => throw _privateConstructorUsedError;
  String get stagedStatus => throw _privateConstructorUsedError;
  String get unstagedStatus => throw _privateConstructorUsedError;

  /// Create a copy of GitFileStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GitFileStatusCopyWith<GitFileStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GitFileStatusCopyWith<$Res> {
  factory $GitFileStatusCopyWith(
          GitFileStatus value, $Res Function(GitFileStatus) then) =
      _$GitFileStatusCopyWithImpl<$Res, GitFileStatus>;
  @useResult
  $Res call({String path, String stagedStatus, String unstagedStatus});
}

/// @nodoc
class _$GitFileStatusCopyWithImpl<$Res, $Val extends GitFileStatus>
    implements $GitFileStatusCopyWith<$Res> {
  _$GitFileStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GitFileStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? stagedStatus = null,
    Object? unstagedStatus = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      stagedStatus: null == stagedStatus
          ? _value.stagedStatus
          : stagedStatus // ignore: cast_nullable_to_non_nullable
              as String,
      unstagedStatus: null == unstagedStatus
          ? _value.unstagedStatus
          : unstagedStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GitFileStatusImplCopyWith<$Res>
    implements $GitFileStatusCopyWith<$Res> {
  factory _$$GitFileStatusImplCopyWith(
          _$GitFileStatusImpl value, $Res Function(_$GitFileStatusImpl) then) =
      __$$GitFileStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, String stagedStatus, String unstagedStatus});
}

/// @nodoc
class __$$GitFileStatusImplCopyWithImpl<$Res>
    extends _$GitFileStatusCopyWithImpl<$Res, _$GitFileStatusImpl>
    implements _$$GitFileStatusImplCopyWith<$Res> {
  __$$GitFileStatusImplCopyWithImpl(
      _$GitFileStatusImpl _value, $Res Function(_$GitFileStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of GitFileStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? stagedStatus = null,
    Object? unstagedStatus = null,
  }) {
    return _then(_$GitFileStatusImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      stagedStatus: null == stagedStatus
          ? _value.stagedStatus
          : stagedStatus // ignore: cast_nullable_to_non_nullable
              as String,
      unstagedStatus: null == unstagedStatus
          ? _value.unstagedStatus
          : unstagedStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GitFileStatusImpl implements _GitFileStatus {
  const _$GitFileStatusImpl(
      {required this.path,
      required this.stagedStatus,
      required this.unstagedStatus});

  @override
  final String path;
  @override
  final String stagedStatus;
  @override
  final String unstagedStatus;

  @override
  String toString() {
    return 'GitFileStatus(path: $path, stagedStatus: $stagedStatus, unstagedStatus: $unstagedStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GitFileStatusImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.stagedStatus, stagedStatus) ||
                other.stagedStatus == stagedStatus) &&
            (identical(other.unstagedStatus, unstagedStatus) ||
                other.unstagedStatus == unstagedStatus));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, path, stagedStatus, unstagedStatus);

  /// Create a copy of GitFileStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GitFileStatusImplCopyWith<_$GitFileStatusImpl> get copyWith =>
      __$$GitFileStatusImplCopyWithImpl<_$GitFileStatusImpl>(this, _$identity);
}

abstract class _GitFileStatus implements GitFileStatus {
  const factory _GitFileStatus(
      {required final String path,
      required final String stagedStatus,
      required final String unstagedStatus}) = _$GitFileStatusImpl;

  @override
  String get path;
  @override
  String get stagedStatus;
  @override
  String get unstagedStatus;

  /// Create a copy of GitFileStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GitFileStatusImplCopyWith<_$GitFileStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
