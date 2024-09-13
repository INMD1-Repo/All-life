// MainActivity.kt
package com.deu.hackton.all_life_app;

import android.content.Intent
import android.os.Bundle
import com.deu.hackton.all_life.ARGPSFragment
import com.deu.hackton.all_life.MyFragmentActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.deu.hackton.all_life/native"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.dartExecutor?.binaryMessenger?.let {
            MethodChannel(it, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "startARGPS") {
                    // Start AR GPS Fragment activity
                    startActivity(Intent(this, ARGPSFragment::class.java))
                    result.success("AR GPS Started")
                } else {
                    result.notImplemented()
                }
            }
        }
    }
}
