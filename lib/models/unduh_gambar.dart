import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<void> unduhGambar(BuildContext context, String filePath) async {
  try {
    Uri? uri = Uri.tryParse(filePath);
    String fileName = path.basename(filePath);

    Directory? dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download/Scanner App'); 
      if (!dir.existsSync()) {
        dir.createSync(recursive: true); 
      }
    } else {
      dir = await getDownloadsDirectory(); 
      if (dir != null) {
        dir = Directory(path.join(dir.path, 'Scanner App'));
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
      }
    }

    if (dir == null) {
      throw Exception("Folder Unduhan tidak ditemukan.");
    }

    String savePath = path.join(dir.path, fileName);

    if (uri != null && uri.hasScheme && uri.host.isNotEmpty) {
      Dio dio = Dio();
      await dio.download(filePath, savePath);
    } else if (File(filePath).existsSync()) {
      await File(filePath).copy(savePath);
    } else {
      throw Exception("File tidak ditemukan: $filePath");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download selesai: $savePath'),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
      ),
    );
  }
}
