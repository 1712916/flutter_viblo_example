import 'dart:async';
import 'dart:developer';

/*
* Create this Util to cancel previous task if have new task is called
* */
class CancelTaskUtil {
  StreamSubscription? _streamSubscription;

  void addTask(Stream stream, Function(dynamic event) onData, Function(dynamic err, StackTrace stackTrace) onError) {
    _cancelTask();

    _streamSubscription = stream.listen(
      (event) {
        onData(event);
      },
      onError: (err, st) {
        log('error: ${err.toString()}');
        log('stackTrace: ${st.toString()}');
        onError(err, st);
      },
      onDone: () {
        _cancelTask();
      },
    );
  }

  void _cancelTask() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void close() {
    _cancelTask();
  }
}
