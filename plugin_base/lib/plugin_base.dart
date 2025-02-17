import 'package:plugin_base/plugin_base_platform_interface.dart';

class PluginBase{
  static final PluginBase _instance = PluginBase();

  static PluginBase get instance => _instance;


  openDDDD(){
    PluginBasePlatform.instance.openDDDD();
  }
}