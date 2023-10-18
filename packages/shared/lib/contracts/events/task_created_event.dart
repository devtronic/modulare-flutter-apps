import '../dto/task.dart';

/// Is dispatched after the task was created
class TaskCreatedEvent {
  Task task;

  TaskCreatedEvent(this.task);
}
