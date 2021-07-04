package com.kibz;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.os.Bundle;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    // FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
    }

  //   @Override
  //   public void registerWith(PluginRegistry registry) {
  //   GeneratedPluginRegistrant.registerWith(registry);
  // }
}
