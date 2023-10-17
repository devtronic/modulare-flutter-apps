import 'package:flutter/material.dart';

class DeleteTimeTrackingEntryDialog extends StatelessWidget {
  const DeleteTimeTrackingEntryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eintrag löschen'),
      content: const Text('Möchtest du den Eintrag wirklich löschen?'),
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
