import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<XFile?> isolateCompressImage(ImageCompressModel a) {
  return CompressImageUtil().compressAndGetFile(a.file, a.targetPath);
}

class ImageCompressModel {
  final File file;
  final String targetPath;

  ImageCompressModel(this.file, this.targetPath);
}

class CompressImageUtil {
  ///[showLog] show log size before and after image is compressed
  bool showLog = true;

  ///[maxSize] is bytes
  ///1024 * 1000 bytes -> 1 MB
  int maxSize = 1024 * 1000;

  Future<XFile?> compressAndGetFile(File file, String targetPath, {int quality = 90}) async {
    int fileSize = file.lengthSync();
    try {
      if (fileSize <= maxSize) {
        return XFile(file.path);
      }

      var result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: quality,
      );

      if (showLog) {
        log('file size: $fileSize');
        log('file compress size: ${await result?.length()}');
      }

      return result;
    } catch (e) {
      log('$runtimeType: ${e.toString()}');
      rethrow;
    }
  }
}

class AssetImageToFile {
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    final file = File('${(await path_provider.getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
