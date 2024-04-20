import 'package:ble_project/models/entities/log_entity.dart';
import 'package:ble_project/models/entities/user_entity.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarStorageUtil {
  late Future<Isar> database;

  IsarStorageUtil() {
    database = openIsar();
  }

  Future<Isar> openIsar() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [
          LogsEntitySchema,
          UserEntitySchema,
        ],
        inspector: true,
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }

  Future<bool> saveLogs(LogsEntity log) async {
    try {
      final isar = await database;

      isar.writeTxnSync<int>(
        () => isar.logsEntitys.putSync(log),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<LogsEntity>?> getLogs(int? userId) async {
    final isar = await database;
    final result = await isar.logsEntitys.where().findAll();

    if (result.isNotEmpty) {
      final logs = result.where((e) => e.userId == userId).toList();

      return logs;
    }
    return [];
  }

  Future<bool> deleteLogs(LogsEntity log) async {
    try {
      final isar = await database;
      await isar.writeTxn(() async {
        await isar.logsEntitys.delete(log.id);
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future deleteAll() async {
    try {
      final isar = await database;
      await isar.writeTxn(() async {
        await isar.clear();
      });
    } catch (e) {
      return;
    }
  }

  ///User
  Future<bool> saveUser(UserEntity user) async {
    try {
      final isar = await database;

      isar.writeTxnSync<int>(
        () => isar.userEntitys.putSync(user),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserEntity>?> getUsers() async {
    final isar = await database;
    final result = await isar.userEntitys.where().findAll();

    if (result.isNotEmpty) {
      return result;
    }
    return [];
  }

  Future<bool> deleteUser(UserEntity user) async {
    try {
      final isar = await database;
      await isar.writeTxn(() async {
        await isar.logsEntitys.delete(user.id);
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
