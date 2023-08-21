package com.mizuki.Ohashi.Pilll

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import io.flutter.plugin.common.MethodChannel


public class BroadCastActionReceiver: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("android message: ", "onReceive")
        if (context != null && intent != null) {
            if (intent.action == "PILL_REMINDER") {
                val pendingResult: PendingResult = goAsync()
                val result = RecordPillResult(pendingResult)
                methodChannel(context).invokeMethod("recordPill", "", result)

                // Remove notification from tray and remove notification badge
                with(NotificationManagerCompat.from(context)) {
                    cancel(PilllFirebaseMessagingService.regularlyMessageID)
                }
            }
        }
    }

    private class RecordPillResult(private val pendingResult: PendingResult): MethodChannel.Result {
        override fun success(result: Any?) {
            pendingResult.finish();
        }

        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
            pendingResult.finish();
        }

        override fun notImplemented() {
            pendingResult.finish();
        }

    }
}
