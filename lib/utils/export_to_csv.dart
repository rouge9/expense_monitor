import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:share_plus/share_plus.dart';

Future<void> exportToCsv(List<List<dynamic>> rows, context) async {
  String csvData = const ListToCsvConverter().convert(rows);

  if (await Permission.storage.request().isGranted ||
      await Permission.manageExternalStorage.request().isGranted) {
    final String dir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS,
    );
    final String path = '$dir/export.csv';
    final File file = File(path);
    await file.writeAsString(csvData);
    Share.shareXFiles([XFile(path)]);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        dismissDirection: DismissDirection.down,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.greenAccent,
        content: Text(
          'CSV file exported to Downloads folder.',
        ),
      ),
    );
  } else {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        dismissDirection: DismissDirection.down,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        content: Text(
          'Permission denied! Please enable storage permission to export CSV file.',
        ),
      ),
    );
  }
}
