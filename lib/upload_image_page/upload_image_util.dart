import 'dart:collection';

import 'package:flutter/foundation.dart';

class UploadImageUtil extends ChangeNotifier implements ImageStorageCenter {
  UploadImageUtil._();

  static final UploadImageUtil _i = UploadImageUtil._();

  factory UploadImageUtil() => _i;

  final ImageStorageCenter _center = _ImageStorageCenter();

  final Queue<String> _processQueue = Queue();

  MappingImage _mappingImage = DefaultMappingImage();

  bool _isSending = false;

  bool get isInProcess => _isSending;

  void setMappingMethod(MappingImage mappingImage) {
    _mappingImage = mappingImage;
  }

  void addImage(String localPath) {
    _processQueue.add(localPath);
    _execute();
  }

  void addImages(List<String> localPaths) {
    _processQueue.addAll(localPaths);
    _execute();
  }

  void _execute() async {
    if (!_isSending) {
      _isSending = true;
      notifyListeners();
      while (_processQueue.isNotEmpty) {
        final path = _processQueue.removeFirst();
        if (!checkPath(path)) {
          final String? mappingPath = await _mappingImage.getImage(path);
          if (mappingPath != null) {
            setPath(path, mappingPath);
          }
        }
      }
      _isSending = false;
      notifyListeners();
    }
  }

  @override
  bool checkPath(String localPath) {
    return _center.checkPath(localPath);
  }

  @override
  void clear() {
    return _center.clear();
  }

  @override
  String? getPath(String localPath) {
    return _center.getPath(localPath);
  }

  @override
  void setPath(String localPath, String remotePath) {
    _center.setPath(localPath, remotePath);
  }

  @override
  Map<String, String> getPaths() {
    return _center.getPaths();
  }
}

class _ImageStorageCenter extends ImageStorageCenter {
  _ImageStorageCenter._();

  static final _ImageStorageCenter _i = _ImageStorageCenter._();

  factory _ImageStorageCenter() => _i;

  //<LocalPath, RemotePath>
  final Map<String, String> _mapping = {};

  @override
  String? getPath(String localPath) => _mapping[localPath];

  @override
  bool checkPath(String localPath) => getPath(localPath) != null;

  @override
  void setPath(String localPath, String remotePath) {
    _mapping[localPath] = remotePath;
  }

  @override
  void clear() {
    _mapping.clear();
  }

  @override
  Map<String, String> getPaths() {
    return _mapping;
  }
}

abstract class ImageStorageCenter {
  String? getPath(String localPath);

  bool checkPath(String localPath);

  void setPath(String localPath, String remotePath);

  void clear();

  Map<String, String> getPaths();
}

abstract class MappingImage {
  Future<String?> getImage(String path);
}

class DefaultMappingImage extends MappingImage {
  @override
  Future<String?> getImage(String path) {
    throw UnimplementedError();
  }
}

class IsolateMappingImage extends MappingImage {
  static Future<String?> uploadImage(String path) async {
    if (path == 'localPath_1') {
      return null;
    }
    await Future.delayed(Duration(seconds: 2));
    return 'remotePath_of_$path';
  }
  @override
  Future<String?> getImage(String path) {
    return compute<String, String?>(uploadImage, path);
  }
}


