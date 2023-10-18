import '../dto/time_tracking_entry.dart';

/// Is dispatched after the time tracking was deleted
class TimeTrackingDeletedEvent {
  TimeTrackingEntry timeTrackingEntry;

  TimeTrackingDeletedEvent(this.timeTrackingEntry);
}
