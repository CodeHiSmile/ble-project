// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogDto _$LogDtoFromJson(Map<String, dynamic> json) => LogDto(
      id: json['id'] as String?,
      listData: json['listData'] as String?,
      createDate: json['createDate'] as String?,
      userId: json['userId'] as int?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$LogDtoToJson(LogDto instance) => <String, dynamic>{
      'id': instance.id,
      'listData': instance.listData,
      'userId': instance.userId,
      'createDate': instance.createDate,
      'status': instance.status,
    };
