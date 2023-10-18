import '../dto/time_tracking_entry.dart';

/// Is dispatched after the time tracking was finished
class TimeTrackingUpdatedEvent {
  TimeTrackingEntry timeTrackingEntry;

  TimeTrackingUpdatedEvent(this.timeTrackingEntry);
}
