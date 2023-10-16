import 'dart:math';

import '../dto/task.dart';
import 'package:rxdart/rxdart.dart';

class TaskRepository {
  final _tasks$ = BehaviorSubject<List<Task>>();

  late final Stream<List<Task>> tasks$ = _tasks$;

  TaskRepository() {
    _tasks$.value = [
      // Task(
      //   id: 1,
      //   createdAt: DateTime.now().add(const Duration(days: 10)),
      //   text: 'Task 1',
      // ),
      // Task(
      //   id: 2,
      //   createdAt: DateTime.now().add(const Duration(days: 12)),
      //   text: 'Task 2',
      //   isDone: true,
      // ),
      // Task(
      //   id: 3,
      //   createdAt: DateTime.now().add(const Duration(days: 1)),
      //   text: 'Task 3',
      //   isDone: false,
      // ),
    ];
  }

  void updateTaskState(Task task, bool isDone) {
    var newTasks = [..._tasks$.value];
    var index = newTasks.indexWhere((t) => t.id == task.id);
    if (index < 0) {
      return;
    }
    if (isDone) {
      task.doneAt = task.doneAt ?? DateTime.now();
    } else {
      task.doneAt = null;
    }
    task.isDone = isDone;
    newTasks[index] = task;
    _tasks$.value = newTasks;
  }

  void save(Task task) {
    var newTasks = [..._tasks$.value];
    if (task.id <= 0) {
      var maxId = newTasks.isEmpty ? 0 : newTasks.map((e) => e.id).reduce(max);
      task.id = maxId + 1;
    }
    task.createdAt ??= DateTime.now();

    var index = newTasks.indexWhere((t) => t.id == task.id);
    if (index < 0) {
      newTasks.add(task);
    } else {
      newTasks[index] = task;
    }

    _tasks$.value = newTasks;
  }

  void delete(Task task) {
    var newTasks = [..._tasks$.value];
    var index = newTasks.indexWhere((t) => t.id == task.id);
    if (index < 0) {
      return;
    }
    newTasks.removeAt(index);
    _tasks$.value = newTasks;
  }
}
