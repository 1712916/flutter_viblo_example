import 'package:flutter/material.dart';
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
    return const MaterialApp(
      title: 'Flutter Demo',
      home: ExampleBoardPage(),
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
              push(context, EmailPage());
            },
            child: const Text('Email Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, ReOrderPage());
            },
            child: const Text('Re Order Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, RemoteConfigPage());
            },
            child: const Text('Remote Config Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, PDAPage());
            },
            child: const Text('PDA Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, BarcodeListenerPage());
            },
            child: const Text('Barcode Listener Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, DatePage());
            },
            child: const Text('Date Picker Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, MonthPage());
            },
            child: const Text('Month Picker Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, YearPage());
            },
            child: const Text('Year Picker Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, LoadingPage());
            },
            child: const Text('Loading Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, TaskRunnerPage());
            },
            child: const Text('Task Runner Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              push(context, UploadImagePage());
            },
            child: const Text('Upload Image Page'),
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
