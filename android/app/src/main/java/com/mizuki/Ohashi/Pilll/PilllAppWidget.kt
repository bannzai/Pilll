package com.mizuki.Ohashi.Pilll

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.view.View
import android.widget.RemoteViews
import org.threeten.bp.LocalDate
import java.text.SimpleDateFormat
import java.util.Calendar

/**
 * Implementation of App Widget functionality.
 */
class PilllAppWidget : AppWidgetProvider() {
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
}

internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
    val views = RemoteViews(context.packageName, R.layout.pilll_app_widget)

    val now = LocalDate.now()

    val format = SimpleDateFormat("EEEE");
    val dayOfWeekName = format.format(now)
    views.setTextViewText(R.id.widget_weekday, dayOfWeekName)

    val day = now.dayOfMonth
    views.setTextViewText(R.id.widget_day, day.toString())

    // TODO:
    views.setViewVisibility(R.id.widget_check_on, View.INVISIBLE)

    // TODO:
    views.setTextViewText(R.id.widget_todayPillNumber, "10番")

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}