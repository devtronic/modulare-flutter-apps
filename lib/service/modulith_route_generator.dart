import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:ctwebdev2023_shared/ctwebdev2023_shared.dart';
import 'package:flutter/material.dart';

@Service(
  lifetime: ServiceLifetime.singleton,
  exposeAs: RouteRegistry
)
class ModulithRouteGenerator implements RouteRegistry {
  final List<NavigationRailDestination> _destinations = [];
  final List<String> _routes = [];
  final List<RoutingEntry> _entries = [];

  @override
  List<NavigationRailDestination> get destinations => _destinations.toList();

  @override
  List<RoutingEntry> get entries => _entries.toList();

  @override
  List<String> get routes => _routes.toList();

  @override
  void add(RoutingEntry entry) {
    _entries.add(entry);
  }

  void assemble() {
    _destinations.clear();
    _routes.clear();
    _entries.sort((a, b) => a.priority - b.priority);
    for (var entry in _entries) {
      _destinations.add(entry.destination);
      _routes.add(entry.route);
    }
  }

  RouteFactory buildRouteFactory(String? routeName) {
    return (RouteSettings settings) {
      WidgetBuilder builder = (ctx) {
        return const Center(child: Text('Missing Route'));
      };

      for (var entry in _entries) {
        if (entry.canActivate(settings, routeName)) {
          builder = entry.builder;
          break;
        }
      }

      return MaterialPageRoute<void>(
        builder: builder,
        settings: settings,
      );
    };
  }
}
