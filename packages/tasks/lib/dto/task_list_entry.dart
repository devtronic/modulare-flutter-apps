import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';

class TaskListEntry {
  final Task task;
  final Duration totalTimeSpent;

  TaskListEntry({
    required this.task,
    this.totalTimeSpent = Duration.zero,
  });
}
