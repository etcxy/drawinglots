// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      json['userID'] as String,
      json['userName'] as String,
      (json['userTags'] as List<dynamic>).map((e) => e as String).toSet(),
      weight: (json['weight'] as num?)?.toInt() ?? 50,
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'userName': instance.userName,
      'userTags': instance.userTags.toList(),
      'weight': instance.weight,
    };
