import 'package:ctwebdev2023/service/modulith_route_generator.dart';
import 'package:ctwebdev2023_reporting/ctwebdev2023_reporting.dart';
import 'package:ctwebdev2023_tasks/ctwebdev2023_tasks.dart';
import 'package:ctwebdev2023_time_tracking/ctwebdev2023_time_tracking.dart';
import 'package:flutter/material.dart';

import 'navigation_outlet.dart';

void main() {
  var generator = _setupModulith();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: NavigationOutlet(routeGenerator: generator),
      onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return NavigationOutlet(
              routeName: settings.name,
              routeGenerator: generator,
            );
          },
          settings: settings,
        );
      },
    ),
  );
}

ModulithRouteGenerator _setupModulith() {
  final generator = ModulithRouteGenerator();
  final taskRepository = InMemoryTaskRepository();
  final timeTrackingRepository = InMemoryTimeTrackingRepository();

  bootstrapTimeTracking(generator, taskRepository, timeTrackingRepository);
  bootstrapTasks(generator, taskRepository, timeTrackingRepository);
  bootstrapReporting(generator, taskRepository, timeTrackingRepository);

  generator.assemble();
  return generator;
}
