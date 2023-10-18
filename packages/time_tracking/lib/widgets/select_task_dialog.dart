import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:ctwebdev2023_time_tracking/service/task_meta_storage.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

@Service(lifetime: ServiceLifetime.transient)
class SelectTaskDialog extends StatelessWidget {
  final TaskMetaStorage _taskMetaStorage;
  final EventDispatcher _eventDispatcher;

  final FormGroup _formGroup = FormGroup({
    'taskId': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
  });

  SelectTaskDialog({
    required TaskMetaStorage taskMetaStorage,
    required EventDispatcher eventDispatcher,
    super.key,
  })  : _eventDispatcher = eventDispatcher,
        _taskMetaStorage = taskMetaStorage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: const Text('Aufgabe auswählen'),
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

  Widget _buildTasksDropdown() {
    return StreamBuilder<Map<int, String>>(
        stream: _taskMetaStorage.taskTextsById$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          var data = snapshot.data!;
          if (data.isEmpty) {
            return FilledButton(
              onPressed: () => _eventDispatcher.dispatch(CreateTaskEvent()),
              child: const Text('Todo anlegen'),
            );
          }

          if (_formGroup.controls['taskId']?.value == null) {
            _formGroup.controls['taskId']?.patchValue(data.entries.first.key);
          }
          return ReactiveDropdownField(
            decoration: const InputDecoration(labelText: 'Aufgabe'),
            formControlName: 'taskId',
            validationMessages: {
              'required': (f) => 'Dieses Feld ist erforderlich'
            },
            items: data.entries
                .map((e) => DropdownMenuItem<int>(
                      value: e.key,
                      child: Text(e.value),
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
    Navigator.of(context).pop(
        _taskMetaStorage.getEntryForId(_formGroup.value['taskId'] as int?));
  }
}
