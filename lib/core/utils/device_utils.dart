import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceUtils {
  static Future<String> getDeviceId() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('web_device_id');
      if (id == null) {
        id = 'WEB-${Random().nextInt(999999)}';
        await prefs.setString('web_device_id', id);
      }
      return id;
    }
    // Mobile: Replace with device_info_plus in production
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('mobile_device_id');
    if (id == null) {
      id = 'MOB-${Random().nextInt(999999)}';
      await prefs.setString('mobile_device_id', id);
    }
    return id;
  }
}
