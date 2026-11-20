import 'dart:io';
import 'dart:typed_data';

Future<String?> saveZipBytes(Uint8List bytes, String fileName) async {
  final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  Directory targetDir = Directory.current;
  if (home != null) {
    final downloadsDir = Directory('$home/Downloads');
    if (await downloadsDir.exists()) {
      targetDir = downloadsDir;
    }
  }
  final file = File('${targetDir.path}${Platform.pathSeparator}$fileName');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}
