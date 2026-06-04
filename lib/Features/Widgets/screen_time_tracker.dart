// <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" tools:ignore="ProtectedPermissions" />
// import 'package:flutter/material.dart';import 'package:app_settings/app_settings.dart';

// Call this function to send the user to the correct Settings page
// void openUsageSettings() {
//   AppSettings.openAppSettings(type: SettingType.device); 
//   // Note: Some packages or custom MethodChannels allow opening SettingType.usageAccess directly
// }


//In your android/app/src/main/kotlin/.../MainActivity.kt file, set up a platform channel that queries Android's UsageStatsManager
// import android.app.usage.UsageStatsManager
// import android.content.Context
// import android.content.Intent
// import android.provider.Settings
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
// import java.util.Calendar

// class MainActivity: FlutterActivity() {
//     private val CHANNEL = "com.example.app/usage"

//     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//             if (call.method == "getAppScreenTime") {
//                 val packageName = call.argument<String>("packageName")
//                 if (packageName != null) {
//                     val timeSpent = getAppUsageTime(packageName)
//                     result.success(timeSpent)
//                 } else {
//                     result.error("INVALID_PACKAGE", "Package name is null", null)
//                 }
//             } else {
//                 result.notImplemented()
//             }
//         }
//     }

//     private fun getAppUsageTime(targetPackage: String): Long {
//         val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
//         val calendar = Calendar.getInstance()
//         calendar.set(Calendar.HOUR_OF_DAY, 0)
//         calendar.set(Calendar.MINUTE, 0)
//         calendar.set(Calendar.SECOND, 0)
        
//         // Query history from midnight today until right now
//         val startTime = calendar.timeInMillis
//         val endTime = System.currentTimeMillis()

//         val usageStatsList = usageStatsManager.queryUsageStats(
//             UsageStatsManager.INTERVAL_DAILY, startTime, endTime
//         )

//         for (usageStats in usageStatsList) {
//             if (usageStats.packageName == targetPackage) {
//                 // Returns total time in foreground (milliseconds)
//                 return usageStats.totalTimeInForeground 
//             }
//         }
//         return 0L
//     }
// }


//Call the platform channel from your Dart code, passing the unique package identifiers for Facebook (com.facebook.katana) and Instagram (com.instagram.android):
// import 'package:flutter/services.dart';

// class ScreenTimeTracker {
//   static const platform = MethodChannel('com.example.app/usage');

//   static Future<double> getAppMinutes(String packageName) async {
//     try {
//       // Time returned from native code is in milliseconds
//       final int milliseconds = await platform.invokeMethod('getAppScreenTime', {
//         'packageName': packageName,
//       });
      
//       // Convert milliseconds to minutes
//       return milliseconds / 1000 / 60;
//     } on PlatformException catch (e) {
//       print("Failed to invoke native stats: ${e.message}");
//       return 0.0;
//     }
//   }
// }

// // Usage inside your widgets:
// double fbMinutes = await ScreenTimeTracker.getAppMinutes("com.facebook.katana");
// double instaMinutes = await ScreenTimeTracker.getAppMinutes("com.instagram.android");


