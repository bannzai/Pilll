package com.mizuki.Ohashi.Pilll

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.util.Log
import com.example.Pilll.Const
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("android message: ", "onCreate")
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
                "syncUserStatus" -> {
                    val sharedPreferences = getSharedPreferences(R.string.PREFERENCE_KEY.toString(), Context.MODE_PRIVATE).edit()
                    sharedPreferences.putBoolean(Const.userIsPremiumOrTrial, call.argument<Boolean>(Const.userIsPremiumOrTrial) ?: false).apply()
                }
                "syncSetting" -> {
                    val sharedPreferences = getSharedPreferences(R.string.PREFERENCE_KEY.toString(), Context.MODE_PRIVATE).edit()
                    sharedPreferences.putString(Const.settingPillSheetAppearanceMode, call.argument<String>(Const.settingPillSheetAppearanceMode)).apply()
                }
                "syncActivePillSheetValue" -> {
                    val sharedPreferences = getSharedPreferences(R.string.PREFERENCE_KEY.toString(), Context.MODE_PRIVATE).edit()
                    sharedPreferences.putLong(Const.pillSheetValueLastUpdateDateTime, call.argument<Long>(Const.pillSheetValueLastUpdateDateTime) ?: 0).apply()
                    sharedPreferences.putLong(Const.pillSheetLastTakenDate, call.argument<Long>(Const.pillSheetLastTakenDate) ?: 0).apply()
                    sharedPreferences.putInt(Const.pillSheetGroupTodayPillNumber, call.argument<Int>(Const.pillSheetGroupTodayPillNumber) ?: 0).apply()
                    sharedPreferences.putInt(Const.pillSheetTodayPillNumber, call.argument<Int>(Const.pillSheetTodayPillNumber) ?: 0).apply()
                    sharedPreferences.putInt(Const.pillSheetEndDisplayPillNumber, call.argument<Int>(Const.pillSheetEndDisplayPillNumber) ?: 0).apply()
                }
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