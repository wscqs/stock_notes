package com.cqs.stocknotes
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.InputStream
import java.net.URLEncoder

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.stocknotes.channel/open_file"

    override fun onCreate(savedInstanceState: Bundle?) {
        // 系统分享(ACTION_SEND)的文件在 EXTRA_STREAM 里，app_links 只认 VIEW 的 data，
        // 统一改写成 ACTION_VIEW，交给 app_links 走原有导入流程
        intent = normalizeShareIntent(intent)
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(normalizeShareIntent(intent) ?: intent)
    }

    private fun normalizeShareIntent(intent: Intent?): Intent? {
        if (intent?.action != Intent.ACTION_SEND) return intent
        // 分享文件：EXTRA_STREAM 里的 content URI 直接作为 VIEW 的 data
        val uri: Uri? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(Intent.EXTRA_STREAM)
        }
        if (uri != null) {
            return Intent(Intent.ACTION_VIEW, uri)
                .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        // 分享文本：编码进自定义 URI，Dart 端识别其中的股票后直达详情页
        val text = intent.getStringExtra(Intent.EXTRA_TEXT)
        if (!text.isNullOrEmpty()) {
            val shareUri = Uri.parse(
                "stocknote://stocknote.com/#/sharetext?text=" +
                    URLEncoder.encode(text, "UTF-8")
            )
            return Intent(Intent.ACTION_VIEW, shareUri)
        }
        return intent
    }

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
                        // 新版微信/QQ 的 content URI 可能不带文件名，查询真实文件名一并返回
                        var displayName: String? = null
                        contentResolver.query(uri, null, null, null, null)?.use { cursor ->
                            val idx = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                            if (idx >= 0 && cursor.moveToFirst()) {
                                displayName = cursor.getString(idx)
                            }
                        }
                        result.success(mapOf("bytes" to bytes, "name" to displayName))
                    } catch (e: Exception) {
                        result.error("READ_ERROR", "无法读取 content uri", e.message)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
