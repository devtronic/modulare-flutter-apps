import 'dart:async';

import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:flutter/material.dart';

class TimeTrackingListTile extends StatelessWidget {
  final TimeTrackingEntry entry;
  final Function() onStop;
  final Function()? onContinue;
  final Function()? onDelete;

  const TimeTrackingListTile({
    super.key,
    required this.entry,
    required this.onStop,
    required this.onContinue,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(entry.taskText),
      subtitle: _buildSubtitle(entry),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (entry.endedAt == null)
            IconButton(
              onPressed: onStop,
              icon: const Icon(Icons.stop),
            ),
          if (entry.endedAt != null && onContinue != null)
            IconButton(
              onPressed: onContinue,
              icon: const Icon(Icons.play_arrow),
            ),
          if (entry.endedAt != null)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(TimeTrackingEntry entry) {
    if (entry.endedAt == null) {
      return StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Text(_formatEntryTime(
              entry.startedAt,
              DateTime.now(),
              includeEnd: false,
            ));
          });
    }

    return Text(_formatEntryTime(entry.startedAt, entry.endedAt!));
  }

  String _formatEntryTime(DateTime start, DateTime end,
      {bool includeEnd = true}) {
    var startedAt = start.format('d.M.y kk:mm:ss');

    var endFormat = start.isSameDay(end) ? 'kk:mm:ss' : 'd.M.y kk:mm:ss';
    var endedAt = end.format(endFormat);

    var duration = end.difference(start);
    var durationString = duration.asHumanReadable();

    return includeEnd
        ? '$startedAt - $endedAt ($durationString)'
        : '$startedAt ($durationString)';
  }
}
