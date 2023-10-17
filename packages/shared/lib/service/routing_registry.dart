import 'package:flutter/material.dart';

import 'routing_entry.dart';

abstract class RouteRegistry {
  List<NavigationRailDestination> get destinations;

  List<String> get routes;

  List<RoutingEntry> get entries;

  void add(RoutingEntry entry);
}
