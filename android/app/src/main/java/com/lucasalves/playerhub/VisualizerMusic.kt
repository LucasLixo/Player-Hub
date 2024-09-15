package com.lucasalves.playerhub

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import java.io.File

import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class VisualizerMusic : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
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

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    // Construct the RemoteViews object
    val widgetData = HomeWidgetPlugin.getData(context)
    val views = RemoteViews(context.packageName, R.layout.visualizer_music).apply {

        var title = widgetData.getString("headline_title", null)
        setTextViewText(R.id.headline_title, title ?: "Music")

        var subtitle = widgetData.getString("headline_subtitle", null)
        setTextViewText(R.id.headline_subtitle, subtitle ?: "Artist")

        var image = widgetData.getString("headline_image", null)
        val imageFile = File(image)
        if (imageFile.exists()) {
            val imageBitmap: Bitmap = BitmapFactory.decodeFile(imageFile.absolutePath)
            setImageViewBitmap(R.id.headline_image, imageBitmap)
        }
    }

    appWidgetManager.updateAppWidget(appWidgetId, views)
}