import 'package:flutter/foundation.dart';

mixin SearchMixin {
  String _currentSearch = '';

  String get currentSearch => _currentSearch;

  @mustCallSuper
  void onSearch(String input) {
    _currentSearch = input;
  }

  bool isRepeat(String txt) {
    return _currentSearch == txt;
  }
}

abstract class LoadBehavior {
  void init() {}

  void onLoadMore() {}

  void onRefresh() {}

  bool canLoadMore() {
    return false;
  }
}

abstract class SearchBehavior {
  void onSearch(String keyWord);
}

class SearchUtil {
  final ValueChanged<String> onSearch;

  final int startSearchLength;

  String _currentSearch = '';

  SearchUtil({
    required this.onSearch,
    this.startSearchLength = 2,
  });

  void addSearch(String input) {
    if (_isRepeat(input)) {
      return;
    }

    _currentSearch = input;

    onSearch(input);
  }

  bool _isRepeat(String txt) {
    return _currentSearch == txt;
  }
}

class LoadingUtil {
  int total = 0;
  int limit = 0;
  int _offset = 0;
  int _defaultOffset = 0;

  void setDefaultOffset(int offset) {
    _defaultOffset = offset;
    _offset = offset;
  }

  int get offset => _offset;

  LoadingUtil();

  void onRefresh() {
    _offset = _defaultOffset;
  }

  void increaseOffset() {
    _offset++;
  }

  void decreaseOffset() {
    total--;
  }
}
