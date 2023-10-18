import '../dto/time_tracking_entry.dart';

/// Is dispatched after the time tracking was finished
class TimeTrackingFinishedEvent {
  TimeTrackingEntry timeTrackingEntry;

  TimeTrackingFinishedEvent(this.timeTrackingEntry);
}
