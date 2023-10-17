import 'package:flutter/material.dart';

import './delete_task_dialog.dart';
import './edit_task_dialog.dart';
import './task_list_tile.dart';
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
          return _buildBody(context, snapshot.data!);
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildBody(BuildContext context, List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text('Noch keine Todos vorhanden'),
      );
    }

    return ListView(
      children: tasks.map((task) {
        return TaskListTile(
          task: task,
          onEdit: () => _editTask(context, task),
          onDelete: () => _deleteTask(context, task),
          onUpdateTaskState: (isDone) {
            _tasksRepository.updateTaskState(task, isDone);
          },
        );
      }).toList(),
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

  _deleteTask(BuildContext context, Task task) async {
    if (await _confirmDelete(context, task)) {
      _tasksRepository.delete(task);
    }
  }

  Future<bool> _confirmDelete(BuildContext context, Task task) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteTaskDialog(task: task),
    );
    return result ?? false;
  }
}
