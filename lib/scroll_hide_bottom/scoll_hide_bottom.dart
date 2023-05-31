import 'dart:async';

import 'package:flutter/material.dart';

class ScrollHideBottomPage extends StatefulWidget {
  const ScrollHideBottomPage({Key? key}) : super(key: key);

  @override
  State<ScrollHideBottomPage> createState() => _ScrollHideBottomPageState();
}

class _ScrollHideBottomPageState extends State<ScrollHideBottomPage> with ScrollHideBottomBar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scroll Hide Bottom')),
      body: buildScrollNotifier(),
    );
  }

  @override
  Widget buildBottomBar() {
    return Container(
      color: Colors.white,
      height: 50,
      alignment: Alignment.center,
      child: Text('Bottom Bar'),
    );
  }

  @override
  Widget buildScroll() {
    return ListView.builder(
      itemBuilder: (context, index) => Container(
        height: 105,
        color: Colors.primaries[index % 8],
      ),
      //itemCount: 7,
    );
  }
}

class ScrollListener extends ChangeNotifier {
  double bottom = 0;

  double _last = 0;

  double height = 0;

  final ScrollController controller = ScrollController();

  ScrollListener.initialise() {
    controller.addListener(_listener);
  }

  _listener() {
    updatePosition(controller.offset);
  }

  updatePosition(double offset) {
    final current = offset;

    bottom += _last - current;

    if (bottom <= -height) bottom = -height;

    if (bottom >= 0) bottom = 0;

    _last = current;

    if (bottom <= 0 && bottom >= -height) notifyListeners();
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }
}

mixin ScrollHideBottomBar<T extends StatefulWidget> on State<T> {
  final GlobalKey _key = GlobalKey();

  final GlobalKey<_AnimationBottomState> _animationKey = GlobalKey();

  final ScrollListener _model = ScrollListener.initialise();

  void onBottomHeightChanged(double height) {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      try {
        final box = _key.currentContext?.findRenderObject() as RenderBox?;
        if (box != null) {
          _model.height = box.size.height;
          onBottomHeightChanged(_model.height);
        }
      } catch (e) {}
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Widget buildScrollNotifier() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical) {
          if (notification is ScrollUpdateNotification) {
            if ((notification.scrollDelta ?? 0) >= 0) {
              _animationKey.currentState?.setBottom(-_model.height);
            } else {
              _animationKey.currentState?.setBottom(0);
            }
          }
        } else {
          _animationKey.currentState?.showBottom();
        }

        return true;
      },
      child: Stack(
        children: [
          buildScroll(),
          _AnimationBottom(
            key: _animationKey,
            child: SizedBox(
              key: _key,
              child: buildBottomBar(),
            ),
          )
        ],
      ),
    );
  }

  Widget buildScroll();

  Widget buildBottomBar();
}

class _AnimationBottom extends StatefulWidget {
  const _AnimationBottom({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<_AnimationBottom> createState() => _AnimationBottomState();
}

class _AnimationBottomState extends State<_AnimationBottom> {
  final StreamController<double> _streamController = StreamController();

  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _streamController.stream.distinct().listen((bottom) {
      _bottom = bottom;
      setState(() {});
    });
  }

  double _bottom = 0;

  void setBottom(double bottomHeight) {
    _streamController.add(bottomHeight);
  }

  void showBottom() {
    _streamController.add(0);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      bottom: _bottom,
      left: 0,
      right: 0,
      child: widget.child,
    );
  }
}
