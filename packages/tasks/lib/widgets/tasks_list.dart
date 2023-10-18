import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../dto/task_list_entry.dart';
import 'delete_task_dialog.dart';
import 'task_list_tile.dart';

@Service(lifetime: ServiceLifetime.transient)
class TasksList extends StatelessWidget {
  final TaskRepository _tasksRepository;
  final TimeTrackingRepository _timeTrackingRepository;
  final EventDispatcher _eventDispatcher;

  const TasksList({
    required TaskRepository taskRepository,
    required TimeTrackingRepository timeTrackingRepository,
    required EventDispatcher eventDispatcher,
    super.key,
  })  : _eventDispatcher = eventDispatcher,
        _tasksRepository = taskRepository,
        _timeTrackingRepository = timeTrackingRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<TaskListEntry>>(
        stream: _getEntriesStream(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildBody(context, snapshot.data!);
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Stream<List<TaskListEntry>> _getEntriesStream() {
    return CombineLatestStream([
      _tasksRepository.tasks$,
      _timeTrackingRepository.entries$,
    ], (values) {
      var tasks = values[0].toList() as List<Task>;
      var entries = values[1] as List<TimeTrackingEntry>;

      return tasks
          .map((task) => TaskListEntry(
              task: task,
              totalTimeSpent: entries
                  .where((e) => e.taskId == task.id && e.endedAt != null)
                  .fold(Duration.zero, (prev, entry) {
                var diff = entry.endedAt!.difference(entry.startedAt);
                if (diff.isNegative) {
                  return prev;
                }
                return prev + diff;
              })))
          .toList();
    });
  }

  Widget _buildBody(BuildContext context, List<TaskListEntry> entries) {
    if (entries.isEmpty) {
      return const Center(
        child: Text('Noch keine Todos vorhanden'),
      );
    }

    return ListView(
      children: entries.map((entry) {
        var task = entry.task;
        return TaskListTile(
          entry: entry,
          onEdit: () => _editTask(context, task),
          onDelete: () => _deleteTask(context, task),
          onUpdateTaskState: (isDone) {
            _tasksRepository.updateTaskState(task, isDone);
          },
        );
      }).toList(),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _eventDispatcher.dispatch(CreateTaskEvent()),
      child: const Icon(Icons.add),
    );
  }

  void _editTask(BuildContext context, Task task)  {
    _eventDispatcher.dispatch(EditTaskEvent(task));
  }

  void _deleteTask(BuildContext context, Task task) async {
    if (await _confirmDelete(context, task)) {
      _tasksRepository.delete(task);
    }
  }

  Future<bool> _confirmDelete(BuildContext context, Task task) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteTaskDialog(task: task),
    );
    return result ?? false;
  }
}
