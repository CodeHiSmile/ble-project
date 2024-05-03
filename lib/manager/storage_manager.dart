// import 'dart:io';
//
// import 'package:permission_handler/permission_handler.dart';
//
// class StorageManager{
//   static final StorageManager _instance =
//   StorageManager._internal();
//   factory StorageManager() {
//     return _instance;
//   }
//
//   StorageManager._internal();
//
//   static StorageManager get instance => _instance;
//
//   static const appFolderName = "SoundJudgement";
//
//   Future<void> requestPermission({required BuildContext context}) async {
//     PermissionStatus permissionStatusMicrophone = await Permission.microphone.request();
//     if (permissionStatusMicrophone != PermissionStatus.granted) {
//       AppDialog.showOpenSettingDialog(
//         context: context,
//         title: S.current.permission_open_microphone_setting,
//         onRetry: () {
//           requestPermission(context: context);
//         },
//       );
//       return;
//     }
//
//     PermissionStatus permissionStatusStorage = await Permission.storage.request();
//     if (permissionStatusStorage != PermissionStatus.granted) {
//       AppDialog.showOpenSettingDialog(
//         context: context,
//         title: S.current.permission_open_store_setting,
//         onRetry: () {
//           requestPermission(context: context);
//         },
//       );
//       return;
//     }
//
//     final isAndroid11OrHigher = await checkSDKGreaterThan30();
//     if (isAndroid11OrHigher || Platform.isIOS) {
//       PermissionStatus permissionStatusManageExternalStorage =
//       await Permission.manageExternalStorage.request();
//       if (permissionStatusManageExternalStorage != PermissionStatus.granted) {
//         AppDialog.showOpenSettingDialog(
//           context: context,
//           title: S.current.permission_open_store_setting,
//           onRetry: () {
//             requestPermission(context: context);
//           },
//         );
//         return;
//       }
//     }
//   }
//
//   Future<bool> checkSDKGreaterThan30() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     final sdkInt = androidInfo.version.sdkInt ?? 0;
//     logger.log("Android SDK 🌈: $sdkInt");
//     if (sdkInt >= 30) {
//       /// Android 11 or higher
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   Future<bool> checkPermissionAndroid() async {
//     final statusManageExternalStorage =
//     await Permission.manageExternalStorage.status;
//     final statusStorage = await Permission.storage.status;
//     final statusMicrophone = await Permission.microphone.status;
//     final isAndroid11OrHigher = await checkSDKGreaterThan30();
//     if (isAndroid11OrHigher) {
//       if (statusManageExternalStorage.isGranted &&
//           statusStorage.isGranted &&
//           statusMicrophone.isGranted) {
//         return true;
//       }
//       return false;
//     } else {
//       if (statusStorage.isGranted && statusMicrophone.isGranted) {
//         return true;
//       }
//       return false;
//     }
//   }
//
//   Future<bool> checkPermissioniOS() async {
//     final statusStorage = await Permission.storage.status;
//     if (statusStorage.isGranted) {
//       return true;
//     }
//     return false;
//   }
//
//   Future<void> createAppFolder() async {
//     final path = Directory("$pathStorage/$appFolderName");
//     if ((await path.exists())) {
//       return;
//     } else {
//       await path.create();
//     }
//   }
//
//   Future<String?> createFolderWithName(String folderName, {required BuildContext context}) async {
//     final isHavePermission = await (Platform.isAndroid
//         ? checkPermissionAndroid()
//         : checkPermissioniOS());
//
//     if (!isHavePermission) {
//       await requestPermission(context: context);
//       return null;
//     }
//
//     final path = Directory("$pathStorage/$appFolderName/$folderName");
//
//     if ((await path.exists())) {
//       return path.path;
//     } else {
//       await path.create();
//       await Future.delayed(const Duration(microseconds: 100));
//       return path.path;
//     }
//   }
//
//   Future<bool> checkResponseData() async {
//     const folderName = "Data";
//     final dir = Directory("$pathStorage/$appFolderName/$folderName");
//
//     if (!dir.existsSync()) {
//       return false;
//     } else {
//       return dir.listSync().length == 3;
//     }
//   }
//
//   Future<String?> createFolderAndSaveResponse() async {
//     const folderName = "Data";
//     final path = Directory("$pathStorage/$appFolderName/$folderName");
//
//     if ((await path.exists())) {
//       return path.path;
//     } else {
//       await path.create();
//       await Future.delayed(const Duration(microseconds: 100));
//       return path.path;
//     }
//   }
// }