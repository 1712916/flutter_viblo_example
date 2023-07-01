import 'package:flutter/material.dart';
import 'package:flutter_example/app_life_cycle/app_life_cycle_page.dart';
import 'package:flutter_example/cached_network_image/cached_network_image_page.dart';
import 'package:flutter_example/cancel_task_page/cancel_task_page.dart';
import 'package:flutter_example/compress_image/compress_image_page.dart';
import 'package:flutter_example/context_page/context_page.dart';
import 'package:flutter_example/count_down_page/count_down_page.dart';
import 'package:flutter_example/custom_date_picker/date_picker_page.dart';
import 'package:flutter_example/isar_page/email_page.dart';
import 'package:flutter_example/loading_page/loading_page.dart';
import 'package:flutter_example/pda_page/barcode_listener.dart';
import 'package:flutter_example/pda_page/pda_page.dart';
import 'package:flutter_example/re_order_page/reorder_page.dart';
import 'package:flutter_example/remote_config_page/remote_config_page.dart';
import 'package:flutter_example/scan_code_page/scan_code_page.dart';
import 'package:flutter_example/scroll_hide_bottom/scoll_hide_bottom.dart';
import 'package:flutter_example/task_runner/task_runner_page.dart';
import 'package:flutter_example/upload_image_page/upload_image_page.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

void main() {
  zx.setLogEnabled(false);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const ExampleBoardPage(),
      navigatorObservers: [
        AppLifeCycleMixin.routeObserver,
      ],
    );
  }
}

final _plugins = initializePlugins(
  contentsSidePanel: true,
  knobsSidePanel: true,
  initialDeviceFrameData: DeviceFrameData(
    device: Devices.ios.iPhone13,
  ),
);

class ExampleBoardPage extends StatefulWidget {
  const ExampleBoardPage({Key? key}) : super(key: key);

  @override
  _ExampleBoardPageState createState() => _ExampleBoardPageState();
}

class _ExampleBoardPageState extends State<ExampleBoardPage> {
  bool useStoryBook = false;

  final List<Story> storyList = [
    Story(name: 'Count Down', builder: (context) => const CountDownPage(seconds: 1000)),
    Story(name: 'Scan Code', builder: (context) => const QRViewExample()),
    Story(name: 'Context Page', builder: (context) => const ContextPage()),
    Story(name: 'Email Page', builder: (context) => const EmailPage()),
    Story(name: 'Re Order Page', builder: (context) => const ReOrderPage()),
    Story(name: 'Remote Config Page', builder: (context) => const RemoteConfigPage()),
    Story(name: 'PDA Page', builder: (context) => const PDAPage()),
    Story(name: 'Barcode Listener Page', builder: (context) => const BarcodeListenerPage()),
    Story(name: 'Date Picker Page', builder: (context) => const DatePage()),
    Story(name: 'Month Picker Page', builder: (context) => const MonthPage()),
    Story(name: 'Year Picker Page', builder: (context) => const YearPage()),
    Story(name: 'Loading Page', builder: (context) => const LoadingPage()),
    Story(name: 'Task Runner Page', builder: (context) => const TaskRunnerPage()),
    Story(name: 'Upload Image Page', builder: (context) => const UploadImagePage()),
    Story(name: 'Scroll Hide Bottom', builder: (context) => const ScrollHideBottomPage()),
    Story(name: 'App Life Cycle', builder: (context) => const RouteAwareWidget()),
    Story(name: 'Compress Image Page', builder: (context) => const CompressImagePage()),
    Story(name: 'Cache Network Image Page', builder: (context) => const CachedNetworkImagePage()),
    Story(name: 'Cancel Task Page', builder: (context) => const CancelTaskPage()),
  ];

  @override
  Widget build(BuildContext context) {
    if (useStoryBook) {
      return Stack(
        children: [
          Storybook(
            plugins: _plugins,
            stories: storyList,
          ),
          Positioned(
            right: 30,
            bottom: 100,
            child: FloatingActionButton(
              child: const Text('Board'),
              onPressed: () {
                useStoryBook = false;
                setState(() {});
              },
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Board',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text('Story Book'),
        onPressed: () {
          useStoryBook = true;
          setState(() {});
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (var story in storyList)
            ElevatedButton(
              onPressed: () async {
                push(context, story.builder(context));
              },
              child: Text(story.name),
            ),
        ].reversed.toList(),
      ),
    );
  }
}

Future push(BuildContext context, Widget child) async {
  return await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return child;
      },
    ),
  );
}
