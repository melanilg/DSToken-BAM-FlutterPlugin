package com.develsystems.DSTokenBam

import android.os.Build
import androidx.annotation.NonNull
import com.develsystems.DSTokenBam.otp.SeedConvertor

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.UnsupportedEncodingException
import android.content.Context
import com.develsystems.smartid.SmartId

/** DSTokenBamPlugin */
class DSTokenBamPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var smartIdChannel: MethodChannel
  private var appContext: Context? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.appContext = flutterPluginBinding.applicationContext;
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "DSTokenBam")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${Build.VERSION.RELEASE}")
      }

      "getSeedDecrypt" -> {
        val resultResponse: String? = call.argument("seed")
        val seed = getSeed(result = resultResponse!!)
        result.success(seed)
      }

      "getSmartId" -> {
        getSmartId(call, result)
      }

      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    smartIdChannel.setMethodCallHandler(null)
  }

  /**
   * @param result The Base64 encoded String that is returned by the server
   */

  private fun getSeed(result: String): String {
    val split = result.split(",".toRegex()).dropLastWhile({ it.isEmpty() }).toTypedArray()
    var seed: String? = split[0]

    val base64 = SeedConvertor.ConvertFromEncodingToBA(seed, SeedConvertor.BASE64_FORMAT)
    val str = String(base64!!, Charsets.UTF_8)
    var hex = SeedConvertor.ConvertFromBA(base64, SeedConvertor.HEX_FORMAT)
    val hex_b32_chk = hex!!.substring(0, 2)
    val hex_chk = hex.substring(hex.length - 2)
    hex = hex.substring(0, hex.length - 2).substring(2)
    if (calculateChecksum(hex).equals(hex_chk, ignoreCase = true)) {
      val base642 = SeedConvertor.ConvertFromEncodingToBA(hex, SeedConvertor.HEX_FORMAT)
      val str2 = String(base642!!, Charsets.UTF_8)
      val b32 = SeedConvertor.ConvertFromBA(base642, SeedConvertor.BASE32_FORMAT)
      val b32bytes = SeedConvertor.ConvertFromEncodingToBA(b32, SeedConvertor.BASE32_FORMAT)
      val b32_str = String(b32bytes!!, Charsets.UTF_8)

      if (calculateChecksum(b32_str).equals(hex_b32_chk, ignoreCase = true) || calculateChecksum(b32).equals(hex_b32_chk, ignoreCase = true)) {
        seed = b32
      } else {
        seed = b32_str
      }
    }
    return seed!!
  }

  private fun calculateChecksum(dataToCalculate: String): String {
    var dataToCalculate = dataToCalculate
    dataToCalculate = dataToCalculate.toUpperCase()
    val byteToCalculateAscii: ByteArray
    var checksum = 0
    try {
      byteToCalculateAscii = dataToCalculate.toByteArray(charset("ASCII"))

      for (chData in byteToCalculateAscii) {
        checksum += chData.toInt()
      }
      checksum = checksum and 0xff

    } catch (e: UnsupportedEncodingException) {
      e.printStackTrace()
    }

    return Integer.toHexString(checksum)
  }

  fun getSmartId(call: MethodCall, result: Result) {
    SmartId.getInstance()
      .GetSmartId(appContext!!)
      .onDataReceived { smartId ->
        result.success(smartId)
      }
      .start()
  }
}
