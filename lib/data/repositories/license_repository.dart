import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class LicenseRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _sess = 'active_license', _dev = 'bound_device', _exp = 'license_expires';

  // ✅ Generate a STABLE device ID that persists across page reloads
  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('stable_device_id');
    
    if (deviceId == null || deviceId.isEmpty) {
      // Generate new stable ID: WEB_ + timestamp + random
      deviceId = 'WEB_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch % 1000}';
      await prefs.setString('stable_device_id', deviceId);
      if (kDebugMode) debugPrint('🆕 Generated new device ID: $deviceId');
    }
    return deviceId;
  }

  Future<Map<String, dynamic>> validateLicense(String key) async {
    try {
      if (kDebugMode) debugPrint('🔍 Checking key: $key');
      
      final doc = await _db.collection('licenses').doc(key).get();
      
      if (kDebugMode) debugPrint('📄 Document exists: ${doc.exists}');
      
      if (!doc.exists) {
        if (kDebugMode) debugPrint('❌ Key not found in Firestore');
        return {'status': 'wrong', 'message': 'Invalid license key'};
      }
      
      final d = doc.data()!;
      
      if (kDebugMode) debugPrint('📦 Document  $d');
      
      // Check isActive
      final isActive = d['isActive'] as bool?;
      if (kDebugMode) debugPrint('✅ isActive: $isActive');
      if (isActive != true) {
        return {'status': 'inactive', 'message': 'Key not activated by admin'};
      }
      
      // Check expiry
      final expiresAt = (d['expiresAt'] as Timestamp?)?.millisecondsSinceEpoch;
      if (kDebugMode) {
        debugPrint('⏰ expiresAt: ${expiresAt != null ? DateTime.fromMillisecondsSinceEpoch(expiresAt) : 'null'}');
      }
      if (expiresAt == null || expiresAt < DateTime.now().millisecondsSinceEpoch) {
        return {'status': 'expired', 'message': 'License expired. Please renew.'};
      }
      
      // ✅ Get STABLE device ID
      final deviceId = await _getDeviceId();
      if (kDebugMode) debugPrint('📱 Stable Device ID: $deviceId');
      
      // Check device binding
      final boundId = d['boundDeviceId'] as String?;
      if (kDebugMode) debugPrint('🔗 boundDeviceId in Firestore: $boundId');
      
      // ✅ ONLY bind if not already bound (don't overwrite existing binding)
      if (boundId == null) {
        // First time activation → bind this device
        await _db.collection('licenses').doc(key).update({'boundDeviceId': deviceId});
        if (kDebugMode) debugPrint('🔐 Bound key to device: $deviceId');
      } else if (boundId != deviceId) {
        // Different device trying to use already-bound key
        if (kDebugMode) debugPrint('❌ Device mismatch: stored=$boundId, current=$deviceId');
        return {'status': 'used', 'message': 'Key already used on another device'};
      }
      // ✅ If boundId == deviceId → same device, allow access
      
      // Save session locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sess, key);
      await prefs.setInt(_exp, expiresAt!);
      
      if (kDebugMode) debugPrint('🎉 Key validated successfully');
      return {'status': 'valid', 'message': 'Activated successfully', 'expiresAt': expiresAt};
      
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('💥 Validation error: $e');
        debugPrint('📚 Stack: $stack');
      }
      return {'status': 'error', 'message': 'Connection failed. Try again.'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sess); 
    await prefs.remove(_dev); 
    await prefs.remove(_exp);
    // ✅ Don't clear stable_device_id — keep it for future activations
  }
  
  Future<String?> getActiveKey() async => (await SharedPreferences.getInstance()).getString(_sess);
  Future<int?> getExpiresAt() async => (await SharedPreferences.getInstance()).getInt(_exp);
}