import 'package:flutter/material.dart';

class RoutingEntry {
  final int priority;
  final NavigationRailDestination destination;
  final String route;
  final bool Function(RouteSettings settings, String? route) canActivate;
  final WidgetBuilder builder;

  RoutingEntry({
    required this.priority,
    required this.destination,
    required this.route,
    required this.canActivate,
    required this.builder,
  });
}
