import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_isolate/flutter_isolate.dart' as flutter_isolate;

Future<String> getRandomImagePath() async {
  final dir = await path_provider.getTemporaryDirectory();
  return '${dir.absolute.path}/${DateTime.now().toIso8601String()}.jpg';
}

/*
* https://api.dart.dev/stable/2.18.3/dart-isolate/SendPort/send.html
* sendPort và ReceivePort chỉ nhận được 1 số loại dữ liệu nên Chuyển từ custom object (class) -> Map và response type is String
* */
@pragma('vm:entry-point')
Future<String?> isolateCompressImage(ImageCompressModel imageCompressModel) {
  final message = jsonEncode(imageCompressModel.toJson());

  return flutter_isolate.flutterCompute<String?, String>(compressImage, message);
}

@pragma('vm:entry-point')
Future<String?> compressImage(String data) {
  Map imageCompressJson = jsonDecode(data);

  return CompressImageUtil(maxSize: 1024).compressAndGetFile(
    imageCompressJson['sourcePath'],
    imageCompressJson['targetPath'],
    quality: imageCompressJson['quality'],
  );
}

@pragma('vm:entry-point')
class ImageCompressModel {
  final String sourcePath;
  final String targetPath;
  final int quality;

  const ImageCompressModel(this.sourcePath, this.targetPath, this.quality);

  Map<String, dynamic> toJson() {
    return {
      'sourcePath': sourcePath,
      'targetPath': targetPath,
      'quality': quality,
    };
  }
}

class CompressImageUtil {
  CompressImageUtil({this.showLog = true, this.maxSize = 1024 * 1000});

  ///[showLog] show log size before and after image is compressed
  bool showLog;

  ///[maxSize] is bytes
  ///1024 * 1000 bytes -> 1 MB
  int maxSize;

  Future<String?> compressAndGetFile(String sourcePath, String targetPath, {int quality = 90}) async {
    File file = File(sourcePath);

    int fileSize = file.lengthSync();

    try {
      XFile? result;

      if (fileSize <= maxSize) {
        result = XFile((await file.copy(targetPath)).path);
      } else {
        result = await FlutterImageCompress.compressAndGetFile(
          file.path,
          targetPath,
          quality: calculateTargetQuality(fileSize, defaultResizeQuality: quality),
        );
      }

      if (showLog) {
        log('file size: $fileSize');
        log('file compress size: ${await result?.length()}');
      }

      return result?.path;
    } catch (e) {
      log('$runtimeType: ${e.toString()}');
      rethrow;
    }
  }

  int calculateTargetQuality(int fileSize, {int defaultResizeQuality = 90}) {
    if (fileSize <= maxSize) {
      return defaultResizeQuality;
    }

    int percent = (100 * (1 - (maxSize / fileSize))).round();

    return (percent - 10) > 0 ? percent - 10 : percent;
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
