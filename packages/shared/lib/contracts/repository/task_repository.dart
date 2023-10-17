import '../dto/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> get tasks$;

  void updateTaskState(Task task, bool isDone);

  void save(Task task);

  void delete(Task task);
}
