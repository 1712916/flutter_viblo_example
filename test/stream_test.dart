import 'dart:async';

import 'package:flutter_example/cancel_task_page/cancel_task_page.dart';
import 'package:rxdart/rxdart.dart';

void main() async {
  print('length: ${await countStream(0, 10).length}');

  ///single nếu Stream nhiều hơn 1 phần tử thì quăng error
  print('single: ${await countStream(0, 0).single}');
  // print('single: ${await countStream(0, 1).single}'); //error

  print('map: ${await countStream(0, 5).map((event) => 2 * event).toList()}');

  ///Creates a new stream from this stream that converts each element into zero or more events.
  print('expand: ${await countStream(0, 2).expand((event) => [for (var i = 0; i <= event; i++) i]).toList()}');

  print('any: ${await countStream(0, 2).any((event) => event == 1)}');
  print('any: ${await countStream(0, 2).any((event) => event == 3)}');

  ///Behavior của contains cũng giống any nhưng nó so sánh  ///Behavior của contains cũng giống any nhưng nó so sánh Object.== còn any sử dụng callBack để so sánh Object.== còn any sử dụng callBack để so sánh
  print('contains: ${await countStream(0, 2).contains(1)}');

  print('distinct: ${await countStream(0, 2).distinct((previous, next) => previous == next).toList()}');

  ///discard all data from stream: nếu truyền param thì trà về param
  ///vẫn lắng nghe các sự kiện lỗi bình thường
  print('drain: ${await countStream(0, 2).drain(1)}');

  print('every: ${await countStream(0, 2).every((element) => element > 0)}');

  ///Chưa biết xài
  // print('pipe: ${await countStream(0, 2).pipe(streamConsumer)}');

  ///bỏ qua các sự kiện đầu
  print('skip: ${await countStream(0, 2).skip(0).toList()}');
  print('skipWhile: ${await countStream(0, 5).skipWhile((element) => element < 2).toList()}');

  ///chưa rõ cách xài
  print('skipUntil: ${await countStream(0, 10).skipUntil(countStream(7, 9)).toList()}');

  print('buffer: ${await countStream(0, 10).buffer(countStream(0, 10)).toList()}');

  ///tử tưởng như map nhưng map từ T -> T
  ///còn transform T -> dynamic
  ///fromBind độ dài Stream không đổi
  print(
      'transform fromBind: ${await countStream(0, 10).transform(StreamTransformer<int, String>.fromBind((p0) => p0.map((event) => (event * 2).toString()))).toList()}');

  ///fromHandlers có thể thay đổi độ dài của Stream
  print('transform fromHandlers: ${await countStream(0, 10).transform(StreamTransformer<int, String>.fromHandlers(
    handleData: (data, sink) {
      if (data % 2 == 0) {
        sink.add(data.toString());
      }
    },
  )).toList()}');

  // print('buffer: ${await countStream(0, 10).debounceTime(duration)}');
}
