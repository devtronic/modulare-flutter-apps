import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:flutter/material.dart';

import 'widgets/time_tracking_list.dart';

@Preload()
@Service()
class TimeTrackingModule {
  TimeTrackingModule(
    RouteRegistry registry,
    TaskRepository taskRepository,
    TimeTrackingRepository timeTrackingRepository,
  ) {
    registry.add(
      RoutingEntry(
        priority: 2,
        route: 'time-tracking',
        destination: const NavigationRailDestination(
          label: Text('Zeiterfassung'),
          icon: Icon(Icons.timer_outlined),
          selectedIcon: Icon(Icons.timer),
        ),
        canActivate: (_, route) => route == 'time-tracking',
        builder: (ctx) => TimeTrackingList(
          timeTrackingRepository: timeTrackingRepository,
          taskRepository: taskRepository,
        ),
      ),
    );
  }
}
