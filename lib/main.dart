import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:flutter/material.dart';

import 'main.catalyst_builder.g.dart';
import 'navigation_outlet.dart';
import 'service/modulith_route_generator.dart';

/**
 * Export the catalyst_exports that the watch command can recompile the
 * ServiceProvider when the dependencies changes.
 */
export 'relative_deps_exports.dart';

@GenerateServiceProvider()
void main() {
  var serviceContainer = DefaultServiceProvider();

  serviceContainer.register<ServiceProvider>((p0) => serviceContainer);

  serviceContainer.boot();

  serviceContainer.resolve<ModulithRouteGenerator>().assemble();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: serviceContainer.resolve<NavigationOutlet>(),
      onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return serviceContainer.enhance(
              parameters: {'routeName': settings.name},
            ).resolve<NavigationOutlet>();
          },
          settings: settings,
        );
      },
    ),
  );
}
