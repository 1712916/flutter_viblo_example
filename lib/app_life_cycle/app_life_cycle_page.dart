import 'package:flutter/material.dart';
import 'package:flutter_example/main.dart';

class RouteAwareWidget extends StatefulWidget {
  const RouteAwareWidget({super.key});

  @override
  State<RouteAwareWidget> createState() => RouteAwareWidgetState();
}

class RouteAwareWidgetState extends AppLifeCycleMixin<RouteAwareWidget> {
  String text = 'On Start';

  @override
  void onResume() {
    super.onResume();
    text = 'On Resume';
    setState(() {});
  }

  @override
  void onPause() {
    super.onPause();
    text = 'On Pause';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Life Cycle'),
      ),
      body: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(context, ExampleBoardPage());
        },
      ),
    );
  }
}

abstract class AppLifeCycleMixin<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver, RouteAware {
  static final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  void onResume() {}

  void onPause() {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void didPushNext() {
    onPause();
  }

  @override
  void didPopNext() {
    onResume();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
