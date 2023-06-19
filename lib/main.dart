import 'package:flutter/material.dart';
import 'package:flutter_example/app_life_cycle/app_life_cycle_page.dart';
import 'package:flutter_example/cached_network_image/cached_network_image_page.dart';
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

class ExampleBoardPage extends StatefulWidget {
  const ExampleBoardPage({Key? key}) : super(key: key);

  @override
  _ExampleBoardPageState createState() => _ExampleBoardPageState();
}

class _ExampleBoardPageState extends State<ExampleBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Board',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () {
              push(
                context,
                const CountDownPage(seconds: 1000),
              );
            },
            child: const Text('Count Down'),
          ),
          ElevatedButton(
            onPressed: () {
              push(
                context,
                const QRViewExample(),
              );
            },
            child: const Text('Scan Code'),
          ),
          ElevatedButton(
            onPressed: () async {
              runApp(
                const MaterialApp(
                  home: ContextPage(),
                ),
              );
            },
            child: const Text('Context Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const EmailPage());
            },
            child: const Text('Email Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const ReOrderPage());
            },
            child: const Text('Re Order Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const RemoteConfigPage());
            },
            child: const Text('Remote Config Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const PDAPage());
            },
            child: const Text('PDA Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const BarcodeListenerPage());
            },
            child: const Text('Barcode Listener Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const DatePage());
            },
            child: const Text('Date Picker Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const MonthPage());
            },
            child: const Text('Month Picker Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const YearPage());
            },
            child: const Text('Year Picker Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const LoadingPage());
            },
            child: const Text('Loading Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const TaskRunnerPage());
            },
            child: const Text('Task Runner Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const UploadImagePage());
            },
            child: const Text('Upload Image Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const ScrollHideBottomPage());
            },
            child: const Text('Scroll Hide Bottom'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const RouteAwareWidget());
            },
            child: const Text('App Life Cycle'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, const CompressImagePage());
            },
            child: const Text('Compress Image Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, CachedNetworkImagePage());
            },
            child: const Text('Cache Network Image Page'),
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
