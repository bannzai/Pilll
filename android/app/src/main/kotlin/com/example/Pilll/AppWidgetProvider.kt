import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class PilllAppWidgetProvider : AppWidgetProvider() {
    companion object {
        const val userIsPremiumOrTrial = "userIsPremiumOrTrial"

        const val pillSheetGroupTodayPillNumber = "pillSheetGroupTodayPillNumber"
        const val pillSheetTodayPillNumber = "pillSheetTodayPillNumber"
        const val pillSheetEndDisplayPillNumber = "pillSheetEndDisplayPillNumber"
        // Epoch milli second
        const val pillSheetLastTakenDate = "pillSheetLastTakenDate"
        // Epoch milli second
        const val pillSheetValueLastUpdateDateTime = "pillSheetValueLastUpdateDateTime"

        const val settingPillSheetAppearanceMode = "settingPillSheetAppearanceMode" // number or date or sequential

    }
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val preferences = it.getSharedPreferences("", Context.MODE_PRIVATE)
        val userIsPremiumOrTrial = preferences.getBoolean(userIsPremiumOrTrial, false)
        val pillSheetTodayPillNumber = preferences.getInt(pillSheetGroupTodayPillNumber, 0)

        if (!userIsPremiumOrTrial) {
            val views = RemoteViews(context.packageName, R.layout.sample_widget_layout).apply {
                var srcText = preferences.getString("_srcText", "")
                setTextViewText(R.id.srcText, srcText)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
            return
        }
    }

}