package com.mizuki.Ohashi.Pilll

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel


public class BroadCastActionReceiver: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("android message: ", "onReceive")
        if (context != null) {
            callRecordPill(context)
        }
    }
    private fun methodChannel(context: Context): MethodChannel {
        val flutterEngine = FlutterEngine(context)
        flutterEngine
                .dartExecutor
                .executeDartEntrypoint(
                        DartExecutor.DartEntrypoint.createDefault()
                )
        return MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "method.channel.MizukiOhashi.Pilll")
    }
    private fun callRecordPill(context: Context) {
        methodChannel(context).invokeMethod("recordPill", "")
        with(NotificationManagerCompat.from(context)) {
            cancel(PilllFirebaseMessagingService.pillReminderID)
        }
    }
}
