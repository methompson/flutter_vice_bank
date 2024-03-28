import 'dart:async';

import 'package:flutter_vice_bank/utils/task_queue/api_task.dart';

class APITaskQueue {
  final List<APITask> _tasks = [];
  Timer? _timer;
  bool _working = false;

  void Function(APITask task) onTaskCompleted;

  APITaskQueue({required this.onTaskCompleted});

  void addTask(APITask task) {
    _tasks.add(task);
    execute();
  }

  Future<void> execute() async {
    _timer?.cancel();

    if (_tasks.isEmpty) {
      _working = false;
      return;
    }

    if (_working) {
      return;
    }

    _working = true;

    try {
      final task = _tasks[0];
      await task.execute();
      _tasks.removeAt(0);

      onTaskCompleted(task);
    } catch (e) {
      _timer = Timer(Duration(minutes: 1), execute);
    }

    execute();
  }
}
