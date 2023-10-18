import '../dto/time_tracking_entry.dart';

/// Is dispatched after the time tracking was started
class TimeTrackingStartedEvent {
  TimeTrackingEntry timeTrackingEntry;

  TimeTrackingStartedEvent(this.timeTrackingEntry);
}
