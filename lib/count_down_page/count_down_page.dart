import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stream_state_management/main.dart';

import 'count_down_page_2.dart';

class CountDownPage extends StatefulWidget {
  const CountDownPage({Key? key, required this.seconds}) : super(key: key);

  final int seconds;

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  int _start = 0;

  final StreamController<int> _timeStreamController = StreamController();

  Stream<int> get _timeStream => _timeStreamController.stream;

  StreamSubscription? _timeSubscription;

  late StreamSubscription _functionSubscription;

  final StreamController<CountDownEvent> _functionController = StreamController.broadcast();

  void setTime({int? time}) {
    _start = time ?? widget.seconds;
  }

  @override
  void initState() {
    super.initState();
    setTime();

    ///việc quản lý các sự kiện bằng stream ở đây
    ///giúp cho các công việc không thực hiện lại công việc nó đang thực hiện
    ///bằng hàm distinct()
    _functionSubscription = _functionController.stream.distinct().listen((event) {
      switch (event) {
        case CountDownEvent.start:
          _onStart();
          break;
        case CountDownEvent.pause:
          _onPause();
          break;
        case CountDownEvent.resume:
          _onResume();
          break;
        case CountDownEvent.reset:
          _onReset();
          break;
      }
    });
  }

  @override
  void dispose() {
    _timeSubscription?.cancel();
    _functionSubscription.cancel();
    _timeStreamController.close();
    _functionController.close();
    super.dispose();
  }

  void _onStart() {
    if (_timeSubscription != null) {
      _onReset();
    }
    _timeSubscription = Stream.periodic(const Duration(seconds: 1), (computationCount) => _start - computationCount).listen(
      (event) {
        _timeStreamController.add(event);
        if (event == 0) {
          _onFinish();
        }
      },
    );
  }

  void _onResume() {
    if (_timeSubscription?.isPaused ?? false) {
      _timeSubscription?.resume();
    }
  }

  void _onPause() {
    if (!(_timeSubscription?.isPaused ?? true)) {
      _timeSubscription?.pause();
    }
  }

  void _onFinish() {
    _timeSubscription?.cancel();
    _timeSubscription = null;
  }

  void _onReset() {
    _timeSubscription?.cancel();
    _timeSubscription = null;
    _timeStreamController.add(_start);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer test"),
        actions: [
          IconButton(
            onPressed: () {
              push(context, const CountDownCustomCubitPage(seconds: 100));
            },
            icon: const Icon(Icons.swap_horiz),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<int>(
                  initialData: _start,
                  stream: _timeStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final int time = snapshot.data!;
                      var separateWidget = Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          ':',
                          style: Theme.of(context).textTheme.headline2?.copyWith(
                                fontFamily: 'BlackOpsOne',
                              ),
                          textAlign: TextAlign.center,
                        ),
                      );
                      return FittedBox(
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextWidget(
                                number: time.hour.tens,
                              ),
                              TextWidget(
                                number: time.hour.ones,
                              ),
                              separateWidget,
                              TextWidget(
                                number: time.minute.tens,
                              ),
                              TextWidget(
                                number: time.minute.ones,
                              ),
                              separateWidget,
                              TextWidget(
                                number: time.second.tens,
                              ),
                              TextWidget(
                                number: time.second.ones,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  }),
              StreamBuilder(
                initialData: CountDownEvent.reset,
                stream: _functionController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    if (data == CountDownEvent.reset) {
                      return Button(
                        onTap: () {
                          _functionController.add(CountDownEvent.start);
                        },
                        title: "Start",
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Button(
                          onTap: () {
                            _functionController.add(CountDownEvent.pause);
                          },
                          title: 'Pause',
                        ),
                        Button(
                          onTap: () {
                            _functionController.add(CountDownEvent.resume);
                          },
                          title: 'Resume',
                        ),
                        Button(
                          onTap: () {
                            _functionController.add(CountDownEvent.reset);
                          },
                          title: 'Reset',
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({Key? key, required this.number}) : super(key: key);

  final int number;

  @override
  Widget build(BuildContext context) {
    final size = textSize(
      '0',
      Theme.of(context).textTheme.headline2!.copyWith(fontFamily: 'BlackOpsOne'),
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: size.width,
        child: Center(
          child: Text(
            number.toString(),
            style: Theme.of(context).textTheme.headline2?.copyWith(fontFamily: 'BlackOpsOne'),
          ),
        ),
      ),
    );
  }
}

Size textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );
  return textPainter.size;
}

enum CountDownEvent {
  start,
  pause,
  resume,
  reset,
}

///seconds => separate time
extension IntToTime on int {
  ///lấy thông tin giờ
  int get hour => _getHour();

  int _getHour() {
    return (this / 3600).floor();
    // return Duration(seconds: this).inHours;
  }

  ///lấy thông tin giờ
  int get minute => _getMinute();

  int _getMinute() {
    return (this / 60).floor() % 60;
  }

  ///lấy thông tin giây
  int get second => _getSecond();

  int _getSecond() {
    return this % 60;
  }

  ///format hiển thị số ở hàng chục
  int get tens => _getTens();

  int _getTens() {
    if (this >= 10) {
      return ((this - (this % 10)) / 10).round();
    }
    return 0;
  }

  ///format hiển thị số ở hàng đơn vị
  int get ones => _getOnes();

  int _getOnes() {
    return this % 10;
  }
}

class Button extends StatelessWidget {
  const Button({Key? key, required this.title, this.onTap}) : super(key: key);

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide(width: 1, color: Colors.black45))),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontFamily: 'BlackOpsOne',
              ),
        ),
      ),
    );
  }
}
