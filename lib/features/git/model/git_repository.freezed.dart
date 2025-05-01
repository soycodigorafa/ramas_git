// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'git_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GitRepository _$GitRepositoryFromJson(Map<String, dynamic> json) {
  return _GitRepository.fromJson(json);
}

/// @nodoc
mixin _$GitRepository {
  String get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  DateTime? get lastCommitDate => throw _privateConstructorUsedError;

  /// Serializes this GitRepository to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GitRepository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GitRepositoryCopyWith<GitRepository> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GitRepositoryCopyWith<$Res> {
  factory $GitRepositoryCopyWith(
          GitRepository value, $Res Function(GitRepository) then) =
      _$GitRepositoryCopyWithImpl<$Res, GitRepository>;
  @useResult
  $Res call({String name, String path, DateTime? lastCommitDate});
}

/// @nodoc
class _$GitRepositoryCopyWithImpl<$Res, $Val extends GitRepository>
    implements $GitRepositoryCopyWith<$Res> {
  _$GitRepositoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GitRepository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? lastCommitDate = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      lastCommitDate: freezed == lastCommitDate
          ? _value.lastCommitDate
          : lastCommitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GitRepositoryImplCopyWith<$Res>
    implements $GitRepositoryCopyWith<$Res> {
  factory _$$GitRepositoryImplCopyWith(
          _$GitRepositoryImpl value, $Res Function(_$GitRepositoryImpl) then) =
      __$$GitRepositoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String path, DateTime? lastCommitDate});
}

/// @nodoc
class __$$GitRepositoryImplCopyWithImpl<$Res>
    extends _$GitRepositoryCopyWithImpl<$Res, _$GitRepositoryImpl>
    implements _$$GitRepositoryImplCopyWith<$Res> {
  __$$GitRepositoryImplCopyWithImpl(
      _$GitRepositoryImpl _value, $Res Function(_$GitRepositoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of GitRepository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? lastCommitDate = freezed,
  }) {
    return _then(_$GitRepositoryImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      lastCommitDate: freezed == lastCommitDate
          ? _value.lastCommitDate
          : lastCommitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GitRepositoryImpl implements _GitRepository {
  const _$GitRepositoryImpl(
      {required this.name, required this.path, this.lastCommitDate});

  factory _$GitRepositoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$GitRepositoryImplFromJson(json);

  @override
  final String name;
  @override
  final String path;
  @override
  final DateTime? lastCommitDate;

  @override
  String toString() {
    return 'GitRepository(name: $name, path: $path, lastCommitDate: $lastCommitDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GitRepositoryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.lastCommitDate, lastCommitDate) ||
                other.lastCommitDate == lastCommitDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, path, lastCommitDate);

  /// Create a copy of GitRepository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GitRepositoryImplCopyWith<_$GitRepositoryImpl> get copyWith =>
      __$$GitRepositoryImplCopyWithImpl<_$GitRepositoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GitRepositoryImplToJson(
      this,
    );
  }
}

abstract class _GitRepository implements GitRepository {
  const factory _GitRepository(
      {required final String name,
      required final String path,
      final DateTime? lastCommitDate}) = _$GitRepositoryImpl;

  factory _GitRepository.fromJson(Map<String, dynamic> json) =
      _$GitRepositoryImpl.fromJson;

  @override
  String get name;
  @override
  String get path;
  @override
  DateTime? get lastCommitDate;

  /// Create a copy of GitRepository
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GitRepositoryImplCopyWith<_$GitRepositoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
