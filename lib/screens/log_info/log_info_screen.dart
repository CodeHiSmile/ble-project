import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LogInfoScreen extends StatefulWidget {
  final List<int>? logsData;
  final String? fileName;

  const LogInfoScreen({
    super.key,
    this.logsData,
    this.fileName,
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
              handleDownLoadDocument(
                fileName: widget.fileName ?? "",
                // content: widget.logsData.toString(),
              );
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

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        directory = Directory("/storage/emulated/0/Download");
      }
    }
    return directory.path;
  }

  void handleDownLoadDocument({
    required String fileName,
    // required String content,
  }) async {
    String? dir = await getDownloadPath();
    if (dir != null) {
      String filePath = "$dir/$fileName.txt";

      try {
       String content = "abcd efgh";

        final bytes = base64.decode(content.replaceAll(RegExp(r'\s+'), ''));
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        print(file.path);
      } catch (e) {
        debugPrint("$e");
      }
    }
  }
}
