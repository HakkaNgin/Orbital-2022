import 'dart:convert';

import 'package:log_in/models/firebase_login_user.dart';
import 'package:log_in/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _keyUser = 'user';

  final LoginUser tempUser = LoginUser(uid: 'sasdsdasd');
  // static const theUser = TheUser(
  //   imagePath:
  //   'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80',
  //   username: 'Sarah Abs',
  //   email: 'sarah.abs@gmail.com',
  //   // about: 'Certified Personal Trainer and Nutritionist with years of experience in creating effective diets and training plans focused on achieving individual customers goals in a smooth way.',
  //
  // );

  // static Future init() async =>
  //     _preferences = await SharedPreferences.getInstance();
  //
  // static Future setUser(TheUser user) async {
  //   final json = jsonEncode(user.toJson());
  //
  //   await _preferences.setString(_keyUser, json);
  // }

  // static TheUser getUser() {
  //   final json = _preferences.getString(_keyUser);
  //
  //   return json == null ? theUser : TheUser.fromJson(jsonDecode(json));
  // }

}