import 'package:flutter/material.dart';

import '../models/user_profile.dart';

/// Holds the current (mock) signed-in user.
class UserProvider extends ChangeNotifier {
  UserProvider({required UserProfile profile}) : _profile = profile;

  UserProfile _profile;

  UserProfile get profile => _profile;

  void updateProfile(UserProfile profile) {
    _profile = profile;
    notifyListeners();
  }
}
