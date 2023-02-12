import 'package:flutter/material.dart';
import 'package:flutter_example/count_down_page/count_down_page.dart';
import 'package:flutter_example/scan_code_page/scan_code_page.dart';
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
        ],
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
