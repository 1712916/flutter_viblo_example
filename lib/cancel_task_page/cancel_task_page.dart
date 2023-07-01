import 'package:flutter/material.dart';
import 'package:flutter_example/cancel_task_page/cancel_task_util.dart';

class CancelTaskPage extends StatefulWidget {
  const CancelTaskPage({Key? key}) : super(key: key);

  @override
  State<CancelTaskPage> createState() => _CancelTaskPageState();
}

class _CancelTaskPageState extends State<CancelTaskPage> {
  final CancelTaskUtil _cancelTaskUtil = CancelTaskUtil();

  int _number = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cancelTaskUtil.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Task'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _cancelTaskUtil.addTask(
                    countStream(0, 9),
                    (event) {
                      _number = event;
                      setState(() {});
                    },
                    (err, stackTrace) {},
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: const Text('Task 1: Count from 0 -> 9'),
                ),
              ),
              InkWell(
                onTap: () {
                  _cancelTaskUtil.addTask(
                    countStream(10, 99),
                    (event) {
                      _number = event;
                      setState(() {});
                    },
                    (err, stackTrace) {},
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.cyan,
                  alignment: Alignment.center,
                  child: const Text('Task 1: Count from 10 -> 99'),
                ),
              ),
            ],
          ),
          Text(
            'NUMBER: \n$_number',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text(''),
      ),
    );
  }
}

Stream<int> countStream(int from, int to) async* {
  for (int i = from; i <= to; i++) {
    await Future.delayed(const Duration(milliseconds: 200));
    yield i;
  }
}
