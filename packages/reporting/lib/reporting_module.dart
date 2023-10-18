import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:flutter/material.dart';

@Preload()
@Service()
class ReportingModule {
  ReportingModule(RouteRegistry registry) {
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
}
