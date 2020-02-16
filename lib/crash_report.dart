import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter/foundation.dart';

class CrashReportHelper {
  static const _IOS_APP_SECRET = "8929cf1e-e2a1-4961-aa62-ee9ad9015488";
  static const _ANDROID_APP_SECRET = "b4460560-b6f4-4331-85b5-5aa3c7814c1b";

  static bool configured = false;

  static void initialize() async {
    if (!configured) {
      configured = true;
      final ios = defaultTargetPlatform == TargetPlatform.iOS;
      final appSecret = ios ? _IOS_APP_SECRET : _ANDROID_APP_SECRET;

      await AppCenter.start(appSecret, [
        AppCenterCrashes.id,
        AppCenterAnalytics.id,
      ]);
    }
  }
}
