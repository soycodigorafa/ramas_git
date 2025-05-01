// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'git_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GitRepositoryImpl _$$GitRepositoryImplFromJson(Map<String, dynamic> json) =>
    _$GitRepositoryImpl(
      name: json['name'] as String,
      path: json['path'] as String,
      lastCommitDate: json['lastCommitDate'] == null
          ? null
          : DateTime.parse(json['lastCommitDate'] as String),
    );

Map<String, dynamic> _$$GitRepositoryImplToJson(_$GitRepositoryImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'lastCommitDate': instance.lastCommitDate?.toIso8601String(),
    };
