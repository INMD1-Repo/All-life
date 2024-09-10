// MainActivity.kt
package com.deu.hackton.all_life_app;

import android.content.Intent
import com.deu.hackton.all_life.MyFragmentActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.deu.hackton.all_life/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startFragmentActivity" -> {
                    startFragmentActivity()
                    result.success("Fragment Activity started")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startFragmentActivity() {
        val intent = Intent(this, MyFragmentActivity::class.java)
        startActivity(intent)
    }
}
