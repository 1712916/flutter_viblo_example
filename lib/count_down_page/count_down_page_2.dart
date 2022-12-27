import 'dart:async';

import 'package:flutter/material.dart';

import 'count_down_page.dart';

class CountDownCustomCubitPage extends StatefulWidget {
  const CountDownCustomCubitPage({Key? key, required this.seconds}) : super(key: key);

  final int seconds;

  @override
  State<CountDownCustomCubitPage> createState() => CountDownCustomCubitPageState();
}

class CountDownCustomCubitPageState extends State<CountDownCustomCubitPage> {
  late TimerCubit _timerCubit;

  @override
  void initState() {
    super.initState();
    _timerCubit = TimerCubit(widget.seconds)..init();
  }

  @override
  void dispose() {
    _timerCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBlocProvider<TimerCubit>(
      bloc: _timerCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text("Timer test")),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const _Content(),
                StreamBuilder(
                  initialData: CountDownEvent.reset,
                  stream: _timerCubit.timerControllerStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      if (data == CountDownEvent.reset) {
                        return Button(
                          onTap: () {
                            _timerCubit.timerController(CountDownEvent.start);
                          },
                          title: "Start",
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Button(
                            onTap: () {
                              _timerCubit.timerController(CountDownEvent.pause);
                            },
                            title: 'Pause',
                          ),
                          Button(
                            onTap: () {
                              _timerCubit.timerController(CountDownEvent.resume);
                            },
                            title: 'Resume',
                          ),
                          Button(
                            onTap: () {
                              _timerCubit.timerController(CountDownEvent.reset);
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
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerCubit = context.read<TimerCubit>();
    // final timerCubit = CustomBlocProvider.of<TimerCubit>(context);
    return StreamBuilder<int>(
      initialData: timerCubit.startTime,
      stream: timerCubit.stream,
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
      },
    );
  }
}

abstract class CustomCubit<T> {
  CustomCubit(T initValue) {
    _streamCtrl = StreamController.broadcast()..add(initValue);
    //nếu dùng thêm thư viện rxdart thì xài seed để init value
  }

  late StreamController<T> _streamCtrl;

  Stream<T> get stream => _streamCtrl.stream;

  void emit(T state) {
    _streamCtrl.add(state);
  }

  void close() {
    _streamCtrl.close();
  }
}

class TimerCubit extends CustomCubit<int> {
  TimerCubit(int initValue) : super(initValue) {
    startTime = initValue;
  }

  StreamSubscription? _timeSubscription;

  late StreamSubscription _functionSubscription;

  final StreamController<CountDownEvent> _functionController = StreamController.broadcast();

  Stream<CountDownEvent> get timerControllerStream => _functionController.stream;

  int startTime = 0;

  @override
  void close() {
    _timeSubscription?.cancel();
    _functionSubscription.cancel();
    _functionController.close();
    super.close();
  }

  void init() {
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

  void _setTime(int time) {
    emit(time);
  }

  void _onStart() {
    if (_timeSubscription != null) {
      _onReset();
    }
    _timeSubscription = Stream.periodic(const Duration(seconds: 1), (computationCount) => startTime - computationCount).listen(
      (time) {
        _setTime(time);
        if (time == 0) {
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
    _setTime(startTime);
  }

  void timerController(CountDownEvent event) {
    _functionController.add(event);
  }
}

class CustomBlocProvider<T extends CustomCubit> extends InheritedWidget {
  const CustomBlocProvider({
    super.key,
    required this.bloc,
    required super.child,
  });

  final T bloc;

  static CustomBlocProvider? maybeOf<T extends CustomCubit>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CustomBlocProvider<T>>();
  }

  static T of<T extends CustomCubit>(BuildContext context) {
    final CustomBlocProvider? result = maybeOf<T>(context);
    assert(result != null, 'No BlocProvider found in context');
    return result!.bloc as T;
  }

  @override
  bool updateShouldNotify(CustomBlocProvider oldWidget) => bloc != oldWidget.bloc;
}

extension ReadCustomBlocProviderOfContext on BuildContext {
  T read<T extends CustomCubit>() {
    return CustomBlocProvider.of<T>(this);
  }
}
