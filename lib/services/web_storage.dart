@JS()
library web_storage;

import 'dart:js_util';
import 'package:js/js.dart';
import 'dart:html' as html;

/// A class to interact with the browser's localStorage
class WebStorage {
  /// Gets an item from localStorage
  static String? getItem(String key) {
    return html.window.localStorage[key];
  }

  /// Sets an item in localStorage
  static void setItem(String key, String value) {
    html.window.localStorage[key] = value;
  }

  /// Removes an item from localStorage
  static void removeItem(String key) {
    html.window.localStorage.remove(key);
  }

  /// Gets all keys in localStorage
  static List<String> getKeys() {
    return html.window.localStorage.keys.toList();
  }
}
