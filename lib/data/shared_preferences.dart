import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:product_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences{
  static const keyAccessToken = 'accessToken';
  static const keyCurrentUser = 'currentUser';
  final log = Logger('Preferences');
  Future<String> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return prefs.getString(keyAccessToken);
    } catch (e) {
      log.info('UserAccessToken Prefs Error $e');
      return null;
    }
  }

  Future<bool> setAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    if(accessToken==null) {
      return prefs.remove(keyAccessToken);
    }
    return prefs.setString(keyAccessToken, accessToken);
  }

  Future<User> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      String user = prefs.getString(keyCurrentUser);
      return User.fromJson(json.decode(user));
    } catch (e) {
      log.info('CurrentUSer Prefs Error $e');
      prefs.remove(keyCurrentUser);
      return null;
    }
  }

  Future<bool> setCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    if(user==null) {
      return prefs.remove(keyCurrentUser);
    }
    return prefs.setString(keyCurrentUser, json.encode(user.toJson()));
  }
}