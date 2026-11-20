import 'dart:convert';
import 'dart:typed_data';

import 'zip_exporter_stub.dart'
    if (dart.library.io) 'zip_exporter_io.dart'
    if (dart.library.html) 'zip_exporter_web.dart' as platform_saver;

/// Pure-Dart standard ZIP archive builder & cross-platform file exporter.
class ZipExporter {
  /// Encodes a map of relative file paths to text contents into a valid ZIP archive.
  static Uint8List buildZipArchive(Map<String, String> files) {
    final localFileChunks = <Uint8List>[];
    final centralDirChunks = <Uint8List>[];
    int currentOffset = 0;

    final now = DateTime.now();
    final dosTime =
        ((now.hour & 0x1F) << 11) | ((now.minute & 0x3F) << 5) | (now.second ~/ 2);
    final dosDate =
        (((now.year - 1980) & 0x7F) << 9) | ((now.month & 0x0F) << 5) | (now.day & 0x1F);

    for (final entry in files.entries) {
      final nameBytes = Uint8List.fromList(utf8.encode(entry.key));
      final contentBytes = Uint8List.fromList(utf8.encode(entry.value));
      final crc = _crc32(contentBytes);
      final size = contentBytes.length;

      // Local file header (30 bytes + file name + content)
      final localHeader = ByteData(30 + nameBytes.length);
      localHeader.setUint32(0, 0x04034b50, Endian.little); // signature
      localHeader.setUint16(4, 20, Endian.little); // version needed
      localHeader.setUint16(6, 0x0800, Endian.little); // UTF-8 flag
      localHeader.setUint16(8, 0, Endian.little); // stored (no compression)
      localHeader.setUint16(10, dosTime, Endian.little);
      localHeader.setUint16(12, dosDate, Endian.little);
      localHeader.setUint32(14, crc, Endian.little);
      localHeader.setUint32(18, size, Endian.little); // compressed size
      localHeader.setUint32(22, size, Endian.little); // uncompressed size
      localHeader.setUint16(26, nameBytes.length, Endian.little);
      localHeader.setUint16(28, 0, Endian.little); // extra length

      final localHeaderBytes = localHeader.buffer.asUint8List();
      localHeaderBytes.setRange(30, 30 + nameBytes.length, nameBytes);

      localFileChunks.add(localHeaderBytes);
      localFileChunks.add(contentBytes);

      // Central directory file header (46 bytes + file name)
      final centralHeader = ByteData(46 + nameBytes.length);
      centralHeader.setUint32(0, 0x02014b50, Endian.little); // signature
      centralHeader.setUint16(4, 20, Endian.little); // version made by
      centralHeader.setUint16(6, 20, Endian.little); // version needed
      centralHeader.setUint16(8, 0x0800, Endian.little); // UTF-8 flag
      centralHeader.setUint16(10, 0, Endian.little); // stored
      centralHeader.setUint16(12, dosTime, Endian.little);
      centralHeader.setUint16(14, dosDate, Endian.little);
      centralHeader.setUint32(16, crc, Endian.little);
      centralHeader.setUint32(20, size, Endian.little);
      centralHeader.setUint32(24, size, Endian.little);
      centralHeader.setUint16(28, nameBytes.length, Endian.little);
      centralHeader.setUint16(30, 0, Endian.little); // extra
      centralHeader.setUint16(32, 0, Endian.little); // comment
      centralHeader.setUint16(34, 0, Endian.little); // disk number
      centralHeader.setUint16(36, 0, Endian.little); // internal attrs
      centralHeader.setUint32(38, 0, Endian.little); // external attrs
      centralHeader.setUint32(42, currentOffset, Endian.little); // offset

      final centralHeaderBytes = centralHeader.buffer.asUint8List();
      centralHeaderBytes.setRange(46, 46 + nameBytes.length, nameBytes);
      centralDirChunks.add(centralHeaderBytes);

      currentOffset += localHeaderBytes.length + contentBytes.length;
    }

    int centralDirSize = 0;
    for (final chunk in centralDirChunks) {
      centralDirSize += chunk.length;
    }

    // End of central directory record (22 bytes)
    final eocd = ByteData(22);
    eocd.setUint32(0, 0x06054b50, Endian.little); // signature
    eocd.setUint16(4, 0, Endian.little); // disk number
    eocd.setUint16(6, 0, Endian.little); // start disk
    eocd.setUint16(8, files.length, Endian.little); // entries on disk
    eocd.setUint16(10, files.length, Endian.little); // total entries
    eocd.setUint32(12, centralDirSize, Endian.little);
    eocd.setUint32(16, currentOffset, Endian.little); // central dir offset
    eocd.setUint16(20, 0, Endian.little); // comment length

    final builder = BytesBuilder(copy: false);
    for (final chunk in localFileChunks) {
      builder.add(chunk);
    }
    for (final chunk in centralDirChunks) {
      builder.add(chunk);
    }
    builder.add(eocd.buffer.asUint8List());
    return builder.toBytes();
  }

  /// Builds and saves the ZIP archive to Downloads (Desktop/IO) or triggers a download (Web).
  static Future<String?> exportZipFile({
    required Map<String, String> files,
    required String fileName,
  }) async {
    final zipBytes = buildZipArchive(files);
    return platform_saver.saveZipBytes(zipBytes, fileName);
  }

  static int _crc32(Uint8List bytes) {
    int crc = 0xFFFFFFFF;
    for (final b in bytes) {
      crc ^= b;
      for (int i = 0; i < 8; i++) {
        if ((crc & 1) != 0) {
          crc = (crc >>> 1) ^ 0xEDB88320;
        } else {
          crc = crc >>> 1;
        }
      }
    }
    return (~crc) & 0xFFFFFFFF;
  }
}
