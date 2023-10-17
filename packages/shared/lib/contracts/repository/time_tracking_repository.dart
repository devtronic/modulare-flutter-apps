import '../dto/task.dart';
import '../dto/time_tracking_entry.dart';

abstract class TimeTrackingRepository {
  Stream<List<TimeTrackingEntry>> get entries$;

  void startTimeTracking(Task task);

  void stopTimeTracking(TimeTrackingEntry entry);

  void delete(TimeTrackingEntry entry);
}
