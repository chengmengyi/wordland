import 'package:event_bus/event_bus.dart';

class EventUtils{
  static EventBus? _eventBus;

  static EventBus? getInstance() {
    _eventBus ??= EventBus();
    return _eventBus;
  }
}