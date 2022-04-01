package cc.yuuki.unknown

import io.flutter.embedding.android.FlutterActivity
import android.os.Build.VERSION
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    //设置状态栏沉浸式透明（修改flutter状态栏黑色半透明为全透明）
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.statusBarColor = 0
        }
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger

        // 新建一个 Channel 对象
        val channel = MethodChannel(messenger, "unknown/neteaseEnc")

        // 为 channel 设置回调
        channel.setMethodCallHandler { call, res ->
            // 根据方法名，分发不同的处理
            when(call.method) {

                "neteaseAesEnc" -> {
                    // 获取传入的参数
                    val msg = call.argument<String>("msg")

                    // 通知执行成功
                    res.success("这是执行的结果")
                }

                else -> {
                    // 如果有未识别的方法名，通知执行失败
                    res.error("error_code", "error_message", null)
                }
            }
        }
    }
}
