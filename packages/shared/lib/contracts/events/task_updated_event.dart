import '../dto/task.dart';

/// Is dispatched after the task was updated
class TaskUpdatedEvent {
  Task task;

  TaskUpdatedEvent(this.task);
}
