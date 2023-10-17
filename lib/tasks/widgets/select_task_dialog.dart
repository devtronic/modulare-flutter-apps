import 'package:ctwebdev2023/tasks/widgets/edit_task_dialog.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../dto/task.dart';
import '../repository/task_repository.dart';

class SelectTaskDialog extends StatelessWidget {
  final TaskRepository taskRepository;

  final FormGroup _formGroup = FormGroup({
    'task': FormControl<Task>(
      value: null,
      validators: [Validators.required],
    ),
  });

  SelectTaskDialog({required this.taskRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: const Text("Aufgabe auswählen"),
      content: _buildDialogContent(context),
      actions: _buildDialogActions(context),
    );
  }

  StreamBuilder<ControlStatus> _buildDialogContent(BuildContext context) {
    return StreamBuilder<ControlStatus>(
      stream: _formGroup.statusChanged,
      builder: (ctx, snapshot) => ReactiveForm(
        formGroup: _formGroup,
        child: _buildTasksDropdown(),
      ),
    );
  }

  StreamBuilder<List<Task>> _buildTasksDropdown() {
    return StreamBuilder<List<Task>>(
        stream: taskRepository.tasks$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          var data = snapshot.data!;
          if (data.isEmpty) {
            return FilledButton(
              onPressed: () async {
                var todo = await showDialog(
                  context: context,
                  builder: (ctx) => EditTaskDialog(),
                );
                if (todo != null) {
                  taskRepository.save(todo);
                }
              },
              child: const Text("Todo anlegen"),
            );
          }

          if (_formGroup.controls['task']?.value == null) {
            _formGroup.controls['task']?.patchValue(data.first);
          }
          return ReactiveDropdownField(
            decoration: const InputDecoration(labelText: 'Aufgabe'),
            formControlName: 'task',
            validationMessages: {
              'required': (f) => 'Dieses Feld ist erforderlich'
            },
            items: data
                .map((e) => DropdownMenuItem<Task>(
                      value: e,
                      child: Text(e.text),
                    ))
                .toList(),
          );
        });
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      TextButton(
        child: const Text('Abbrechen'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      FilledButton(
        child: const Text('Auswählen'),
        onPressed: () => _saveTask(context),
      ),
    ];
  }

  void _saveTask(BuildContext context) {
    if (_formGroup.invalid) {
      return;
    }
    Navigator.of(context).pop(_formGroup.value['task'] as Task);
  }
}
