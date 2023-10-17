import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:flutter/material.dart';

class DeleteTaskDialog extends StatelessWidget {
  final Task task;

  const DeleteTaskDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Aufgabe löschen'),
      content: Text('Möchtest du die Aufgabe ${task.text} wirklich löschen?'),
      actions: [
        TextButton(
          child: const Text('Abbrechen'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FilledButton.tonal(
          style: FilledButton.styleFrom(foregroundColor: Colors.redAccent),
          child: const Text('Löschen'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        )
      ],
    );
  }
}
