import 'dart:developer';

import 'package:sahil/constants/preference_keys.dart';
import 'package:sahil/routes/routes.dart';
import 'package:sahil/utils/navigator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Singleton {
  Singleton._privateConstructor();

  static final Singleton _instance = Singleton._privateConstructor();

  static Singleton get instance => _instance;
  dynamic userID;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future setLoginData(String? obj) async {
    log("Data: $obj");
    final SharedPreferences pref = await _prefs;
    await pref.setString(PreferenceKeys.authLoginData, obj!);
    Singleton.instance.userID = obj;
  }

  Future getUserData() async {
    final SharedPreferences prefs = await _prefs;
    var data = prefs.getString(PreferenceKeys.authLoginData);
    log("Login User Data $data");
    if (data == null) {
    } else {
      Singleton.instance.userID = data;
    }
  }

  logout() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
    Singleton.instance.userID = null;
    NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginScreen);
  }
}
