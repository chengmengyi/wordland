import 'package:plugin_base/plugin_base_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';


abstract class PluginBasePlatform extends PlatformInterface {
  /// Constructs a FlutterMaxAdPlatform.
  PluginBasePlatform() : super(token: _token);

  static final Object _token = Object();

  static PluginBasePlatform _instance = MethodChannelPluginBase();

  /// The default instance of [FlutterMaxAdPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMaxAd].
  static PluginBasePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMaxAdPlatform] when
  /// they register themselves.
  static set instance(PluginBasePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
  Future<void> openDDDD()=>_instance.openDDDD();

}
