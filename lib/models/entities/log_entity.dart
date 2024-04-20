import 'package:isar/isar.dart';

part 'log_entity.g.dart';

@collection
class LogsEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  final List<int>? listData;
  final int? userId;
  final String? createDate;
  final String? status;

  LogsEntity({
    this.listData,
    this.createDate,
    this.userId,
    this.status,
  });

  final logsEntities = IsarLinks<LogsEntity>();
}
