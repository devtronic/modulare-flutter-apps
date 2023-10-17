library ctwebdev2023_reporting;

import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:flutter/material.dart';

void bootstrapReporting(
  RouteRegistry registry,
  TaskRepository taskRepository,
  TimeTrackingRepository timeTrackingRepository,
) {
  registry.add(
    RoutingEntry(
      priority: 3,
      route: 'reporting',
      destination: const NavigationRailDestination(
        label: Text('Auswertung'),
        icon: Icon(Icons.assessment_outlined),
        selectedIcon: Icon(Icons.assessment),
      ),
      canActivate: (_, __) => false,
      builder: (_) => Container(),
    ),
  );
}
