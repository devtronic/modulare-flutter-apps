import '../dto/task.dart';

/// Is dispatched before the task is deleted
class DeleteTaskEvent {
  Task task;
  bool cancelRequested = false;

  DeleteTaskEvent(this.task);
}
