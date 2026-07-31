import 'package:flutter/foundation.dart';
import 'package:nutriscan/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider with ChangeNotifier {
  static const String _profileKey = 'user_profile_data';

  UserProfile _profile = const UserProfile();
  bool _isLoaded = false;

  UserProfile get profile => _profile;
  bool get isLoaded => _isLoaded;

  UserProfileProvider() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? profileJson = prefs.getString(_profileKey);

      if (profileJson != null && profileJson.isNotEmpty) {
        _profile = UserProfile.fromJson(profileJson);
      } else {
        _profile = const UserProfile();
      }
    } catch (e) {
      _profile = const UserProfile();
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    _profile = newProfile;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileKey, newProfile.toJson());
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }
  }
}
