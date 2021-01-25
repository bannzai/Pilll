package com.mizuki.Ohashi.Pilll

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.mizuki.Ohashi.Pilll.R

public class PilllFirebaseMessagingService: FirebaseMessagingService() {
    companion object {
        val pillReminderID = 1
    }
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        Log.d("android message: ", "onMessageReceived")
        send(remoteMessage.data)
    }

    fun send( data: Map<String, String>) {
        Log.d("android message: ", "send")

        // Create an explicit intent for an Activity in your app
        val snoozeIntent = Intent(this, BroadCastActionReceiver::class.java).apply {
            action = "PILL_REMINDER"
        }
        val snoozePendingIntent: PendingIntent =
                PendingIntent.getBroadcast(this, 0, snoozeIntent, 0)

        val title = data["title"]
        val body = data["body"]
        val builder = NotificationCompat.Builder(this, "PILL_REMINDER")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(title)
                .setContentText(body)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .addAction(0, "飲んだ",
                        snoozePendingIntent
                )
        with(NotificationManagerCompat.from(this)) {
            // notificationId is a unique int for each notification that you must define
            notify(pillReminderID, builder.build())
        }
    }
}
