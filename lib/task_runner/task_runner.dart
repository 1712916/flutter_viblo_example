import 'dart:developer';

import 'package:collection/collection.dart';

class FunctionModel {
  final int priority;
  final Function function;
  final List<dynamic>? positionalArguments;
  final Map<Symbol, dynamic>? namedArguments;
  final String? taskName;

  FunctionModel(
    this.function, {
    this.positionalArguments,
    this.namedArguments,
    this.taskName,
    required this.priority,
  });
}

class TaskRunner {
  static final TaskRunner _i = TaskRunner._();

  TaskRunner._();

  factory TaskRunner() => _i;

  final PriorityQueue<FunctionModel> _priorityQueue = PriorityQueue((p0, p1) => p0.priority.compareTo(p1.priority));

  bool _isRunning = false;

  bool _isStopping = false;

  void addTask(FunctionModel task) {
    _priorityQueue.add(task);
    _execute();
  }

  void addTasks(Iterable<FunctionModel> tasks) {
    _priorityQueue.addAll(tasks);
    _execute();
  }

  Future _execute() async {
    if (!_isStopping && !_isRunning) {
      _isRunning = true;
      while (!isEmpty()) {
        printQueueTaskName();
        final functionModel = _priorityQueue.removeFirst();

        try {
          await Function.apply(
            functionModel.function,
            functionModel.positionalArguments,
            functionModel.namedArguments,
          );
        } catch (e, stackTrace) {
          log('$runtimeType: have error when execute task'
              '\n*********$runtimeType*********'
              '\nError: ${e.toString()}\n$stackTrace'
              '*********$runtimeType*********');
        }

        if (_isStopping) {
          break;
        }
      }
      _isRunning = false;
    } else {
      if (_isStopping) {
        log('$runtimeType: task runner is stopping.');
      } else if (_isRunning) {
        log('$runtimeType: task runner is running.');
      }
    }
  }

  void stop() {
    _isStopping = true;
    log('$runtimeType: is stopping');
  }

  void resume() {
    _isStopping = false;
    _execute();
    log('$runtimeType: is resume');
  }

  bool removeTask(FunctionModel task) => _priorityQueue.remove(task);

  bool isEmpty() => _priorityQueue.isEmpty;

  int get length => _priorityQueue.length;

  void clearAll() {
    _priorityQueue.clear();
    log('$runtimeType: clear all tasks');
  }

  void printQueueTaskName() {
    log('current queue: ${_priorityQueue.toList().map((e) => e.taskName).join('_')}');
  }
}
