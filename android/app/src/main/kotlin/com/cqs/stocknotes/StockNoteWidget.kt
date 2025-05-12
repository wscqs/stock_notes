package com.cqs.stocknotes

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews


class StockNoteWidget : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_stock_note)

            views.setOnClickPendingIntent(R.id.widget_search, createDeepLinkPendingIntent(
                context, "stocknote://stocknote.com/#/tabs?tab=stock&op=search", 0))

            views.setOnClickPendingIntent(R.id.btn_quote, createDeepLinkPendingIntent(
                context, "stocknote://stocknote.com/#/tabs?tab=stock&op=saying", 1))

            views.setOnClickPendingIntent(R.id.btn_satisfy, createDeepLinkPendingIntent(
                context, "stocknote://stocknote.com/#/tabs?tab=stock&op=meetbs", 2))

            views.setOnClickPendingIntent(R.id.btn_near, createDeepLinkPendingIntent(
                context, "stocknote://stocknote.com/#/tabs?tab=stock&op=nearbs", 3))

            views.setOnClickPendingIntent(R.id.btn_new_stock, createDeepLinkPendingIntent(
                context, "stocknote://stocknote.com/#/stockedit", 4))

            views.setOnClickPendingIntent(R.id.btn_new_note, createDeepLinkPendingIntent(
                context, "stocknote://stocknote.com/#/noteedit", 5))

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun createDeepLinkPendingIntent(context: Context, uriString: String, requestCode: Int): PendingIntent {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(uriString)).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        return PendingIntent.getActivity(context, requestCode, intent, PendingIntent.FLAG_IMMUTABLE)
    }
}
