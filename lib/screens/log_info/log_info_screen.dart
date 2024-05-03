import 'dart:convert';
import 'dart:io';

import 'package:ble_project/global/global_data.dart';
import 'package:ble_project/models/log_dto.dart';
import 'package:ble_project/services/fire_storage_service.dart';
import 'package:ble_project/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LogInfoScreen extends StatefulWidget {
  final List<int>? logsData;
  final String? fileName;
  final String? id;

  const LogInfoScreen({
    super.key,
    this.logsData,
    this.fileName,
    this.id,
  });

  @override
  State<LogInfoScreen> createState() => _LogInfoScreenState();
}

class _LogInfoScreenState extends State<LogInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
        actions: [
          InkWell(
            onTap: () {
              // handleDownLoadDocument(
              //   fileName: widget.fileName ?? "",
              // );

              saveToFirebase();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Icon(Icons.save),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          widget.logsData.toString(),
        ),
      ),
    );
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0');

      if (!await directory.exists()) {
        directory = Directory('/storage/emulated/0');
      }
    }
    return directory.path;
  }

  void handleDownLoadDocument({
    required String fileName,
  }) async {
    String? dir = await getDownloadPath();
    if (dir != null) {
      String filePath = "$dir/$fileName.txt";

      try {
        String content = "abcdefgh";

        final bytes = base64.decode(content.replaceAll(RegExp(r'\s+'), ''));
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        print(file.path);
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

  void saveToFirebase() async {
    try {
      final dataConvertString = widget.logsData
          .toString()
          .replaceAll("[", '')
          .replaceAll("]", "")
          .toString();

      final fireStorageService = FireStorageService();
      final log = LogDto(
        id: widget.id,
        listData: dataConvertString,
        userId: GlobalData.instance.userSelected?.id,
        createDate: DateTime.now().toString(),
      );
      await fireStorageService.saveLog(log);

      if (context.mounted) {
        Snackbar.show(
          ABC.c,
          "Lưu dữ liệu thành công",
          success: true,
        );
      }
    } catch (e) {
      print("Lỗi thêm data");
    }
  }
}
