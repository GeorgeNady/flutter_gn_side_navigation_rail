// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

Future<String?> saveZipBytes(Uint8List bytes, String fileName) async {
  final base64Data = base64Encode(bytes);
  final anchor = html.AnchorElement(
    href: 'data:application/zip;base64,$base64Data',
  )
    ..setAttribute('download', fileName)
    ..style.display = 'none';
  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  return 'Browser Downloads ($fileName)';
}
