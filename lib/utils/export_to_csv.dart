import 'dart:io';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:share_plus/share_plus.dart';

Future<void> exportToCsv(List<List<dynamic>> rows) async {
  String csvData = const ListToCsvConverter().convert(rows);

  final PermissionStatus permissionStatus = await Permission.storage.request();
  if (permissionStatus.isGranted) {
    final String dir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS,
    );
    final String path = '$dir/export.csv';
    final File file = File(path);
    await file.writeAsString(csvData);
    Share.shareXFiles([XFile(path)]);
  }
}
