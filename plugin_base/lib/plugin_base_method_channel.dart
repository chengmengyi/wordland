import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plugin_base/plugin_base_platform_interface.dart';

/// An implementation of [FlutterMaxAdPlatform] that uses method channels.
class MethodChannelPluginBase extends PluginBasePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('plugin_base');
  @override
  Future<void> openDDDD() async{
    await methodChannel.invokeMethod("openDDDD");
  }
}
