package com.mizuki.Ohashi.Pilll

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import com.aboutyou.dart_packages.sign_in_with_apple.TAG
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch


public class BroadCastActionReceiver: BroadcastReceiver() {
    private val scope = CoroutineScope(SupervisorJob())

    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("android message: ", "onReceive")
        if (context != null && intent != null) {
            if (intent.action == "PILL_REMINDER") {
                val pendingResult: PendingResult = goAsync()
                val result = RecordPillResult(pendingResult)
                scope.launch(Dispatchers.Default) {
                    methodChannel(context).invokeMethod("recordPill", "", result)

                    // Remove notification badge
                    with(NotificationManagerCompat.from(context)) {
                        cancel(PilllFirebaseMessagingService.regularlyMessageID)
                    }
                }
            }
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

    private class RecordPillResult(private val pendingResult: PendingResult): MethodChannel.Result {
        override fun success(result: Any?) {
            Log.d(TAG, "successfully record pill $result")
            pendingResult.finish();
        }

        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
            Log.d(TAG, "errorCode: $errorCode, errorMessage: $errorMessage, errorDetails: $errorDetails")
            pendingResult.finish();
        }

        override fun notImplemented() {
            Log.d(TAG, "unexpected not implement method about record pill")
            pendingResult.finish();
        }

    }
}
