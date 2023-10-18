import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:ctwebdev2023_tasks_public/ctwebdev2023_tasks_public.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:flutter/material.dart';

@Service(tags: [#eventSubscriber])
@Preload()
class TaskEventSubscriber {
  final GlobalKey<NavigatorState> _navigatorKey;

  final TaskRepository _taskRepository;

  TaskEventSubscriber(this._navigatorKey, this._taskRepository);

  @Subscribe()
  void onCreateTask(CreateTaskEvent event) => _showTaskDialog();

  @Subscribe()
  void onEditTask(EditTaskEvent event) => _showTaskDialog(event.task);

  void _showTaskDialog([Task? task]) {
    showDialog<Task?>(
      context: _navigatorKey.currentContext!,
      builder: (ctx) => EditTaskDialog(task: task),
    ).then((task) {
      if (task != null) {
        _taskRepository.save(task);
      }
    });
  }
}
