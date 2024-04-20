import 'package:isar/isar.dart';

part 'user_entity.g.dart';

@collection
class UserEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  final String? userName;
  final String? dateOfBirth;
  final String? address;

  UserEntity({
    this.address,
    this.userName,
    this.dateOfBirth,
  });

  int? get getId => id;

  final userEntities = IsarLinks<UserEntity>();
}
