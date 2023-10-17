import 'package:ctwebdev2023_tasks/ctwebdev2023_tasks.dart';
import 'package:ctwebdev2023_time_tracking/ctwebdev2023_time_tracking.dart';
import 'package:flutter/material.dart';

final _taskRepository = InMemoryTaskRepository();
final _timeTrackingRepository = InMemoryTimeTrackingRepository();

class NavigationOutlet extends StatefulWidget {
  final String? routeName;

  const NavigationOutlet({this.routeName, super.key});

  @override
  State<NavigationOutlet> createState() {
    return _NavigationOutletState();
  }
}

class _NavigationOutletState extends State<NavigationOutlet> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  int screenIndex = 0;

  static const _destinations = [
    NavigationRailDestination(
      label: Text('Aufgaben'),
      icon: Icon(Icons.task_alt_outlined),
      selectedIcon: Icon(Icons.task_alt),
    ),
    NavigationRailDestination(
      label: Text('Zeiterfassung'),
      icon: Icon(Icons.timer_outlined),
      selectedIcon: Icon(Icons.timer),
    ),
    NavigationRailDestination(
      label: Text('Auswertung'),
      icon: Icon(Icons.assessment_outlined),
      selectedIcon: Icon(Icons.assessment),
    ),
  ];

  static const _routes = ['tasks', 'time-tracking', 'reporting'];

  @override
  void initState() {
    super.initState();
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
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder = (ctx) {
            return const Center(child: Text('Missing Route'));
          };

          if (widget.routeName == null || widget.routeName == 'tasks') {
            builder = (ctx) => TasksList(
                  taskRepository: _taskRepository,
                  timeTrackingRepository: _timeTrackingRepository,
                );
          } else if (widget.routeName == 'time-tracking') {
            builder = (ctx) => TimeTrackingList(
                  timeTrackingRepository: _timeTrackingRepository,
                  taskRepository: _taskRepository,
                );
          }
          return MaterialPageRoute<void>(
            builder: builder,
            settings: settings,
          );
        },
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
