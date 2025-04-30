/// A mock implementation for non-web platforms
class WebStorage {
  /// Gets an item from storage (mock implementation)
  static String? getItem(String key) {
    return null;
  }

  /// Sets an item in storage (mock implementation)
  static void setItem(String key, String value) {}

  /// Removes an item from storage (mock implementation)
  static void removeItem(String key) {}

  /// Gets all keys in storage (mock implementation)
  static List<String> getKeys() {
    return [];
  }
}
