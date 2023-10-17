import 'task.dart';

class TaskListEntry {
  final Task task;
  final Duration totalTimeSpent;

  TaskListEntry({
    required this.task,
    this.totalTimeSpent = Duration.zero,
  });
}
