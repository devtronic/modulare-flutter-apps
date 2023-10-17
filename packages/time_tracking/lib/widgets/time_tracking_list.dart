import 'dart:async';

import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:ctwebdev2023_time_tracking/widgets/select_task_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../dto/time_tracking_list_entry.dart';
import 'delete_time_tracking_entry_dialog.dart';
import 'time_tracking_list_tile.dart';

class TimeTrackingList extends StatelessWidget {
  final TimeTrackingRepository _timeTrackingRepository;
  final TaskRepository _taskRepository;

  const TimeTrackingList({
    required TimeTrackingRepository timeTrackingRepository,
    required TaskRepository taskRepository,
    super.key,
  })  : _timeTrackingRepository = timeTrackingRepository,
        _taskRepository = taskRepository;

  @override
  Widget build(BuildContext context) {
    var entries$ = CombineLatestStream(
      [
        _timeTrackingRepository.entries$.asBroadcastStream(),
        _taskRepository.tasks$.asBroadcastStream()
      ],
      (values) {
        var entries = values[0].toList() as List<TimeTrackingEntry>;
        var tasks = values[1] as List<Task>;
        entries.sort((a, b) => a.startedAt.isAfter(b.startedAt) ? -1 : 1);
        return entries
            .map(
              (e) => TimeTrackingListEntry(
                entry: e,
                task: tasks.where((t) => t.id == e.taskId).firstOrNull,
              ),
            )
            .toList();
      },
    );
    return Scaffold(
      body: StreamBuilder<List<TimeTrackingListEntry>>(
        stream: entries$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(child: Text('Noch keine Einträge vorhanden'));
          }
          return ListView(
            children: data
                .map((e) => TimeTrackingListTile(
                      listEntry: e,
                      onStop: () => _onStop(e.entry),
                      onDelete: () => _onDelete(context, e.entry),
                      onContinue: e.task != null
                          ? () =>
                              _timeTrackingRepository.startTimeTracking(e.task!)
                          : null,
                    ))
                .toList(),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () async {
        var task = await selectTask(context);
        if (task != null) {
          _timeTrackingRepository.startTimeTracking(task);
        }
      },
    );
  }

  Future<Task?> selectTask(BuildContext context) {
    return showDialog<Task>(
      context: context,
      builder: (ctx) => SelectTaskDialog(
        taskRepository: _taskRepository,
      ),
    );
  }

  void _onStop(TimeTrackingEntry entry) {
    _timeTrackingRepository.stopTimeTracking(entry);
  }

  Future<void> _onDelete(BuildContext context, TimeTrackingEntry entry) async {
    if (await _confirmDelete(context)) {
      _timeTrackingRepository.delete(entry);
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const DeleteTimeTrackingEntryDialog(),
    );
    return result ?? false;
  }
}
