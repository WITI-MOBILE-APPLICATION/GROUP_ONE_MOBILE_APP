// auth_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  final String id;
  final String email;
  final String name;

  User({required this.id, required this.email, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}

class AuthService {
  static const String _userKey = 'current_user';
  static const String _usersListKey = 'users_list';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Initialize the storage with default values if needed
  Future<void> initialize() async {
    final usersJson = await _storage.read(key: _usersListKey);
    if (usersJson == null) {
      await _storage.write(key: _usersListKey, value: jsonEncode([]));
      print('Initialized empty users list');
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final userJson = await _storage.read(key: _userKey);
      if (userJson == null || userJson.isEmpty) {
        print('No current user found');
        return null;
      }

      final Map<String, dynamic> userData = jsonDecode(userJson);
      return User.fromJson(userData);
    } catch (e) {
      print('Error retrieving current user: $e');
      return null;
    }
  }

  // Sign up with email and password
  Future<User?> signUp(String email, String password, String name) async {
    try {
      // Initialize if needed
      await initialize();

      // Check if user exists
      final users = await _getAllUsers();
      if (users.any((user) => user['email'] == email)) {
        print('User with email $email already exists');
        return null; // User already exists
      }

      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
      );

      // Save user to users list with password
      final userEntry = {
        ...newUser.toJson(),
        'password': password,
      };

      users.add(userEntry);
      await _storage.write(key: _usersListKey, value: jsonEncode(users));
      print('Added new user to users list. Total users: ${users.length}');

      // Set as current user
      await _storage.write(key: _userKey, value: jsonEncode(newUser.toJson()));
      print('Set current user: ${jsonEncode(newUser.toJson())}');

      // Verify storage
      await _verifyStorage();

      return newUser;
    } catch (e) {
      print('Error during signup: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      print('Attempting sign in for email: $email');

      // Initialize if needed
      await initialize();

      final users = await _getAllUsers();
      print('Found ${users.length} users in storage');

      // For debugging
      for (var user in users) {
        print('Stored user: ${user['email']}');
      }

      final userEntry = users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => <String, dynamic>{},
      );

      if (userEntry.isEmpty) {
        print('Invalid email or password for: $email');
        return null; // User not found or incorrect password
      }

      final user = User(
        id: userEntry['id'],
        email: userEntry['email'],
        name: userEntry['name'],
      );

      // Set as current user
      await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
      print('Successfully signed in user: ${user.email}');

      return user;
    } catch (e) {
      print('Error during sign in: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _storage.delete(key: _userKey);
      print('User signed out');
    } catch (e) {
      print('Error during sign out: $e');
    }
  }

  // Get user name
  Future<String?> getUserName() async {
    final user = await getCurrentUser();
    return user?.name;
  }

  // Update user name
  Future<bool> updateUserName(String newName) async {
    try {
      final user = await getCurrentUser();
      if (user == null) {
        print('Cannot update name: No current user');
        return false;
      }

      // Update in current user
      final updatedUser = User(
        id: user.id,
        email: user.email,
        name: newName,
      );
      await _storage.write(
          key: _userKey, value: jsonEncode(updatedUser.toJson()));

      // Update in users list
      final users = await _getAllUsers();
      final userIndex = users.indexWhere((u) => u['id'] == user.id);
      if (userIndex >= 0) {
        users[userIndex]['name'] = newName;
        await _storage.write(key: _usersListKey, value: jsonEncode(users));
        print('Updated user name to: $newName');
      } else {
        print('User not found in users list');
      }

      return true;
    } catch (e) {
      print('Error updating user name: $e');
      return false;
    }
  }

  // Get all users
  Future<List<Map<String, dynamic>>> _getAllUsers() async {
    try {
      final usersJson = await _storage.read(key: _usersListKey);
      if (usersJson == null || usersJson.isEmpty) {
        print('No users found in storage');
        return [];
      }

      final List<dynamic> usersList = jsonDecode(usersJson);
      return usersList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error retrieving/parsing users: $e');
      // If there's an error, reset the users list
      await _storage.write(key: _usersListKey, value: jsonEncode([]));
      return [];
    }
  }

  // Debug method to verify storage
  Future<void> _verifyStorage() async {
    try {
      final userJson = await _storage.read(key: _userKey);
      final usersJson = await _storage.read(key: _usersListKey);

      print('Current user in storage: $userJson');
      print('Users list in storage: $usersJson');
    } catch (e) {
      print('Error verifying storage: $e');
    }
  }

  // For debugging - check if users exist in storage
  Future<bool> debugCheckCredentials(String email, String password) async {
    final users = await _getAllUsers();
    final userExists = users
        .any((user) => user['email'] == email && user['password'] == password);

    print(
        'Checking credentials for $email: ${userExists ? 'Found' : 'Not found'}');
    return userExists;
  }
}