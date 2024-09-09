package com.lucasalves.playerhub

import android.os.Build
import android.os.Bundle
import android.view.Gravity
import android.graphics.drawable.GradientDrawable
import android.text.TextUtils
import android.widget.TextView
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.core.view.WindowCompat
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private val BASE_CHANNEL = "com.lucasalves.playerhub"
    private val ChannelToast = "$BASE_CHANNEL/toast"

    override fun onCreate(savedInstanceState: Bundle?) {
        WindowCompat.setDecorFitsSystemWindows(window, false)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
        }

        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ChannelToast).setMethodCallHandler { call, result ->
            if (call.method == "showToast") {
                val message = call.argument<String>("message")
                val darkMode = call.argument<Boolean>("darkMode") ?: false

                if (message != null) {
                    showToast(message, darkMode)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "Message is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun showToast(message: String, darkMode: Boolean) {
        val toast = Toast(this)
        toast.duration = Toast.LENGTH_SHORT
        toast.setGravity(Gravity.BOTTOM or Gravity.CENTER_HORIZONTAL, 0, 100)

        val textView = TextView(this).apply {
            text = message
            textSize = 14f
            setTextColor(
                ContextCompat.getColor(
                    this@MainActivity,
                    if (darkMode) android.R.color.black else android.R.color.white
                )
            )
            setPadding(20, 10, 20, 10)
            maxLines = 1
            ellipsize = TextUtils.TruncateAt.END
        }

        val background = GradientDrawable().apply {
            setColor(
                ContextCompat.getColor(
                    this@MainActivity,
                    if (darkMode) android.R.color.white else android.R.color.black
                )
            )
            cornerRadius = 22f
        }

        textView.background = background
        toast.view = textView
        toast.show()
    }
}
