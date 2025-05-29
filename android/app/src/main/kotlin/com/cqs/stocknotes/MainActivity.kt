package com.cqs.stocknotes
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.InputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.stocknotes.channel/open_file"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "readContentUri" -> {
                    val uriStr = call.argument<String>("uri")
                    val uri = Uri.parse(uriStr!!)
                    try {
                        val inputStream: InputStream? = contentResolver.openInputStream(uri)
                        val bytes = inputStream?.readBytes()
                        result.success(bytes)
                    } catch (e: Exception) {
                        result.error("READ_ERROR", "无法读取 content uri", e.message)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
