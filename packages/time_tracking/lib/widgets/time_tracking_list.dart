import 'dart:async';

import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:flutter/material.dart';

import 'delete_time_tracking_entry_dialog.dart';
import 'select_task_dialog.dart';
import 'time_tracking_list_tile.dart';

@Service(lifetime: ServiceLifetime.transient)
class TimeTrackingList extends StatelessWidget {
  final TimeTrackingRepository _timeTrackingRepository;
  final ServiceProvider _serviceProvider;

  const TimeTrackingList({
    required TimeTrackingRepository timeTrackingRepository,
    required ServiceProvider serviceProvider,
    super.key,
  })  : _serviceProvider = serviceProvider,
        _timeTrackingRepository = timeTrackingRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<TimeTrackingEntry>>(
        stream: _timeTrackingRepository.entries$.asBroadcastStream(),
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
                      entry: e,
                      onStop: () => _onStop(e),
                      onDelete: () => _onDelete(context, e),
                      onContinue: () => _onContinueTimeTracking(e),
                    ))
                .toList(),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  void _onContinueTimeTracking(TimeTrackingEntry e) {
    return _timeTrackingRepository.startTimeTracking(
      Task(id: e.id, text: e.taskText),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () async {
        var entry = await selectTask(context);
        if (entry != null) {
          _timeTrackingRepository.startTimeTracking(Task(id: entry.key, text: entry.value));
        }
      },
    );
  }

  Future<MapEntry<int, String>?> selectTask(BuildContext context) {
    return showDialog<MapEntry<int, String>?>(
      context: context,
      builder: (ctx) => _serviceProvider.resolve<SelectTaskDialog>(),
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
