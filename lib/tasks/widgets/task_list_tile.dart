import 'package:flutter/material.dart';

import '../../helper.dart';
import '../dto/task_list_entry.dart';

class TaskListTile extends StatelessWidget {
  final TaskListEntry entry;

  final void Function(bool isDone) onUpdateTaskState;
  final void Function() onEdit;
  final void Function() onDelete;

  const TaskListTile({
    required this.entry,
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
      subtitle: _buildSubtitle(),
      value: entry.task.isDone,
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
    if (entry.task.isDone) {
      style = const TextStyle(decoration: TextDecoration.lineThrough);
    }
    return Text(entry.task.text, style: style);
  }

  Widget? _buildSubtitle() {
    if (entry.totalTimeSpent.inSeconds == 0) {
      return null;
    }

    return Text(entry.totalTimeSpent.asHumanReadable());
  }
}
