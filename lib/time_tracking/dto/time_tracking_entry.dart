class TimeTrackingEntry {
  int id;
  int taskId;
  DateTime startedAt;
  DateTime? endedAt;

  TimeTrackingEntry({
    required this.id,
    required this.taskId,
    required this.startedAt,
    this.endedAt,
  });
}
