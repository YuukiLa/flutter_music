package cc.yuuki.unknown

import io.flutter.embedding.android.FlutterActivity
import android.os.Build.VERSION
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec
import java.lang.Exception
import java.lang.StringBuilder
import java.math.BigInteger
import java.util.*
import javax.crypto.Cipher

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
                "neteaseRsaEnc" -> {
                    // 获取传入的参数
                    val text = call.argument<String>("text")
                    val pubKey = call.argument<String>("pubKey")
                    val modulus = call.argument<String>("modulus")
                    val result = rsaEncrypt(text,pubKey,modulus)
                    // 通知执行成功
                    res.success(result)
                }
                "neteaseAesEnc" -> {
                    // 获取传入的参数
                    val text = call.argument<String>("text")
                    val key = call.argument<String>("key")
                    val result = aesEncrypt(text,key)
                    // 通知执行成功
                    res.success(result)
                }

                else -> {
                    // 如果有未识别的方法名，通知执行失败
                    res.error("error_code", "error_message", null)
                }
            }
        }
    }
    private fun aesEncrypt(text: String?, key: String?): String {
        return try {
            val iv = IvParameterSpec("0102030405060708".toByteArray(charset("UTF-8")))
            val skeySpec = SecretKeySpec(key!!.toByteArray(charset("UTF-8")), "AES")
            val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
            cipher.init(Cipher.ENCRYPT_MODE, skeySpec, iv)
            val encrypted = cipher.doFinal(text!!.toByteArray())
            String(Base64.getEncoder().encode(encrypted))
        } catch (e: Exception) {
            ""
        }
    }
    private fun rsaEncrypt(text: String?, pubKey: String?, modulus: String?): String {
        var text = text
        text = StringBuilder(text).reverse().toString()
        val rs = BigInteger(String.format("%x", BigInteger(1, text.toByteArray())), 16)
            .modPow(BigInteger(pubKey, 16), BigInteger(modulus, 16))
        var r = rs.toString(16)
        return if (r.length >= 256) {
            r.substring(r.length - 256, r.length)
        } else {
            while (r.length < 256) {
                r = "0$r"
            }
            r
        }
    }
}
