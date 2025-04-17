package com.mizuki.Ohashi.Pilll

import android.app.NotificationChannel
import android.app.NotificationManager
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import com.mizuki.Ohashi.Pilll.Const
import com.jakewharton.threetenabp.AndroidThreeTen
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("android message: ", "onCreate")
        AndroidThreeTen.init(this);
    }

    override fun onStart() {
        super.onStart()
        Log.d("android message: ", "onStart")
        createNotificationChannel()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
//                "methodName" -> {
//                    val sharedPreferences = getSharedPreferences(R.string.PREFERENCE_KEY.toString(), Context.MODE_PRIVATE).edit()
//                    sharedPreferences.putBoolean(Const.userIsPremiumOrTrial, call.argument<Boolean>(Const.userIsPremiumOrTrial) ?: false).apply()
//                    updateWidget()
//                    result.success(mapOf("result" to "success"))
//                }
                else -> {}
            }
        }
    }

    private fun createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            kotlin.run {
                // Remove OLD channel
                notificationManager.deleteNotificationChannel("PILL_REMINDER")
            }
            kotlin.run {
                // Define channel
                val reminderNotificationChannel = NotificationChannel(getString(R.string.reminder_channel_id), getString(R.string.reminder_channel_name), NotificationManager.IMPORTANCE_DEFAULT).apply {
                    description = getString(R.string.reminder_channel_description)
                }
                notificationManager.createNotificationChannel(reminderNotificationChannel)
            }
        }
    }
}