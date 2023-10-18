import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:flutter/material.dart';

import 'main.catalyst_builder.g.dart';
import 'main.event_dispatcher_builder.g.dart';
import 'navigation_outlet.dart';
import 'service/modulith_route_generator.dart';

/**
 * Export the catalyst_exports that the watch command can recompile the
 * ServiceProvider when the dependencies changes.
 */
export 'relative_deps_exports.dart';

@GenerateServiceProvider()
@GenerateEventDispatcher()
@ServiceMap(services: {
  // Register your event dispatcher inside the service container as a EventDispatcher
  DefaultEventDispatcher: Service(
    lifetime: ServiceLifetime.singleton,
    exposeAs: EventDispatcher,
  )
})
void main() {
  final serviceContainer = DefaultServiceProvider();

  serviceContainer.register<ServiceProvider>((p0) => serviceContainer);
  final navigatorKey = GlobalKey<NavigatorState>();
  serviceContainer.register<GlobalKey<NavigatorState>>((_) => navigatorKey);

  serviceContainer.boot();

  serviceContainer.resolve<ModulithRouteGenerator>().assemble();
  serviceContainer.resolve<EventDispatcher>();

  runApp(
    MaterialApp(
      navigatorKey: navigatorKey,
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
