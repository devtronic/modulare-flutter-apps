import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';

@Service()
@Preload()
class HandlerRegistry {
  HandlerRegistry(
    EventDispatcher dispatcher,
    @Inject(tag: #eventSubscriber) List<Object> listeners,
  ) {
    for (var listener in listeners) {
      dispatcher.addHandler(listener, listener.runtimeType);
    }
  }
}
