import '../dto/task.dart';

/// Is dispatched after the task was deleted
class TaskDeletedEvent {
  Task task;

  TaskDeletedEvent(this.task);
}
