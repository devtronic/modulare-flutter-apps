import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../dto/task.dart';

class EditTaskDialog extends StatelessWidget {
  late final Task _task;

  final FormGroup _formGroup = FormGroup({
    'text': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
  });

  EditTaskDialog({Task? task, super.key}) {
    _task = task ?? Task(text: '');
    _formGroup.patchValue({'text': _task.text});
  }

  @override
  Widget build(BuildContext context) {
    var title = _task.id == 0
        ? const Text("Aufgabe hinzufügen")
        : const Text("Aufgabe bearbeiten");
    return AlertDialog(
      alignment: Alignment.center,
      title: title,
      content: _buildDialogContent(context),
      actions: _buildDialogActions(context),
    );
  }

  StreamBuilder<ControlStatus> _buildDialogContent(BuildContext context) {
    return StreamBuilder<ControlStatus>(
      stream: _formGroup.statusChanged,
      builder: (ctx, snapshot) => ReactiveForm(
        formGroup: _formGroup,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReactiveTextField(
              decoration: const InputDecoration(labelText: 'Name'),
              formControlName: 'text',
              validationMessages: {
                'required': (f) => 'Dieses Feld ist erforderlich'
              },
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      TextButton(
        child: const Text('Abbrechen'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      FilledButton(
        child: const Text('Speichern'),
        onPressed: () => _saveTask(context),
      ),
    ];
  }

  void _saveTask(BuildContext context) {
    if (_formGroup.invalid) {
      return;
    }
    _task.text = _formGroup.value['text'] as String;
    Navigator.of(context).pop(_task);
  }
}
