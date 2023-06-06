import 'dart:collection';

import 'package:flutter/foundation.dart';

class UploadImageObserver<T> extends ChangeNotifier implements ImageStorageCenter<T> {
  final ImageStorageCenter<T> _center = _ImageStorageCenter<T>();

  final Queue<String> _processQueue = Queue();

  MappingImage<T> _mappingImage = DefaultMappingImage<T>();

  bool _isSending = false;

  bool get isInProcess => _isSending;

  void setMappingMethod(MappingImage<T> mappingImage) {
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
          final T? mappingPath = await _mappingImage.getImage(path);
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
  T? getPath(String localPath) {
    return _center.getPath(localPath);
  }

  @override
  void setPath(String localPath, T remotePath) {
    _center.setPath(localPath, remotePath);
  }

  @override
  Map<String, T> getPaths() {
    return _center.getPaths();
  }
}

class _ImageStorageCenter<T> extends ImageStorageCenter<T> {
  //<LocalPath, RemotePath>
  final Map<String, T> _mapping = {};

  @override
  T? getPath(String localPath) => _mapping[localPath];

  @override
  bool checkPath(String localPath) => getPath(localPath) != null;

  @override
  void setPath(String localPath, T remotePath) {
    _mapping[localPath] = remotePath;
  }

  @override
  void clear() {
    _mapping.clear();
  }

  @override
  Map<String, T> getPaths() {
    return _mapping;
  }
}

abstract class ImageStorageCenter<T> {
  T? getPath(String localPath);

  bool checkPath(String localPath);

  void setPath(String localPath, T remotePath);

  void clear();

  Map<String, T> getPaths();
}

abstract class MappingImage<T> {
  Future<T?> getImage(String path);
}

class DefaultMappingImage<T> extends MappingImage<T> {
  @override
  Future<T?> getImage(String path) {
    throw UnimplementedError();
  }
}

class IsolateMappingImage extends MappingImage<String> {
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
