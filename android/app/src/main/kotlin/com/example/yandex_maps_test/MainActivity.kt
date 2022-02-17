package com.example.yandex_maps_test

import androidx.annotation.NonNull
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("3bc979ab-cda3-4289-a67c-6d8563cc51d1")
        super.configureFlutterEngine(flutterEngine)
    }
}
