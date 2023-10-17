import 'package:flutter/material.dart';

import '../dto/task.dart';

class TaskListTile extends StatelessWidget {
  final Task task;

  final void Function(bool isDone) onUpdateTaskState;
  final void Function() onEdit;
  final void Function() onDelete;

  const TaskListTile({
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdateTaskState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: _buildTitle(),
      value: task.isDone,
      onChanged: (checked) => onUpdateTaskState(checked ?? false),
      secondary: _buildActions(),
    );
  }

  Widget _buildActions() {
    return Flex(
      direction: Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
        IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline))
      ],
    );
  }

  Text _buildTitle() {
    TextStyle? style;
    if (task.isDone) {
      style = const TextStyle(decoration: TextDecoration.lineThrough);
    }
    return Text(task.text, style: style);
  }
}
