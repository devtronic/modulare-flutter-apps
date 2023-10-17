import '../../tasks/dto/task.dart';
import 'time_tracking_entry.dart';

class TimeTrackingListEntry {
  final TimeTrackingEntry entry;
  final Task? task;

  TimeTrackingListEntry({required this.entry, this.task});
}
