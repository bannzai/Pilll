package com.mizuki.Ohashi.Pilll

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import com.example.Pilll.Const
import org.threeten.bp.Instant
import org.threeten.bp.LocalDate
import org.threeten.bp.ZoneId
import org.threeten.bp.format.DateTimeFormatter
import java.lang.Integer.max

/**
 * Implementation of App Widget functionality.
 */
class PilllAppWidget : AppWidgetProvider() {
    override fun onReceive(context: Context?, intent: Intent?) {
        super.onReceive(context, intent)
    }
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        val sharedPreferences = context.getSharedPreferences(R.string.PREFERENCE_KEY.toString(), Context.MODE_PRIVATE)
        if (!sharedPreferences.getBoolean(Const.userIsPremiumOrTrial, false)) {
            val views = RemoteViews(context.packageName, R.layout.pilll_app_invalid_widget).apply {
                val pendingIntent: PendingIntent = PendingIntent.getActivity(
                    /* context = */ context,
                    /* requestCode = */  0,
                    /* intent = */ Intent(context, MainActivity::class.java),
                    /* flags = */ PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                setOnClickPendingIntent(R.id.widget_dummy_button, pendingIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
            return
        }
        val views = RemoteViews(context.packageName, R.layout.pilll_app_widget).apply {
            val pendingIntent: PendingIntent = PendingIntent.getActivity(
                /* context = */ context,
                /* requestCode = */  0,
                /* intent = */ Intent(context, MainActivity::class.java),
                /* flags = */ PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            setOnClickPendingIntent(R.id.widget_dummy_button, pendingIntent)
        }


        val now = LocalDate.now()
        val dayOfWeekName = now.format(DateTimeFormatter.ofPattern("EEEE"))
        views.setTextViewText(R.id.widget_weekday, dayOfWeekName)
        views.setTextViewText(R.id.widget_day, now.dayOfMonth.toString())
        views.setViewVisibility(R.id.widget_check_on, View.INVISIBLE)
        views.setViewVisibility(R.id.widget_status, View.GONE)

        var pillSheetValueLastUpdateDateEpochMilliSecond = sharedPreferences.getLong(Const.pillSheetValueLastUpdateDateTime, -1)
        Log.d("[DEBUG]", "pillSheetValueLastUpdateDateEpochMilliSecond: $pillSheetValueLastUpdateDateEpochMilliSecond")
        if (pillSheetValueLastUpdateDateEpochMilliSecond > 0) {
            val pillSheetValueLastUpdateDate = Instant.ofEpochMilli(pillSheetValueLastUpdateDateEpochMilliSecond).atZone(ZoneId.systemDefault()).toLocalDate()
            val settingPillSheetAppearanceMode =
                sharedPreferences.getString(Const.settingPillSheetAppearanceMode, "number")
            val todayPillNumberBase = if (settingPillSheetAppearanceMode == "sequential") {
                sharedPreferences.getInt(Const.pillSheetGroupTodayPillNumber, 0)
            } else {
                sharedPreferences.getInt(Const.pillSheetTodayPillNumber, 0)
            }
            Log.d("[DEBUG]", "todayPillNumberBase: $todayPillNumberBase")
            views.setTextViewText(R.id.widget_todayPillNumber, "1日目")
            if (todayPillNumberBase != 0) {
                val diff = now.dayOfMonth - pillSheetValueLastUpdateDate.dayOfMonth
                val todayPillNumber = todayPillNumberBase + max(0, diff)
                val pillSheetEndDisplayPillNumber = sharedPreferences.getInt(Const.pillSheetEndDisplayPillNumber, 0)
                Log.d("[DEBUG]", "pillSheetEndDisplayPillNumber: $pillSheetEndDisplayPillNumber, todayPillNumber: $todayPillNumber")
                if (pillSheetEndDisplayPillNumber in 1 until todayPillNumber) {
                    views.setTextViewText(R.id.widget_todayPillNumber, "1日目")
                } else {
                    views.setTextViewText(R.id.widget_todayPillNumber, "${todayPillNumber}日目")
                }
            }
        }

        val pillSheetLastTakenDateMilliSecond = sharedPreferences.getLong(Const.pillSheetLastTakenDate, -1)
        if (pillSheetLastTakenDateMilliSecond > 0) {
            val pillSheetLastTakenDate = Instant.ofEpochMilli(pillSheetLastTakenDateMilliSecond).atZone(ZoneId.systemDefault()).toLocalDate()
            if (now.isEqual(pillSheetLastTakenDate)) {
                views.setViewVisibility(R.id.widget_check_on, View.VISIBLE)
                views.setViewVisibility(R.id.widget_status, View.VISIBLE)
            }
        }

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}