import 'package:ctwebdev2023/tasks/widgets/edit_task_dialog.dart';
import 'package:flutter/material.dart';

import '../dto/task.dart';
import '../repository/task_repository.dart';

class TasksList extends StatelessWidget {
  final TaskRepository _tasksRepository;

  const TasksList({
    required TaskRepository taskRepository,
    super.key,
  }) : _tasksRepository = taskRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Task>>(
        stream: _tasksRepository.tasks$,
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Noch keine Todos vorhanden'),
            );
          }

          return ListView(
            children: snapshot.data!.map(_buildTaskListTile).toList(),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showNewTaskDialog(context),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _showNewTaskDialog(BuildContext context) async {
    await _editTask(context, null);
  }

  Future<void> _editTask(BuildContext context, Task? task) async {
    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => EditTaskDialog(task: task),
    );
    if (result is Task) {
      _tasksRepository.save(result);
    }
  }

  Widget _buildTaskListTile(Task task) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        task.text,
        style: task.isDone
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      value: task.isDone,
      onChanged: (checked) =>
          _tasksRepository.updateTaskState(task, checked ?? false),
      secondary: Builder(
        builder: (context) {
          return Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _editTask(context, task),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () => _deleteTask(context, task),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          );
        },
      ),
    );
  }

  _deleteTask(BuildContext context, Task task) async {
    if (await _confirmDelete(context, task)) {
      _tasksRepository.delete(task);
    }
  }

  Future<bool> _confirmDelete(BuildContext context, Task task) async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Aufgabe löschen'),
            content:
                Text('Möchtest du die Aufgabe ${task.text} wirklich löschen?'),
            actions: [
              TextButton(
                child: const Text('Abbrechen'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FilledButton.tonal(
                style:
                    FilledButton.styleFrom(foregroundColor: Colors.redAccent),
                child: const Text('Löschen'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
        )) ??
        false;
  }
}
