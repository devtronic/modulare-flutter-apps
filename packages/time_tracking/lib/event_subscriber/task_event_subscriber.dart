import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:flutter/material.dart';

@Preload()
@Service(tags: [#eventSubscriber])
class TaskEventSubscriber {
  final TimeTrackingRepository _repository;

  final GlobalKey<NavigatorState> _navigatorKey;

  TaskEventSubscriber(this._repository, this._navigatorKey);

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
    var foundEntries = _repository.findEntriesByTaskId(event.task.id);
    for (var entry in foundEntries) {
      _repository.delete(entry);
    }
  }

  @Subscribe()
  void onTaskUpdated(TaskUpdatedEvent event) {
    var foundEntries = _repository.findEntriesByTaskId(event.task.id);
    for (var entry in foundEntries) {
      entry.taskText = event.task.text;
      _repository.update(entry);
    }
  }
}
