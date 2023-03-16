import 'package:flutter/material.dart';
import 'package:flutter_example/count_down_page/count_down_page_2.dart';

class ContextPage extends StatefulWidget {
  const ContextPage({Key? key}) : super(key: key);

  @override
  State<ContextPage> createState() => _ContextPageState();
}

class _ContextPageState extends State<ContextPage> {
  @override
  Widget build(BuildContext parentContext) {
    print('context.runtimeType: ${parentContext.toString()}');
    print('context.runtimeType: ${parentContext.widget}');
    print('context.runtimeType: ${parentContext.owner?.globalKeyCount}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Context Page'),
      ),
      body: Column(
        children: [
          ChildWidget(),
          TextButton(
              onPressed: () {
                print('context.runtimeType: ${context.toString()}');
              },
              child: Text('Click here'))
        ],
      ),
    );
  }
}

class ChildWidget extends StatelessWidget {
  const ChildWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('context.runtimeType: ${context.toString()}');
    return const Placeholder();
  }
}
