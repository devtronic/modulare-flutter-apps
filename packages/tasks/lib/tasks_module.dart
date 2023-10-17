import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:flutter/material.dart';

import 'widgets/tasks_list.dart';

@Preload()
@Service()
class TasksModule {
  TasksModule(
      RouteRegistry registry,
      TaskRepository taskRepository,
      TimeTrackingRepository timeTrackingRepository,
      ) {
    registry.add(
      RoutingEntry(
        priority: 1,
        route: 'tasks',
        destination: const NavigationRailDestination(
          label: Text('Aufgaben'),
          icon: Icon(Icons.task_alt_outlined),
          selectedIcon: Icon(Icons.task_alt),
        ),
        canActivate: (_, route) => route == null || route == 'tasks',
        builder: (ctx) => TasksList(
          taskRepository: taskRepository,
          timeTrackingRepository: timeTrackingRepository,
        ),
      ),
    );
  }
}
