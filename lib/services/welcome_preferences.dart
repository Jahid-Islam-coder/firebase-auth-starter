import 'package:shared_preferences/shared_preferences.dart';

// This helps us remember if a user has already seen the welcome screen
class WelcomePreferences {
  WelcomePreferences._();

  // Create a unique key for each user
  static String _welcomeKey(String userId) {
    return 'has_seen_welcome*$userId';
  }

  // Check if this user has already seen the welcome message
  static Future<bool> hasSeenWelcome(String userId) async {
    // Get the shared preferences instance
    final preferences = await SharedPreferences.getInstance();

    // Return the value, or false if it hasn't been set yet
    return preferences.getBool(_welcomeKey(userId)) ?? false;
  }

  // Save that this user has now seen the welcome message
  static Future<void> markWelcomeAsSeen(String userId) async {
    final preferences = await SharedPreferences.getInstance();

    // Set the value to true in the phone's storage
    await preferences.setBool(
      _welcomeKey(userId),
      true,
    );
  }
}
