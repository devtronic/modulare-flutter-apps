import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:flutter/material.dart';

import '../service/task_meta_storage.dart';

@Preload()
@Service(tags: [#eventSubscriber])
class TaskEventSubscriber {
  final TimeTrackingRepository _repository;

  final GlobalKey<NavigatorState> _navigatorKey;

  final TaskMetaStorage _taskMetaStorage;

  TaskEventSubscriber(this._repository, this._navigatorKey, this._taskMetaStorage);

  @Subscribe()
  void onDeleteTask(DeleteTaskEvent event) {
    var foundEntries = _repository.findEntriesByTaskId(event.task.id);
    if (foundEntries.isNotEmpty) {
      ScaffoldMessenger.of(_navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            '${foundEntries.length} Zeiterfassungseinträge werden ebenfalls gelöscht.',
          ),
        ),
      );
    }
  }

  @Subscribe()
  void onTaskDeleted(TaskDeletedEvent event) {
    var taskId = event.task.id;
    _taskMetaStorage.removeTaskNameById(taskId);
    var foundEntries = _repository.findEntriesByTaskId(taskId);
    for (var entry in foundEntries) {
      _repository.delete(entry);
    }
  }

  @Subscribe()
  void onTaskUpdated(TaskUpdatedEvent event) {
    var taskId = event.task.id;
    var taskText = event.task.text;
    _taskMetaStorage.setTaskText(taskId, taskText);

    var foundEntries = _repository.findEntriesByTaskId(taskId);
    for (var entry in foundEntries) {
      entry.taskText = taskText;
      _repository.update(entry);
    }
  }

  @Subscribe()
  void onTaskCreated(TaskCreatedEvent event) {
    _taskMetaStorage.setTaskText(event.task.id, event.task.text);
  }
}
