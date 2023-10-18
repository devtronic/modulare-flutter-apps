class TimeTrackingEntry {
  int id;
  int taskId;
  String taskText;
  DateTime startedAt;
  DateTime? endedAt;

  TimeTrackingEntry({
    required this.id,
    required this.taskId,
    required this.startedAt,
    required this.taskText,
    this.endedAt,
  });
}
