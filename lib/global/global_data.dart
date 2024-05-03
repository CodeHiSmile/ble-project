import 'package:ble_project/models/entities/user_entity.dart';

class GlobalData {
  GlobalData._privateConstructor();

  static final GlobalData instance = GlobalData._privateConstructor();

  UserEntity? userSelected;

  String? pathStorageAndroid;

  String? pathStorageIOS;
}
