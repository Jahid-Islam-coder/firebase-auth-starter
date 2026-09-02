import 'package:shared_preferences/shared_preferences.dart';

class WelcomePreferences {
  WelcomePreferences._();

  static String _welcomeKey(String userId) {
    return 'has_seen_welcome*$userId';
  }

  static Future<bool> hasSeenWelcome(String userId) async {
    final preferences = await SharedPreferences.getInstance();


    return preferences.getBool(_welcomeKey(userId)) ?? false;


  }

  static Future<void> markWelcomeAsSeen(String userId) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
    _welcomeKey(userId),
    true,
    );


    }
}
