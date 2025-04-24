import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_ONBOARDING_SCREEN_VIEW = "PREFS_KEY_ONBOARDING";

class AppPreferences {
  final SharedPreferences sharedPreferences;
  AppPreferences(this.sharedPreferences);

  Future<bool> getOnBoardingScreenView() async {
    return sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN_VIEW, true);
  }

  Future<bool> iSOnBoardingScreenView() async {
    return sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN_VIEW) ?? false;
  }
}
