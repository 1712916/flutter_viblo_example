import 'package:flutter/material.dart';
import 'package:flutter_example/task_runner/task_runner.dart';

class TaskRunnerPage extends StatefulWidget {
  const TaskRunnerPage({Key? key}) : super(key: key);

  @override
  State<TaskRunnerPage> createState() => _TaskRunnerPageState();
}

class _TaskRunnerPageState extends State<TaskRunnerPage> {
  List<int> taskDone = [];
  TaskRunner taskRunner = TaskRunner();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Runner'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          taskDone.clear();
          setState(() {});
        },
        child: Text('Clear Done Task'),
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Task',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              3,
              (index) => GestureDetector(
                onTap: () {
                  taskRunner.addTask(
                    FunctionModel(
                      () async {
                        await Future.delayed(Duration(seconds: 1 + index));
                        taskDone.add(index);
                        setState(() {});
                      },
                      priority: index,
                      taskName: 'task $index',
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.primaries[index],
                  child: Text('Prioriry: $index'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  taskRunner.stop();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.redAccent,
                  child: Text('Stop'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  taskRunner.resume();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.greenAccent,
                  child: Text('Resume'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  taskRunner.clearAll();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey,
                  child: Text('Clear All'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Task done',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                for (var task in taskDone)
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.primaries[task],
                    child: Text(task.toString()),
                  )
              ].reversed.toList(),
            ),
          )),
        ],
      ),
    );
  }
}
