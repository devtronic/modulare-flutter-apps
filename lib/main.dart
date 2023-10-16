import 'package:flutter/material.dart';

import 'navigation_outlet.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const NavigationOutlet(),
      onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return NavigationOutlet(routeName: settings.name);
          },
          settings: settings,
        );
      },
    ),
  );
}
