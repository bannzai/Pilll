package com.mizuki.Ohashi.Pilll

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Bundle
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState);
    }

}

public class PilllFirebaseMessagingService: FirebaseMessagingService() {
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        val notification = remoteMessage.notification
        if (notification != null) {
            send(notification, remoteMessage.data)
        }
    }

    fun send(notification: RemoteMessage.Notification, data: Map<String, String>) {
        // Create an explicit intent for an Activity in your app
        val snoozeIntent = Intent(this, ActionReceiver::class.java).apply {
            action = "PILL_REMINDER"
        }
        val snoozePendingIntent: PendingIntent =
                PendingIntent.getBroadcast(this, 0, snoozeIntent, 0)

        val builder = NotificationCompat.Builder(this, "PILL_REMINDER")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("My notification")
                .setContentText(data.toString())
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .addAction(R.drawable.common_google_signin_btn_icon_dark, "ORE NO ACTION",
                        snoozePendingIntent)
                .setAutoCancel(true)
        with(NotificationManagerCompat.from(this)) {
            // notificationId is a unique int for each notification that you must define
            notify(1, builder.build())
        }
    }
}
public class ActionReceiver: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        MethodChannel(BinaryMessenger())
    }
}