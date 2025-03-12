import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/notify.dart';

class SharedPrefsService {
  static const String _key = 'notifications';

  static Future<List<Notify>> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString(_key);
    if (savedData != null) {
      List<dynamic> jsonList = jsonDecode(savedData);
      return jsonList.map((json) => Notify.fromJson(json)).toList();
    }
    return [];
  }

  static Future<void> saveNotifications(List<Notify> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = notifications.map((notify) => notify.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }
}
