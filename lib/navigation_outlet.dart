import 'package:ctwebdev2023/service/modulith_route_generator.dart';
import 'package:flutter/material.dart';

class NavigationOutlet extends StatefulWidget {
  final String? routeName;

  final ModulithRouteGenerator routeGenerator;

  const NavigationOutlet({
    this.routeName,
    super.key,
    required this.routeGenerator,
  });

  @override
  State<NavigationOutlet> createState() {
    return _NavigationOutletState();
  }
}

class _NavigationOutletState extends State<NavigationOutlet> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  int screenIndex = 0;

  final List<NavigationRailDestination> _destinations = [];

  final List<String> _routes = [];

  @override
  void initState() {
    super.initState();
    _routes
      ..clear()
      ..addAll(widget.routeGenerator.routes);
    _destinations
      ..clear()
      ..addAll(widget.routeGenerator.destinations);
    screenIndex = _routes.indexOf(widget.routeName ?? _routes[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        top: false,
        child: Row(
          children: <Widget>[
            _buildNavigation(context),
            const VerticalDivider(thickness: 1, width: 1),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Expanded _buildContent() {
    return Expanded(
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: widget.routeGenerator.buildRouteFactory(widget.routeName),
      ),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: NavigationRail(
        labelType: NavigationRailLabelType.all,
        destinations: _destinations,
        selectedIndex: screenIndex,
        useIndicator: true,
        onDestinationSelected: (int index) {
          Navigator.of(context).pushReplacementNamed(_routes[index]);
        },
      ),
    );
  }
}
