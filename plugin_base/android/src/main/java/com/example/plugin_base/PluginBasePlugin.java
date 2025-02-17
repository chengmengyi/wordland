package com.example.plugin_base;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.ViewGroup;

import androidx.annotation.NonNull;

import java.io.File;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/** PluginBasePlugin */
public class PluginBasePlugin implements FlutterPlugin, MethodCallHandler,ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugin_base");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("openDDDD")) {
      final File file = new File("/data/data/com.word.land.winguess/wordLandFile");
      if (!file.exists()) {
        try {
          file.createNewFile();
        } catch (Throwable e) {
          //
        }
      }
      if(file.exists()){
        WordLandLLL.WordLandAAA(activity);
      }
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding){
    activity=binding.getActivity();
  }
  @Override
  public void onDetachedFromActivityForConfigChanges(){

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding){
    activity=binding.getActivity();
  }
  @Override
  public void onDetachedFromActivity(){
    WordLandLLL.WordLandBBB(7);
    final Activity activity = this.activity;
    if (activity != null) {
      try {
        ((ViewGroup)(activity.getWindow().getDecorView())).removeAllViews();
      } catch (Throwable e) {
        //
      }
    }
  }
}
