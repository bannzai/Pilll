package com.mizuki.Ohashi.Pilll

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

const val CHANNEL = "method.channel.MizukiOhashi.Pilll"

fun methodChannel(context: Context): MethodChannel {
    val flutterEngine = FlutterEngine(context)
    flutterEngine
        .dartExecutor
        .executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
    return MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
}
