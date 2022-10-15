package com.mizuki.Ohashi.Pilll

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import com.example.Pilll.Const
import org.threeten.bp.LocalDate
import org.threeten.bp.format.DateTimeFormatter
import java.lang.Integer.max
import java.text.SimpleDateFormat

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

//        if (sharedPreferences.getBoolean(userIsPremiumOrTrial, true)) {
//            val views = RemoteViews(context.packageName, R.layout.pilll_app_widget)
//            return
//        }
//
        val views = RemoteViews(context.packageName, R.layout.pilll_app_widget)
        val now = LocalDate.now()


        val dayOfWeekName = now.format(DateTimeFormatter.ofPattern("EEEE"))
        views.setTextViewText(R.id.widget_weekday, dayOfWeekName)
        views.setTextViewText(R.id.widget_day, now.dayOfMonth.toString())
        views.setViewVisibility(R.id.widget_check_on, View.INVISIBLE)

        var pillSheetValueLastUpdateDateEpochMilliSecond = sharedPreferences.getLong(Const.pillSheetValueLastUpdateDateTime, -1)
        Log.d("[DEBUG]", "pillSheetValueLastUpdateDateEpochMilliSecond: $pillSheetValueLastUpdateDateEpochMilliSecond")
        if (pillSheetValueLastUpdateDateEpochMilliSecond > 0) {
            val pillSheetValueLastUpdateDate = LocalDate.ofEpochDay(pillSheetValueLastUpdateDateEpochMilliSecond)
            val settingPillSheetAppearanceMode =
                sharedPreferences.getString(Const.settingPillSheetAppearanceMode, "number")
            val todayPillNumberBase = if (settingPillSheetAppearanceMode == "sequential") {
                sharedPreferences.getInt(Const.pillSheetGroupTodayPillNumber, 0)
            } else {
                sharedPreferences.getInt(Const.pillSheetTodayPillNumber, 0)
            }
            Log.d("[DEBUG]", "todayPillNumberBase: $todayPillNumberBase")
            if (todayPillNumberBase != 0) {
                val diff = now.dayOfMonth - pillSheetValueLastUpdateDate.dayOfMonth
                val todayPillNumber = todayPillNumberBase + max(0, diff)
                val pillSheetEndDisplayPillNumber = sharedPreferences.getInt(Const.pillSheetEndDisplayPillNumber, 0)
                if (todayPillNumber > pillSheetEndDisplayPillNumber) {
                    views.setTextViewText(R.id.widget_todayPillNumber, "1")
                } else {
                    views.setTextViewText(R.id.widget_todayPillNumber, "$todayPillNumber")
                }
            }
        }

        val pillSheetLastTakenDateMilliSecond = sharedPreferences.getLong(Const.pillSheetLastTakenDate, -1)
        if (pillSheetLastTakenDateMilliSecond > 0) {
            val pillSheetValueLastUpdateDate = LocalDate.ofEpochDay(pillSheetValueLastUpdateDateEpochMilliSecond)
            if (now.isEqual(pillSheetValueLastUpdateDate)) {
                views.setViewVisibility(R.id.widget_check_on, View.VISIBLE)
            }
        }

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}