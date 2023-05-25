import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  final ScrollListener _model = ScrollListener.initialise();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      try {
        final box = _key.currentContext?.findRenderObject() as RenderBox?;
        if (box != null) {
          _model.height = box.size.height;
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
          _model.updatePosition(notification.metrics.pixels);
        }

        return true;
      },
      child: Stack(
        children: [
          buildScroll(),
          AnimatedBuilder(
            animation: _model,
            builder: (context, child) {
              return Positioned(
                bottom: _model.bottom,
                left: 0,
                right: 0,
                child: child!,
              );
            },
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
