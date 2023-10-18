import 'dart:math';

import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:rxdart/rxdart.dart';

@Service(
  lifetime: ServiceLifetime.singleton,
  exposeAs: TaskRepository,
)
class InMemoryTaskRepository implements TaskRepository {
  final EventDispatcher _dispatcher;

  final _tasks$ = BehaviorSubject<List<Task>>()..add([]);

  @override
  late final Stream<List<Task>> tasks$ = _tasks$;

  InMemoryTaskRepository(this._dispatcher) {
    _tasks$.add([
      Task(
        id: 1,
        createdAt: DateTime.now().add(const Duration(days: 10)),
        text: 'Task 1',
      ),
      Task(
        id: 2,
        createdAt: DateTime.now().add(const Duration(days: 12)),
        text: 'Task 2',
        isDone: true,
      ),
      Task(
        id: 3,
        createdAt: DateTime.now().add(const Duration(days: 1)),
        text: 'Task 3',
        isDone: false,
      ),
    ]);
  }

  @override
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
    _tasks$.add(newTasks);
  }

  @override
  void save(Task task) {
    var newTasks = [..._tasks$.value];
    var isNewTask = task.id <= 0;
    if (isNewTask) {
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

    _tasks$.add(newTasks);
    if (isNewTask) {
      _dispatcher.dispatch(TaskCreatedEvent(task));
    } else {
      _dispatcher.dispatch(TaskUpdatedEvent(task));
    }
  }

  @override
  void delete(Task task) {
    var newTasks = [..._tasks$.value];
    var index = newTasks.indexWhere((t) => t.id == task.id);
    if (index < 0) {
      return;
    }
    var event = DeleteTaskEvent(task);
    _dispatcher.dispatch(event);
    if (event.cancelRequested) {
      print('Cancel was requested, do not delete task!');
      return;
    }

    newTasks.removeAt(index);
    _tasks$.add(newTasks);
    _dispatcher.dispatch(TaskDeletedEvent(task));
  }
}
