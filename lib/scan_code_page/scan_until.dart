import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

class ScanUntil {
  final Duration delayedTime;
  final BehaviorSubject<_CodeStatus> _subject = BehaviorSubject();
  late final StreamSubscription _streamSubscription;
  bool _isListening = false;

  ScanUntil({this.delayedTime = const Duration(seconds: 1)});

  void listen<T>(Future Function(T data) onProcess) {
    if (!_isListening) {
      _streamSubscription = _subject.stream.distinct().listen((event) async {
        if (event.data is T) {
          await onProcess.call(event.data);
          await Future.delayed(delayedTime);
          _subject.add(_ReadyCodeStatus());
        }
      });
      _isListening = true;
    }
  }

  void close() {
    _streamSubscription.cancel();
    _subject.close();
  }

  void addCodeStatus<T>(T code) {
    _subject.add(_CodeStatus<T>(data: code));
  }
}

class _CodeStatus<T> extends Equatable {
  final T? data;

  const _CodeStatus({this.data});

  @override
  List<Object?> get props => [runtimeType];
}

class _ReadyCodeStatus extends _CodeStatus {
  const _ReadyCodeStatus();
}
