import 'dart:math';

import 'package:rxdart/rxdart.dart';

import '../../tasks/dto/task.dart';
import '../dto/time_tracking_entry.dart';

class TimeTrackingRepository {
  final _entries$ = BehaviorSubject<List<TimeTrackingEntry>>()
    ..add([
      TimeTrackingEntry(
        id: 1,
        startedAt:
            DateTime.now().subtract(const Duration(hours: 2, minutes: 3)),
        endedAt: DateTime.now(),
        taskId: 1,
      )
    ]);

  late final Stream<List<TimeTrackingEntry>> entries$ = _entries$;

  void startTimeTracking(Task task) {
    var entry = TimeTrackingEntry(
      id: _getNewId(),
      taskId: task.id,
      startedAt: DateTime.now(),
    );

    _entries$.add([
      ..._entries$.value,
      entry,
    ]);
  }

  int _getNewId() {
    if (_entries$.value.isEmpty) {
      return 1;
    }
    return _entries$.value.map((e) => e.id).reduce(max) + 1;
  }

  void stopTimeTracking(TimeTrackingEntry entry) {
    var newEntries = [..._entries$.value];
    entry.endedAt = DateTime.now();

    var index = newEntries.indexWhere((e) => e.id == entry.id);
    if (index < 0) {
      return;
    }
    newEntries[index] = entry;
    _entries$.add(newEntries);
  }

  void delete(TimeTrackingEntry entry) {
    var newEntries = [..._entries$.value];
    var index = newEntries.indexWhere((e) => e.id == entry.id);
    if (index < 0) {
      return;
    }
    newEntries.removeAt(index);
    _entries$.add(newEntries);
  }
}
