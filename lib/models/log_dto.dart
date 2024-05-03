import 'package:json_annotation/json_annotation.dart';

part 'log_dto.g.dart';

@JsonSerializable()
class LogDto{
  final String? id;
  final String? listData;
  final int? userId;
  final String? createDate;
  final String? status;

  LogDto({
    this.id,
    this.listData,
    this.createDate,
    this.userId,
    this.status,
  });

  factory LogDto.fromJson(Map<String, dynamic> json) =>
      _$LogDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LogDtoToJson(this);
}