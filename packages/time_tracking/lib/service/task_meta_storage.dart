import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:rxdart/rxdart.dart';

@Service()
class TaskMetaStorage {
  final _taskTextsById$ = BehaviorSubject<Map<int, String>>()..add({});

  Stream<Map<int, String>> get taskTextsById$ => _taskTextsById$;

  void setTaskText(int id, String name) {
    var taskTextsById = {..._taskTextsById$.value};
    taskTextsById[id] = name;
    _taskTextsById$.add(taskTextsById);
  }

  void removeTaskNameById(int id) {
    var taskTextsById = {..._taskTextsById$.value};
    if (taskTextsById.containsKey(id)) {
      taskTextsById.remove(id);
      _taskTextsById$.add(taskTextsById);
    }
  }

  MapEntry<int, String>? getEntryForId(int? id) {
    if (_taskTextsById$.value.containsKey(id)) {
      return _taskTextsById$.value.entries.firstWhere((e) => e.key == id);
    }
    return null;
  }
}
